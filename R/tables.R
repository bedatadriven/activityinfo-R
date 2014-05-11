

#' getSitesDataFrame
#' 
#' Fetch the sites for an activity as a data.frame
#' @export
getSitesDataFrame <- function(databaseId, activityId) {
  
  # fetch this activity's schema
  db <- getDatabaseSchema(database_id)
  activityIds <- sapply(db$activities, function(a) a$id )
  
  # double check that database / activity corresponds
  if( !(activityId %in% activityIds)) {
    stop(sprintf("database %s (id=%d) has no activity with id=%d", 
         db$name, database_id, activityId))
  }
  
  # get the activity schema
  activity <- db$activities[[ which(activityIds == activityId) ]]
  
  # fetch the site data
  sites <- get_sites(activityId)
  
  columns <- list(
    siteId =               extractField(sites, "id"),
    activityId =           extractField(sites, "activity"),
    startDate =    as.Date(extractField(sites, "startDate")),
    endDate =      as.Date(extractField(sites, "endDate")),
    locationId =     extractNestedField(sites, "location", "id"),
    locationName =   extractNestedField(sites, "location", "name"),
    latitude =       extractNestedField(sites, "location", "latitude"),
    longitude =      extractNestedField(sites, "location", "longitude"),
    partnerId =      extractNestedField(sites, "partner", "id"),
    partnerName =    extractNestedField(sites, "partner", "name")
  )
  
  data.frame(columns, stringsAsFactors=FALSE)
}

#' asActivityDataFrame
#' 
#' Creates a data.frame containing a list of activities
#' and their properties from the given database schema
#' 
#' @export
asActivityDataFrame <- function(databaseSchema) {
  
  activities <- databaseSchema$activities
  df <- data.frame(
    databaseId =                          databaseSchema$id,
    activityId =             extractField(activities, "id"),
    activityName =           extractField(activities, "name"),
    activityCategory =       extractField(activities, "category"),
    reportingFrequency     = extractField(activities, "reportingFrequency"),
    locationTypeName = extractNestedField(activities, "locationType", "name"),
    published =             (extractField(activities, "published") == 1)
  )
  df
}


# helper functions to make other functions to extract 
# the data from the list for us
extractField <- function(sites, fieldName)
  sapply(sites, function(site) {
    x <- site[[fieldName]]
    if(!is.null(x) && is.atomic(x)) {
      x
    } else {
      NA
    }
  })


extractNestedField <- function(sites, fieldName, nestedFieldName)
  sapply(sites, function(site) {
    obj <- site[[fieldName]]
    if(is.list(obj)) {
      x <- obj[[nestedFieldName]]
      if(!is.null(x) && is.atomic(x)) {
        x
      } else {
        NA
      }
    } else {
      NA
    }
  })