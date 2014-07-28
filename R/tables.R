

#' getSitesDataFrame
#' 
#' Fetch the sites for an activity as a data.frame
#' 
#' If the activity has monthly reporting, indicator values will
#' only be fetched if the month is specified
#' 
#' @param activity an activity object
#' @param month the month for which to fetch indicator values, in 
#'              the format '2014-02'
#'              
#' @examples \dontrun{
#' clusterDb <- getDatabase(4)
#' nfi <- clusterDb$activities[[1]]
#' df <- getSitesDataFrame(nfi, '2014-02')
#' }
#' @export
getSitesDataFrame <- function(activity) {
  
  # fetch the site data  
  sites <- getSites(activity$id)
  
  columns <- list()
  columns$siteId <- extractField(sites, "id")
  columns$activityId <- extractField(sites, "activity")
  
  if(activity$reportingFrequency == 0) {
    columns$startDate <- extractField(sites, "startDate")
    columns$endDate <- extractField(sites, "endDate")
  }

  columns$locationId <- extractNestedField(sites, "location", "id")
  columns$locationName <- extractNestedField(sites, "location", "name")
  columns$latitude <- extractNestedField(sites, "location", "latitude")
  columns$longitude <- extractNestedField(sites, "location", "longitude")
  columns$partnerId <- extractNestedField(sites, "partner", "id")
  columns$partnerName <- extractNestedField(sites, "partner", "name")

  
  for(group in activity$attributeGroups) {
    if(group$multipleAllowed) {
      for(attrib in group$attributes) {
        columns[[paste(group$name, ".", attrib$name)]] <- 
          sapply(sites, function(s) attrib$id %in% s$attributes)
      }
    } else {
      value <- character(length(sites))
      if(length(sites) > 0) {
        for(attrib in group$attributes) {
          present <- sapply(sites, function(s) attrib$id %in% s$attributes)
          value[present] <- attrib$name
        }
      }
      columns[[group$name]] <- value
    }
  }
  data.frame(columns, stringsAsFactors=FALSE)
}

#' getMonthlyReportsCube
#' 
#' Retrieves a data.frame containing sites and indicators in rows  
#' 
#' @param activityId the activityid
#' @param month the calendar month to retrieve in the format '2014-02'
#' 
#' @examples
#' \dontrun{ 
#' db <- getDatabase(1064)
#' sites <- getSitesDataFrame(db$activities[[1]])
#' cube <- getMonthlyReportsCube(1064, '2014-06')
#' merge(sites, cube)
#' }
#' @export
getMonthlyReportsCube <- function(activityId, month) {
  
  cube <- getResource("sites/cube", form = activityId, dimension = "indicator", dimension = "site", month = month)

  columns <- list()
  columns$siteId <- extractDimension(cube, "Site", "id")
  columns$indicatorName <- extractDimension(cube, "Indicator", "label")
  columns$indicatorId <-   extractDimension(cube, "Indicator", "id")
  columns$month <- rep(month, length(cube))
  columns$value <-  extractBucketValue(cube)

  data.frame(columns, stringsAsFactors=FALSE)
}

#' getMonthlyReportsCubeForDatabase
#' 
#' Retrieves a data.frame containing the siteId, indicatorId, and 
#' indicatorName, month, and value columns for all sites in the 
#' given database, combined with details about the sites.
#' 
#' This routine will return only rows for those activities and
#' sites with results for the given months- if a site has no
#' results provided for the given month, it will not appear in these
#' results.
#' 
#' @param databaseId
#' @param month the calendar month to retrieve in the format '2014-02'
#' 
#' @export
getMonthlyReportsCubeForDatabase <- function(databaseId, month) {
  
  db <- getDatabaseSchema(databaseId)
  
  # Fetch one cube per activity
  tables <- lapply(db$activities, function(activity) {
    cat(sprintf("Fetching %d %s %s...\n", activity$id, activity$category, activity$name))
    
    # Fetch a data frame for this activity with sites in rows, and 
    # attributes of the sites in the columns
    sites <- getSitesDataFrame(activity)
    
    # Fetch indicators for this month
    indicatorValues <- getMonthlyReportsCube(activityId=activity$id, month=month)
    
    merge(sites, indicatorValues)
  })
  
  # Make sure all activities have the same attributes
  columnNames <- unique(unlist(sapply(tables, function(table) names(table)), recursive=T))
  tables <- lapply(tables, function(table) {
    columns <- lapply(columnNames, function(columnName) {
      column <- table[[columnName]]
      if(is.null(column)) {
        logical(if(is.null(table)) 0 else nrow(table))
      } else {
        column
      }
    })
    names(columns) <- columnNames
    data.frame(columns, stringsAsFactors=F)
  })
  
  
  # Merge into mega table
  table <- do.call("rbind", tables)
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

asIndicatorDataFrame <- function(databaseSchema) {
  tables <- lapply(databaseSchema$activities, function(activity) {
    indicators <- activity$indicators
    data.frame(
      databaseId=        databaseSchema$id,
      activityId =       activity$id,
      indicatorId =        extractField(indicators, "id"),
      indicatorName =        extractField(indicators, "name"),
      indicatorCategory =        extractField(indicators, "category"),
      aggregation = extractField(indicators, "aggregation"),
      units = extractField(indicators, "units"),
      mandatory = extractField(indicators, "mandatory"),
      listHeader = extractField(indicators, "listHeader"))
      
  })
  do.call("rbind", tables)
}

asAttributeGroupDataFrame <- function(databaseSchema) {
  
  tables <- lapply(databaseSchema$activities, function(activity) {
    groups <- activity$attributeGroups
    data.frame(
      databaseId=        databaseSchema$id,
      activityId =       activity$id,
      attributeGroupId =        extractField(groups, "id"),
      attributeGroupName =        extractField(groups, "name"),
      multipleAllowed =        extractField(groups, "multipleAllowed"),
      mandatory = extractField(groups, "mandatory"))
    
  })
  do.call("rbind", tables)
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

extractDimension <- function(buckets, dimension, property) {
  if(length(buckets) == 0) {
    logical(0)
  } else {
    sapply(buckets, function(bucket) {
      obj <- bucket$key[[dimension]]
      if(is.list(obj)) {
        x <- obj[[property]]
        if(!is.null(x) && is.atomic(x)) {
          x
        } else {
          NA
        }
      } else {
        NA
      }
    })
  }
}

extractBucketValue <- function(buckets) {
  if(length(buckets) == 0) {
    numeric(0)
  } else {
    sapply(buckets, function(bucket) {
      bucket$sum
    })
  }
}