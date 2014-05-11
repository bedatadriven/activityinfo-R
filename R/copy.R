
#' Creates copies of all existing activities in another
#' database
#' 
#' @export
cloneDatabase <- function(sourceDatabaseId, targetDatabaseId) {
  
  sourceSchema <- getDatabaseSchema(sourceDatabaseId)
  
  for(i in seq_along(sourceSchema$activities)) {
    cloneActivity(sourceSchema$activities[[i]], targetDatabaseId) 
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

