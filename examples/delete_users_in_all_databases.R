
## This script helps clean up old users from all databases
##
## To use this script, save a list of email addresses to a text file called "to_delete.txt" with ONLY an email address
## on each line. For example,
##
## a@exmaple.com
## b@example.com

library(activityinfo)
activityInfoLogin()

databases <- getDatabases()

emailsToDelete <- tolower(readLines("to_delete.txt"))

users <- getDatabaseUsers(databaseId)

for(user in users) {
  if(tolower(user$email) %in% emailsToDelete) {
    cat(sprintf("Deleting %s...\n", user$email))
    #deleteDatabaseUser(databaseId, user$userId)
  }
}