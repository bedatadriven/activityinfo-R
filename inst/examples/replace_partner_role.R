library(activityinfo)

databaseId <- "chnbartkk3qymgi3"
oldPartnerFormId <- "ck5dxt1712"
newPartnerFormId <- "cbvrp58kk3qymgj1d"

# Now update the roles so they reference the new partner form in 
# their parameter and filter rules

db <- getDatabaseTree(databaseId)


for(role in db$roles) {
  if(length(role$parameters) > 0) {
    role$parameters[[1]]$range <- newPartnerFormId
    role$filters[[1]]$filter <- gsub(x = role$filters[[1]]$filter, 
                                     pattern = oldPartnerFormId, 
                                     replacement = newPartnerFormId, 
                                     fixed = TRUE)
    
    for(i in seq_along(role$permissions)) {
      if(is.character(role$permissions[[i]]$filter)) {
        role$permissions[[i]]$filter <- gsub(x = role$permissions[[i]]$filter, 
                                             pattern = oldPartnerFormId, 
                                             replacement = newPartnerFormId, 
                                             fixed = TRUE)
      } else {
        role$permissions[[i]]$filter <- NULL
      }
    }
    
    activityinfo:::updateRole(db$databaseId, role)

  }
}

# Now update any existing users who have been assigned, by record id, to the old list of 
# partners


# First, build a mapping between the old partners and the new partners, by name.
# BOTh partner forms MUST have a field with the code "name"

correctPartners <- queryTable(newPartnerFormId, id = "_id", name = "name")
correctPartnerLookup <- paste(newPartnerFormId, correctPartners$id, sep = ":")
names(correctPartnerLookup) <- correctPartners$name

oldPartners <- queryTable(oldPartnerFormId, id = "_id", name="name")
oldPartnerLookup <- oldPartners$name
names(oldPartnerLookup) <- paste(oldPartnerFormId, oldPartners$id, sep = ":")

# Now get the list of existing users
users <- getDatabaseUsers(databaseId)

# And update their role assignments using the lookup tables

for(user in users) {
  if(!is.null(user$role$parameters$partner)) {
      partnerName <- as.character(oldPartnerLookup[user$role$parameters$partner])
      newPartnerRef <- as.character(correctPartnerLookup[partnerName])
      if(!is.na(newPartnerRef)) {
        assignment <- user$role
        assignment$parameters$partner <- newPartnerRef
        updateUserRole(db$databaseId, user$userId, assignment)
      } else {
        cat(sprintf("Couldn't match user %s to partner %s\n", user$email, deparse(partnerName)))
      }
  }
}