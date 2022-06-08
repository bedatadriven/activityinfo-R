
# This script updates all users in a database to grant them
# access to an additional folder

libary(activityinfo)

# Fetch the users' current permissions
databaseId <- "copy_your_database_id"
users <- getDatabaseUsers(databaseId)

# The additional folder to add to everyone. Can also be a form.
folderId <- "copy_your_folder_id"

for(user in users) {
  role <- user$role
  
  # If the user has access to the whole database, skip.
  if(databaseId %in% role$resources || folderId %in% role$resources) {
    next
  }
  
  # Update the role assignment to include the new folder
  role$resources <- c(role$resources, folderId)
  
  # Submit the request to update the user's role
  updateUserRole(databaseId = databaseId, userId = user$userId, assignment = role)
  
}