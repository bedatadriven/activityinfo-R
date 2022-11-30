
# set standard connection to stdin() for user interaction
.onLoad <- function(libname, pkgname){
  message("Setting standard input...")
  options(activityinfo.interactive = stdin())
}

credentialsFile <- "~/.activityinfo.credentials"

credentials <- environment()

#' Get or set the root url for the ActivityInfo
#'
#' @description
#' This call gets or sets the root url used for a session, \emph{valid only
#' during the session}.
#'
#' @export
activityInfoRootUrl <- local({

  url <- "https://www.activityinfo.org"

  function(new.url) {
    if(!missing(new.url)) {
      url <<- new.url
      invisible()
    } else {
      url
    }
  }

})


#' Constructs a httr::authentication object from saved credentials
#' from the user's home directory at ~/.activityinfo.credentials
#'
#' @importFrom httr authenticate
#' @noRd
activityInfoAuthentication <- local({

  credentials <- NULL

  function(newValue) {
    
    if(!missing(newValue)) {
      credentials <<- newValue
    } else {
      # Look for credentials first in ~/.activityinfo.credentials
      if(is.null(credentials) && file.exists(credentialsFile)) {
        cat(sprintf("Reading credentials from %s...\n", path.expand(path = credentialsFile)))
        line <- readLines("~/.activityinfo.credentials", warn = FALSE)[1]
        if(nchar(line) <= 2) {
          cat(sprintf("...file exists, but is empty or improperly formatted.\n", path.expand(path = credentialsFile)))
        } else {
          if(credentialType(line) == "basic") deprecationOfBasicAuthWarning()
          credentials <<- line
        }
      }

      if(is.null(credentials)) {
        warning("Connecting to activityinfo.org anonymously...")
        NULL
      } else {
        type <- credentialType(credentials)
        if(type == "basic") {
          userPass <- unlist(strsplit(credentials, ":"))
          authenticate(userPass[1], userPass[2], type = "basic")
        } else if(type == "bearer") {
          add_headers(Authorization = paste("Bearer", credentials, sep = " "))
        }
        
      }
    }
  }
})

credentialType <- function(credentials) {
  if(nchar(credentials) > 2) {
    if(grepl(credentials, pattern = ".+:.+")) {
      return("basic")
    } else {
      return("bearer")
    }
  }
  stop("ActivityInfo credential not a valid type.")
}

readline2 <- function(prompt) {
  cat(prompt)
  readLines(con = getOption("activityinfo.interactive"), n = 1)
}

#' Store personal token to authorize requests for the
#' ActivityInfo API
#'
#' @description
#' Configures the current session to use a personal token for authentication to \href{www.activityinfo.org}{ActivityInfo.org}
#'
#' @param token The personal token used to authenticate with to ActivityInfo.org
#'
#' @examples \dontrun{
#' activityInfoToken("<API TOKEN>")
#' }
#' @export
activityInfoToken <- function(token) {
  
  if (interactive() && missing(token)) {
    token <- readline2("Enter your token: ")
  }
  
  activityInfoAuthentication(token)
  
  if(interactive()) {
    cat("Do you want to save your token for future R sessions?\n")
    cat("WARNING: If you choose yes, your token will be stored plain text in your home\n")
    cat("directory. Don't choose this option on an insecure or public machine! (Y/n)\n")
    
    save <- readline2("Save token? ")
    if(substr(tolower(save), 1, 1) == "y") {
      cat(token, file=credentialsFile)
    }
  }
}

deprecationOfBasicAuthWarning <- function() {
  warning("The ActivityInfo API is deprecating the use of username and passwords. Update your code to use a personal API token before the functionality is removed.", call. =  FALSE, noBreaks. = TRUE)
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
#' @examples \dontrun{
#' activityInfoLogin("nouser@@activityinfo.org", "pass")
#' }
#' @export
activityInfoLogin <- function(userEmail, password) {
  
  deprecationOfBasicAuthWarning()
  
  if (missing(userEmail) || missing(password)) {
    attempts <- 0
    repeat {
      userEmail <- readline2("Enter the email address you use to login to ActivityInfo.org: ")
      if(grepl(userEmail, pattern='.+@.+')) {
        break;
      }
      cat("Not an email address...\n")
      attempts <- 1
      if(attempts >= 3) {
        stop("Invalid email address, must contain at least a '@' !")
        attempts <- attempts + 1
      }
    }
    password <- readline2("Enter your password: ")
  }
  
  credentials <- paste(userEmail, password, sep = ":")
  activityInfoAuthentication(credentials)
  
  if(interactive()) {
    cat("Do you want to save your password for future R sessions?\n")
    cat("WARNING: If you choose yes, your password will be stored plain text in your home\n")
    cat("directory. Don't choose this option on an insecure or public machine! (Y/n)\n")

    save <- readline2("Save password? ")
    if(substr(tolower(save), 1, 1) == "y") {
      cat(credentials, file=credentialsFile)
    }
  }
}
