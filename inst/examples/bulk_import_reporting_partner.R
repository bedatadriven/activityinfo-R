
library(activityinfo)

# Read in a list of users from a CSV file and add them all to a database
# created using the Multi-partner reporting template


# This is the id of the database to which the users will be added
databaseId <- "cp7r1hfl1gqx2zv2"

# The csv file should have an name, email, and partner columns
users <- read.csv("examples/users.csv")


### Do the import

# Read the database tree
databaseTree <- getDatabaseTree(databaseId)

# Find the reporting partner role
roles <- sapply(databaseTree$roles, function(r) r$label)
role <- databaseTree$roles[[which(roles == "Reporting partner")]]

# And the corresponding partner form
partnerFormId <- role$parameters[[1]]$range

# Know read in the least of partners so we can match it against the
# names of partners in the CSV list.
partners <- queryTable(partnerFormId, partnerId = "_id", partner = "name")

# Find the partner Id for each of the users
users <- merge(users, partners)

# These are the ids of the forms, folder, or database that the user will
# have access to. By default, the databaseId, which will give the user access
# to all forms and folders
resources <- list(databaseId)

for(i in 1:nrow(users)) {
  
  partnerRef <- reference(partnerFormId, users[i, "partnerId"])
  
  addDatabaseUser(databaseId = databaseId, 
                  email = users[i, "email"], 
                  name = users[i, "name"],
                  locale = "en",
                  roleId = role$id,
                  roleParameters = list(partner = partnerRef),
                  roleResources = resources)
  
}
