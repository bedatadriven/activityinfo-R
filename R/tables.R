
#' Fetch the partners registered in a database as a data.frame
#' 
#' @param databaseId database identifier
#' @return A data frame with columns \code{id} and \code{name}. This data frame 
#' is empty if no partners are registered in the database.
#' @export
getPartnersDataFrame <- function(databaseId) {
  schema <- getDatabaseSchema(databaseId)
  
  if (length(schema$partners)) {
    do.call(rbind, lapply(schema$partners, function(partner) {
      data.frame(id = partner$id,
                 name = partner$name,
                 stringsAsFactors = FALSE)
    }))
  } else {
    data.frame(id = integer(0), name = character(0))
  }
}

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
    for(indicator in activity$indicators) {
      columns[[indicator$name]] <- extractNestedField(sites, "indicatorValues", as.character(indicator$id))
    }
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

#' getIndicatorValueTable
#' 
#' Retrieves a data.frame containing one indicator value per row,
#' along with the related site, location, and reporting period details
#' linked to each value
#' @note The value of the \code{month} column in the resulting data frame 
#' depends on the reporting frequency of the activity:
#' \itemize{
#'   \item for \sQuote{monthly} reporting it is the month in which the data was 
#'   entered and
#'   \item for reporting \sQuote{once} it is the month of the end date of the 
#'   reporting period.
#'   }
#' In both cases the format is the same: YYYY-MM.   
#' @export
getIndicatorValueTable <- function(databaseId) {
  
  # Fetch db schema
  db <- getDatabaseSchema(databaseId)
  
  # Fetch site properties
  sites <- getResource("sites", database=databaseId)
  
  columns <- list()
  columns$siteId <- extractField(sites, "id")
  columns$activityId <- extractField(sites, "activity")
  columns$locationId <- extractNestedField(sites, "location", "id")
  columns$locationName <- extractNestedField(sites, "location", "name")
  columns$partnerId <- extractNestedField(sites, "partner", "id")
  columns$partnerName <- extractNestedField(sites, "partner", "name")  
  
  sites <- data.frame(columns, stringsAsFactors=FALSE)
  
  # Join additional the activityCategory
  activities <- asActivityDataFrame(db)
  sites <- merge(sites, subset(activities, select = c("activityId", "activityName", "activityCategory")))
  
  # Fetch the individual indicator values
  values <- getCube(filter = list(database = databaseId), dimensions = c("site", "indicator", "month"))
  
  # Join the indicator properties
  indicators <- asIndicatorDataFrame(db)
  values <- merge(values, subset(indicators, select = c("indicatorId", "indicatorCategory", "units" )))
  
  # Join the values to their sites
  merge(sites, values)
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
#' cube <- getMonthlyReportsCube(1064, month = '2014-06')
#' merge(sites, cube)
#' }
#' @export
getMonthlyReportsCube <- function(activityId, month)
  getCube(filters = list(form = activityId, month = month), dimensions = c("indicator", "site"))
  

#' getCube
#' 
#' Aggregates indicator values up to one or more dimensions.
#' 
#' @param filters a named list of dimensions on which to filter
#' @param dimensions a list of dimensions on which to roll-up
#' 
#' @export
getCube <- function(filters = list(), dimensions = c("indicator", "site")) {

  queryParams <- list()

  for(filter in names(filters)) { 
    # Expand database filter to form filter until the server supports database
    
    if(identical(filter, "database")) {
      db <- getDatabaseSchema(filters[["database"]])
      formIds <- sapply(db$activities, function(a) a$id)
      names(formIds) <- rep("form", times=length(formIds))
      queryParams <- c(queryParams, formIds)
    } else if(filter %in% c("activity", "form")) {
      queryParams <- c(queryParams, list(form = filters[[filter]]))
    } else if(filter == "month") {
      queryParams <- c(queryParams, list(month = filters[[filter]]))
    } else {
      stop(sprintf("unknown filter value '%s'", filter))
    }
  }
  
  # Expand the dimension vector into a series of dimension=X, dimension=Y, dimension=Z
  queryParams <- c(queryParams, structure(dimensions, .Names = rep("dimension", length(dimensions))))
  
  # Query server
  cube <- getResource("sites/cube", queryParams = queryParams)
  
  columns <- list(value = extractBucketValue(cube))
  
  if("site" %in% dimensions) {
    columns$siteId <- extractDimension(cube, "Site", "id")
  }
  
  if("indicator" %in% dimensions) {
    columns$indicatorId <-   extractDimension(cube, "Indicator", "id")
    columns$indicatorName <- extractDimension(cube, "Indicator", "label")
  }
  
  if("month" %in% dimensions) {
    columns$month <- sprintf("%d-%02d", extractDimension(cube, "Date", "year"), extractDimension(cube, "Date", "month"))
  }
  
  for(filter in unique(names(filters))) {
    columns[[filter]] <- rep(filters[[filter]], length(cube))
  }  
  
  
  df <- data.frame(columns, stringsAsFactors=FALSE)
  attr(df, 'cube') <- cube
  
  df
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
#' @param databaseId the id of the database to retrieve
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

#' Retrieves a data.frame containing all changes made to a given activity
#'
#'@export
getActivityChangeLog <- function(activityId) {
  
  table <- queryTable(form = activityId, id = "_id")
  siteIds <- extractOldId(table$id)
  
  sites <- lapply(siteIds, function(siteId) {
    message(sprintf("Fetching history for site %d...", siteId))
    history <- executeCommand("GetSiteHistory", siteId = siteId)
    changes <- history$changes
    lapply(changes, function(change) {
      list(siteId = siteId,
           time =  change$time,
           userName = change$userName,
           userEmail = change$userEmail)
    })
  })
  
  changes <- unlist(sites, recursive = FALSE)
  
  data.frame(siteId = extractField(changes, "siteId"),
             time = as.POSIXct( extractField(changes, "time") / 1000, origin="1970-01-01"),
             userName = extractField(changes, "userName"),
             userEmail = extractField(changes, "userEmail"))

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
    published =             (extractField(activities, "published") == 1),
    stringsAsFactors = FALSE
  )
  df
}

#' asIndicatorDataFrame
#' 
#' Creates a data.frame containing a list of indicators
#' and their properties from the given database schema
#' 
#' @export
asIndicatorDataFrame <- function(databaseSchema) {
  tables <- lapply(databaseSchema$activities, function(activity) {
    indicators <- activity$indicators
    data.frame(
      databaseId=        rep(databaseSchema$id, length.out=length(indicators)),
      activityId =       rep(activity$id, length.out=length(indicators)),
      indicatorId =        extractField(indicators, "id"),
      indicatorName =      extractField(indicators, "name"),
      indicatorCategory =  extractField(indicators, "category"),
      indicatorCode =      extractField(indicators, "code"),
      aggregation =        extractField(indicators, "aggregation"),
      units =              extractField(indicators, "units"),
      mandatory =          extractField(indicators, "mandatory"),
      listHeader =         extractField(indicators, "listHeader"),
      stringsAsFactors = FALSE)
  })
  do.call("rbind", tables)
}

#' asAttributeGroupDataFrame
#' 
#' Creates a data.frame containing a list of attribute groups
#' and their properties from the given database schema
#' 
#' @export
asAttributeGroupDataFrame <- function(databaseSchema) {
  
  tables <- lapply(databaseSchema$activities, function(activity) {
    groups <- activity$attributeGroups
    data.frame(
      databaseId=        rep(databaseSchema$id, length.out=length(groups)),
      activityId =       rep(activity$id, length.out=length(groups)),
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