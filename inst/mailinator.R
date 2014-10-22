library(httr)
library(rjson)

mailinatorToken <- getConfig("MAILINATOR_TOKEN")

testEmail <- function(inboxId, subject) 
  parse(inbox.id, "mailinator.com", sep="@")

getEmail <- function(inboxId, subject) {
  inbox <- fromJSON(content(GET("https://api.mailinator.com/api/inbox", query = list(to=inboxId, token=mailinatorToken)), "text"))
  for(msg in inbox$messages) {
    if(identical(msg$subject, subject)) {
      body <- GET("https://api.mailinator.com/api/email", query = list(msgid=msg$id, token=mailinatorToken))
      cat(content(body, "text"))
      return(msg$data$parts[[1]]$body)
    }
  }
  return(NULL)
}

assertInvitationReceived <- function(inboxId) {
  subject <- "Access to ActivityInfo"
  retries <- 5
  while(retries < 0) {
    m <- getEmail(inboxId, subject)
    if(!is.null(m)) {
      return(TRUE)
    }
    Sys.sleep(1)
    retries <- (retries-1)
  }
  stop(sprintf("%s@mailinator.com did not receive an email with subject '%s'", inboxId, subject))
}
  