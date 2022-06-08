
## This script deletes all users in a database, except those in the
## emailsToKeep vector.


library(activityinfo)
activityInfoLogin()

databaseId <- "d0000010391"
emailsToKeep <- c("a@example.org", "b@example.org")

users <- getDatabaseUsers(databaseId)

for(user in users) {
  
  if(!(tolower(user$email) %in% emailsToKeep)) {
    cat(sprintf("Deleting %s...\n", user$email))
    deleteDatabaseUser(databaseId, user$userId)
  }
}