
# set standard connection to stdin() for user interaction
.onLoad <- function(libname, pkgname) {
  options(activityinfo.verbose.requests = FALSE)
  options(activityinfo.verbose.tasks = FALSE)
}

credentialsFile <- "~/.activityinfo.credentials"

credentials <- environment()

# ---- activityInfoRootUrl() ----

#' Get or set the root url for the ActivityInfo server
#'
#' @description
#' Get or set the root url for the ActivityInfo server
#'
#' @param newUrl The new URL to set as the ActivityInfo root URL
#'
#' @details 
#' If you are using the [ActivityInfo Self-Managed Server](https://www.activityinfo.org/support/docs/self-managed/index.html),
#' you can use this function to point the R package to your own server. 
#' 
#' @examples
#' \dontrun{
#' # Connect to a self-managed ActivityInfo server
#' activityInfoRootUrl("https://activityinfo.example.org")
#' }
#' @export
activityInfoRootUrl <- local({
  url <- "https://www.activityinfo.org"
  function(newUrl) {
    if (!missing(newUrl)) {
      url <<- newUrl
      invisible()
    } else {
      url
    }
  }
})

# ---- ActivityInfoAuthentication() ----

#' Constructs a httr::authentication object from saved credentials
#' from the user's home directory at ~/.activityinfo.credentials
#'
#' @importFrom httr authenticate add_headers
#' @noRd
activityInfoAuthentication <- local({
  credentials <- NULL
  
  function(newValue) {
    if (!missing(newValue)) {
      credentials <<- newValue
    } else {
      # Look for credentials first in ~/.activityinfo.credentials
      if (is.null(credentials) && file.exists(credentialsFile)) {
        # message(sprintf("Reading credentials from %s...\n", path.expand(path = credentialsFile)))
        line <- readLines("~/.activityinfo.credentials", warn = FALSE)[1]
        if (nchar(line) <= 2) {
          warning(sprintf("...file exists, but is empty or improperly formatted.\n", path.expand(path = credentialsFile)))
        } else {
          if (credentialType(line) == "basic") deprecationOfBasicAuthWarning()
          credentials <<- line
        }
      }
      
      if (is.null(credentials)) {
        warning("Connecting to activityinfo.org anonymously...")
        NULL
      } else {
        type <- credentialType(credentials)
        if (type == "basic") {
          userPass <- unlist(strsplit(credentials, ":"))
          authenticate(userPass[1], userPass[2], type = "basic")
        } else if (type == "bearer") {
          httr::add_headers(Authorization = paste("Bearer", credentials, sep = " "))
        }
      }
    }
  }
})

# ---- Other functions ----
credentialType <- function(credentials) {
  if (nchar(credentials) > 2) {
    if (grepl(credentials, pattern = ".+:.+")) {
      return("basic")
    } else {
      return("bearer")
    }
  }
  stop("ActivityInfo credential not a valid type.")
}


#' Store personal token to authorize requests for the
#' ActivityInfo API
#'
#' @description
#' Configures the current session to use a personal token for authentication to 
#' the ActivityInfo Server. 
#'
#' @param token The personal token used to authenticate with to ActivityInfo.org
#' @param prompt TRUE if to prompt the user to save the token
#'
#' @details 
#' Users can generate a personal API token from the [Profile Settings](https://www.activityinfo.org/support/docs/m/84880/l/1333305.html)
#' page of ActivityInfo's user interface. This token is used instead of a password
#' when connecting to the ActivityInfo API.
#' 
#' Note, in general, you [*never* include your API token](https://blog.gitguardian.com/secrets-api-management/)
#' in an R source file or check such sources with tokens into version control.
#' 
#' When run interactively and prompt = TRUE, you will be prompted to store the token locally on 
#' your device. This avoids the need to provide the token each time you run
#' a script. The token is stored in plaintext, however, so you should only 
#' agree to store your token when your device is properly secured with a screenlock
#' and not shared with others.
#' 
#' 
#' 
#' @examples 
#' \dontrun{
#' activityInfoToken("<API TOKEN>")
#' }
#' @export
activityInfoToken <- function(token, prompt = TRUE) {
  if (interactive() && missing(token)) {
    token <- readline("Enter your token: ")
  }
  
  activityInfoAuthentication(token)
  
  if (interactive() && prompt) {
    cat("Do you want to save your token for future R sessions?\n")
    cat("WARNING: If you choose yes, your token will be stored plain text in your home\n")
    cat("directory. Don't choose this option on an insecure or public machine! (Y/n)\n")
    
    save <- readline("Save token? ")
    if (substr(tolower(save), 1, 1) == "y") {
      cat(token, file = credentialsFile)
    }
  }
}

deprecationOfBasicAuthWarning <- function() {
  warning("The ActivityInfo API is deprecating the use of username and passwords. Update your code to use a personal API token with the function activityInfoToken() before the functionality is removed.", call. = FALSE, noBreaks. = TRUE)
}

#' Use Basic Authentication (deprecated) to authenticate and store user credentials to authorize requests for the
#' ActivityInfo API
#'
#' @description
#' Configures the current session to use a user's email address and
#' password for authentication to \href{www.activityinfo.org}{ActivityInfo.org}
#'
#' This function is deprecated. Switch to the more secure activityInfoToken() with a personal access token.
#'
#' @param userEmail The email address used to log in with to ActivityInfo.org
#' @param password The user's ActivityInfo password
#'
#' @examples 
#' \dontrun{
#' activityInfoLogin("nouser@activityinfo.org", "pass")
#' }
#' @export
activityInfoLogin <- function(userEmail, password) {
  .Deprecated("activityInfoToken")
  deprecationOfBasicAuthWarning()
  
  if (missing(userEmail) || missing(password)) {
    attempts <- 0
    repeat {
      userEmail <- readline("Enter the email address you use to login to ActivityInfo.org: ")
      if (grepl(userEmail, pattern = ".+@.+")) {
        break
      }
      cat("Not an email address...\n")
      attempts <- 1
      if (attempts >= 3) {
        stop("Invalid email address, must contain at least a '@' !")
        attempts <- attempts + 1
      }
    }
    password <- readline("Enter your password: ")
  }
  
  credentials <- paste(userEmail, password, sep = ":")
  activityInfoAuthentication(credentials)
  
  if (interactive()) {
    cat("Do you want to save your password for future R sessions?\n")
    cat("WARNING: If you choose yes, your password will be stored plain text in your home\n")
    cat("directory. Don't choose this option on an insecure or public machine! (Y/n)\n")
    
    save <- readline("Save password? ")
    if (substr(tolower(save), 1, 1) == "y") {
      cat(credentials, file = credentialsFile)
    }
  }
}
