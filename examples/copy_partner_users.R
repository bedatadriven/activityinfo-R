

# Copy all users who have a "Reporting partner" role in one database to another database

# This script has several requirements:
# - Both databases MUST have a role called "Reporting partner"
# - Both of these roles must have a single parameter
# - Both of these databases must have a partner form with a field called "Name"

library(activityinfo)
activityInfoLogin()


fromDatabaseId <- "ck2yrizmo2"
toDatabaseId <- "ck3ee6my46"
role <- "Reporting Partner"

fromDatabaseTree <- getDatabaseTree(fromDatabaseId)
fromRoles <- sapply(fromDatabaseTree$roles, function(r) r$label)

fromRole <- fromDatabaseTree$roles[[which(fromRoles == "Reporting Partner")]]

toDatabaseTree <- getDatabaseTree(toDatabaseId)
toRoles <- sapply(toDatabaseTree$roles, function(r) r$label)

toRole <- toDatabaseTree$roles[[which(toRoles == "Reporting partner")]]

stopifnot(length(fromRole$parameters) == 1)
stopifnot(length(toRole$parameters) == 1)

fromPartnerParameter <- fromRole$parameters[[1]]
toPartnerParameter <- toRole$parameters[[1]]

# Build a mapping between the source database's partners and the target database's partners
# Using their name

fromPartners <- queryTable(fromPartnerParameter$range, fromId = "_id", name = "name")
toPartners <- queryTable(toPartnerParameter$range, toId = "_id", name = "name")

partnerMapping <- merge(x = fromPartners, y = toPartners, by = "name", all = TRUE)
partnerMapping$fromRef <- reference(fromPartnerParameter$range, partnerMapping$fromId)
partnerMapping$toRef <- reference(toPartnerParameter$range, partnerMapping$toId)

users <- getDatabaseUsers(fromDatabaseId)

for(user in users) {
  if(user$role$id == fromRole$id) {
    
    cat(sprintf("Adding %s...\n", user$email))
    
    fromPartnerRef <- user$role$parameters[[fromPartnerParameter$parameterId]]
    partnerRow <- which(partnerMapping$fromRef == fromPartnerRef)
    
    toPartnerRef <- partnerMapping$toRef[partnerRow]
    if(is.na(toPartnerRef)) {
      stop(sprintf("Partner '%s' missing in target database", partnerMapping$name[partnerRow]))
    }
    
    parameters = list()
    parameters[[toPartnerParameter$parameterId]] <- toPartnerRef
  
    result <- addDatabaseUser(toDatabaseId, user$email, user$name, roleId = toRole$id, roleParameters = parameters)
    if(result$added) {
      cat("...User added\n")
    } else if(identical(result$error$code, "USER_ALREADY_ADDED")) {
      cat("...User already added.\n")
    } else {
      stop(paste0("Failed to add user: ", result$error$code))
    }
  }
}


