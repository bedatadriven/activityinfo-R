
#' Creates copies of all existing activities in another
#' database
#' 
#' @export
cloneDatabase <- function(sourceDatabaseId, targetDatabaseId) {
  
  sourceSchema <- getDatabaseSchema(sourceDatabaseId)
  
  # Clone each activity/form
  for(i in seq_along(sourceSchema$activities)) {
    cloneActivity(sourceSchema$activities[[i]], targetDatabaseId) 
  }
}

# Function to read partner names from a database with numeric identifier 
# provided by 'databaseId'. Returns a character vector with one or more partner
# names.
getPartnerNames <- function(databaseId) {
  schema <- getDatabaseSchema(databaseId)
  partners <- schema$partners
  
  # pull partner names out of list into a vector:
  partner.names <- sapply(schema$partners, function(p) { p$name })
}

#' Copies the partners linked to 'sourceDatabase' to each database
#' in the vector 'targetDatabase'. Databases are identified by their numeric
#' identifier and you must, of course, have access to all databases.
#' 
#' @param sourceDatabase the id of the source database
#' @param targetDatabase the id of the target database 
#' @export
copyPartners <- function(sourceDatabase, targetDatabase) {
  
  partner.names <- getPartnerNames(sourceDatabase)
  
  for (database in targetDatabase) {  
    database.partners <- getPartnerNames(database)
    for (partner in partner.names) {
      if (!(partner %in% database.partners)) {
        cat("Updating partner '", partner, "'' to database ", database,
            "\n", sep="")
        tryCatch(executeCommand("UpdatePartner",
                                databaseId=database,
                                partner=list(name=partner)),
                 error=function(e) {
                   cat("Failed to add partner '", partner, "' with error: ", e,
                       "\n", sep="")
                 }
        )
      }
    }
  }
  cat("Done.\n")
  invisible()
}

#' Copies users and their authorizations from a source to a target database. Any partners
#' that are not yet present in the target database are copied from the source database.
#' 
#' @param sourceDatabase the id of the source database
#' @param targetDatabase the id of the target database 
#' @export
copyUsers <- function(sourceDatabase, targetDatabase) {
  copyPartners(sourceDatabase, targetDatabase)
  users <- getAuthorizedUsers(sourceDatabase)
  for(user in users) {
    updateUserPermissions(databaseId=targetDatabase, 
                          userEmail=user$email, userName=user$name, 
                          partner = user$partner$id,
                          allowView = user$allowView,
                          allowViewAll = user$allowViewAll,
                          allowEdit = user$allowEdit,
                          allowEditAll = user$allowEditAll,
                          allowDesign = user$allowEditDesign,
                          allowManageUsers = user$allowManageUsers,
                          allowManageAllUsers = user$allowManageAllUsers)
  }
} 


#' Deletes all activities within a given database
#' 
#' @export
deleteAllActivitiesInDatabase <- function(databaseId) {
  
  database <- getDatabaseSchema(databaseId)
  
  if(interactive()) {
    cat(sprintf("Are you sure you want to delete all activities in '%s'?\n", database$name))
    cat("Enter the name of the database to continue...\n")
    confirm <- readline()
    if(!identical(confirm, database$name)) {
      stop("Aborted")
    }
  }
  
  for(activity in database$activities) {
    deleteActivity(activity$id)
  }
  
}

#' Creates a copy of an existing activity
#' 
#' @export
cloneActivity <- function(activity, targetDatabaseId) {
  
  cat(sprintf("Cloning activity %s\n", paste(activity$category, activity$name, sep="/")))
  targetActivityId <- createActivity(databaseId = targetDatabaseId, 
                      name = activity$name,
                      category = activity$category,
                      locationTypeId = activity$locationType$id,
                      reportingFrequency = activity$reportingFrequency)
  
  # Indicators
  sourceIndicatorIds <- c()
  targetIndicatorIds <- c()
  for(i in seq_along(activity$indicators)) {
    sourceIndicatorIds[i] <- activity$indicators[[i]]$id
    targetIndicatorIds[i] <- do.call("createIndicator", c(
                activityId = targetActivityId, 
                activity$indicators[[i]],
                sortOrder = i)) 
  
  }
  
  # Clone Attribute Groups / Indicators
  attributeIndex <- 1
  sourceAttributeIds <- c()
  targetAttributeIds <- c()
  for(i in seq_along(activity$attributeGroups)) {
    attributeGroup <- activity$attributeGroups[[i]]
    targetGroupId <- do.call("createAttributeGroup", c(
      activityId = targetActivityId,
      attributeGroup))
    
    for(attribute in attributeGroup$attributes) {
      sourceAttributeIds[attributeIndex] <- attribute$id
      targetAttributeIds[attributeIndex] <- createAttribute(
        attributeGroupId = targetGroupId,
        name = attribute$name)
      attributeIndex <- attributeIndex + 1
    }
  }

  # Clone the sites themeslves
  sites <- getSites(activity$id)
  for(i in seq_along(sites)) {
    site <- sites[[i]]  
    
    cat(sprintf("Cloning site %d\n", site$id))
    
    target <- list()
    target$id <- generateId()
    target$reportingPeriodId <- generateId()
    target$activityId <- targetActivityId
    target$date1 <- site$startDate
    target$date2 <- site$endDate
    target$locationId <- site$location$id
    target$partnerId <- site$partner$id
    target$comments <- site$comments
    
    for(indicatorId in names(site$indicatorValues)) {
      indicatorIndex <- match(x = as.integer(indicatorId), sourceIndicatorIds)
      targetIndicatorId <- targetIndicatorIds[indicatorIndex]
      propertyName <- paste("I", targetIndicatorId, sep="")
      target[[ propertyName ]] <- site$indicatorValues[[indicatorId]]
    }
    
    for(sourceAttributeId in site$attributes) {
      attributeIndex <- match(x = sourceAttributeId, table = sourceAttributeIds)
      targetAttributeId <- targetAttributeIds[attributeIndex]
      propertyName <- paste("ATTRIB", targetAttributeId, sep="")
      target[[ propertyName ]] <- TRUE
    }
    
    createSite(target) 
  }
}

