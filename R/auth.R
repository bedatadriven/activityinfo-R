
credentialsFile <- "~/.activityinfo.credentials"

credentials <- environment()

#' activityInfoRootUrl
#' 
#' gets or sets the root url used for this session
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
activityInfoAuthentication <- local({
  
  credentials <- NULL
  
  function(newValue) {
  
    if(!missing(newValue)) {
      credentials <<- newValue
    
    } else {
      
      # Look for credentials first in ~/.activityinfo.credentials
      if(is.null(credentials) && file.exists(credentialsFile)) {
        cat(sprintf("Reading username:password from %s...\n", path.expand(path=credentialsFile)))
        line <- readLines("~/.activityinfo.credentials", warn=FALSE)[1]
        if(nchar(line) > 2 && grepl(line, pattern=".+:.+")) {
          credentials <<- line
        } else {
          cat(sprintf("...file exists, but is empty or improperly formatted.\n", path.expand(path=credentialsFile)))
        }
      }
      
      if(is.null(credentialsFile)) {
        warning("Connecting to activityinfo.org anonymously...")
        NULL
        
      } else {
        userPass <- unlist(strsplit(credentials, ":"))
        httr::authenticate(userPass[1], userPass[2], type = "basic")
      }
    }
  }
})

#' Configures the current session to use a user's email address and 
#' password for authentication to ActivityInfo.org.
#' 
#' @param userEmail The email address used to log in with to ActivityInfo.org
#' @param password The user's ActivityInfo password
#' @export
activityInfoLogin <- function(userEmail, password) {
  
  if(missing(userEmail) || missing(password)) {
    attempts <- 0
    repeat {
      userEmail <- readline("Enter the email address you use to login to ActivityInfo.org: ")
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
    password <- readline("Enter your password: ")
  }
  
  credentials <- paste(userEmail, password, sep=":")
  activityInfoAuthentication(credentials)
  
  if(interactive()) {
    cat("Do you want to save your password for future R sessions?\n")
    cat("WARNING: If you choose yes, your password will be stored plain text in your home\n")
    cat("directory. Don't choose this option on an insecure or public machine! (Y/n)\n")
    
    save <- readline("Save password? ")
    if(substr(tolower(save), 1, 1) == "y") {
      cat(credentials, file=credentialsFile)
    }
  }
}