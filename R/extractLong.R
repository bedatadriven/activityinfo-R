

#' Extract a full database in "long" format
#' 
#' The resulting data.frame includes a row for each reported indicator
#' and month, with columns for the site's location, the administrative levels,
#' and for each of the single-valued attributes defined.
#' 
#' @export
extractDatabaseLong <- function(database.id = NA) {
  
  if (is.na(database.id)) {
    stop("you forgot to set the database identifier at the top of this script!")
  }
  
  message("Retrieving schema for database ", database.id, "...\n", sep ="")
  schema <- getDatabaseSchema(database.id)
  
  # Prepare a list with query parameters to get administrative level and
  # geographic location data:
  adminLevels <- getAdminLevels(schema$country$id)
  adminLevelNames <- vapply(adminLevels, function(x) x$name, "character")
  locationQueryParams <- local({
    tmp <- sprintf("[%s].name",vapply(adminLevelNames, URLencode, "character"))
    tmp <- as.list(tmp)
    names(tmp) <- make.names(adminLevelNames)
    tmp$id <- "_id"
    tmp$lat <- "location.latitude"
    tmp$lon <- "location.longitude"
    tmp
  })
  
  # Which fields are attributes?
  attributeGroups <- unique(
    do.call(c, lapply(schema$activities, function(form) {
      sapply(form$attributeGroups, function(group) {
        group$name
      })
    }))
  )
  
  values <- NULL
  
  # Loop over all forms in the database:
  for (formIndex in seq(length(schema$activities))) {
    
    
    activity <- schema$activities[[formIndex]] # "activity" is the old name for a form
    
    indicator.metadata <- do.call(rbind, lapply(activity$indicators, function(indicator) {
      data.frame(oldId = indicator$id,
                 units = na.if.null(indicator$units),
                 category = na.if.null(indicator$category),
                 stringsAsFactors = FALSE)
    }))
    
    message(paste("Processing activity ", activity$id, " (", activity$name, ")...", sep = ""))
    formTree <- getFormTree(activity)
    
    message("Retrieving reported values...")
    retry <- 3
    while (retry) {
      success <- TRUE
      tryCatch(reports <- queryForm(formTree),
               error = function(e) {
                 cat("Error: failed to retrieve reported values for form ", activity$id,
                     ". Retrying...\n", sep = "")
                 retry <<- retry - 1
                 if (retry == 0) {
                   stop("Failed with the following error: ", conditionMessage(e), call. = FALSE)
                 }
                 success <<- FALSE
               },
               finally = if (success) {
                 retry <- 0
               }
      )
    }
    
    message("Retrieving administrative levels...")
    success <- TRUE
    tryCatch(admin.levels <- queryForm(formTree, queryParams = locationQueryParams),
             error = function(e) {
               cat("Error: failed to retrieve administrative levels for form ", activity$id,
                   ", skipping...\n", sep = "")
               success <<- FALSE
             },
             finally = if (!success) next)
    
    # Merge/fuse the two lists together:
    reports <- mapply(c, reports, admin.levels, SIMPLIFY = FALSE)
    
    message("Converting values to a tabular format...")
    new.values <- lapply(reports, function(report) {
      # Convert report to a data frame so we can merge with the form tree:
      reportTable <- data.frame(name = names(report),
                                values = unlist(report), stringsAsFactors = FALSE)
      reportTable <- merge(reportTable, formTree, by = "name")
      
      
      if (is.monthly(formTree)) {
        partnerLabel <- report$site.partner.label
        locationLabel <- if (is.null(report$site.location.name)) {
          "unknown"
        } else {
          report$site.location.name
        }
      } else {
        partnerLabel <- report$partner.label
        locationLabel <- if (is.null(report$location.name)) {
          "unknown"
        } else {
          report$location.name
        }
      }

      is.indicator <- grepl("indicator", reportTable$type)
      n <- sum(is.indicator)
      
      if (n == 0L) {
        # The current report doesn't have any data on indicators
        return(NULL)
      } else {
        oldIndicatorId <- extractOldId(reportTable$id[is.indicator])
        values <- data.frame(
          entryId       = report[["@id"]], # entryId = either the site identifier or the identifier of the monthly report
          indicatorId   = oldIndicatorId,
          indicatorName = reportTable$label[is.indicator],
          units         = lookupName(oldIndicatorId, indicator.metadata, outputCol = "units"),
          indicatorCategory = lookupName(oldIndicatorId, indicator.metadata, outputCol = "category"),
          value         = as.numeric(reportTable$values[is.indicator]),
          stringsAsFactors = FALSE)
        
      }
      values$activityId   <- activity$id
      values$activityName <- activity$name
      values$activityCategory <- na.if.null(activity$category)
      values$month        <- determineMonth(report$date1, report$date2)
      
      # Add administrative level information:
      for (col in make.names(adminLevelNames)) {
        values[[col]] <- na.if.null(report[[col]])
      }
      values$lat <- na.if.null(report$lat, "numeric")
      values$lon <- na.if.null(report$lon, "numeric")
      
      if (is.monthly(formTree)) {
        values$locationName <- locationLabel
        values$locationCode <- na.if.null(report[["site.location.axe"]])
        values$partnerName  <- if(is.null(report$site.partner.label)) "unknown" else report$site.partner.label
        values$partnerFullName <- na.if.null(report[["site.partner.Full Name"]])
      } else {
        values$locationName <- locationLabel
        values$locationCode <- na.if.null(report[["location.axe"]])
        values$partnerName  <- report$partner.label
        values$partnerFullName <- na.if.null(report[["partner.Full Name"]])
      }
      for (col in attributeGroups) {
        if (is.monthly(formTree)) {
          values[[make.names(col)]] <- na.if.null(report[[paste("site", col, sep = ".")]])
        } else {
          values[[make.names(col)]] <- na.if.null(report[[col]])
        }
      }
      values
    })
    
    values <- rbind(values, do.call(rbind, new.values))
  } # end of loop over forms
  
  values$databaseId <- database.id
  values$databaseName <- schema$name
  return(values)
}


lookupName <- function(x, table, lookupCol = "oldId", outputCol = "name") {
  
  if (is.na(x) || is.character(x)) return(x)
  
  tableName <- deparse(substitute(table))
  
  if(is.null(table[[lookupCol]]) || is.null(table[[outputCol]])) {
    stop("'", tableName, "' must have columns '", lookupCol, "' and '", outputCol, "'")
  }
  
  row <- match(x, table[[lookupCol]])
  if (any(is.na(row))) {
    cat("Warning: no record(s) found with (old) identifier(s) ",
        paste(x[is.na(row)], collapse = ", "), " in '", tableName,
        "'\n", sep ="")
  }
  table[[outputCol]][row]
}

is.monthly <- function(formTree) {
  grepl("^M\\d*$", attr(formTree, "tree")$root)
}


na.if.null <- function(x, mode = "character") {
  if (is.null(x)) as.vector(NA, mode) else x
}

sanitizeNames <- function(s) {
  # convert strings to a format that's suitable for use as name
  gsub("\\s|-|_", ".", tolower(s))
}

translateFieldType <- function(typeClass) {
  switch(toupper(typeClass),
         REFERENCE  = "reference",
         LOCAL_DATE = "date",
         QUANTITY   = "indicator",
         CALCULATED = "calculated indicator",
         ENUMERATED = "attribute",
         NARRATIVE  =,
         FREE_TEXT  = "text",
         GEOAREA    = "geographic entity",
         "other")
}

getFormElements <- function(form, tree, name.prefix = NULL) {
  
  if (is.null(form$elements)) {
    NULL
  } else {
    do.call(rbind, lapply(form$elements, function(e) {
      fieldType <- translateFieldType(e$type)
      if (fieldType == "reference") {
        # This form refers to one or more other forms
        do.call(rbind, lapply(e$typeParameters$range, function(refform) {
          refId= refform$formId
          getFormElements(tree$forms[[refId]],
                          tree,
                          ifelse(is.null(name.prefix),
                                 e$code,
                                 paste(name.prefix, e$code, sep = ".")))
        }))
      } else {
        fieldName <- ifelse(is.null(e$code), e$label, e$code)
        fieldLabel <- ifelse(is.null(e$label), e$code, e$label)
        fieldType <- if (fieldType == "attribute") {
          switch(tolower(e$typeParameters$cardinality),
                 single="single attribute",
                 multiple="multiple attribute",
                 stop(sprintf("unknown cardinality: %s", deparse(e$typeParameters$cardinality))))
        } else {
          fieldType
        }
        data.frame(id = e$id,
                   name = ifelse(is.null(name.prefix),
                                 fieldName,
                                 paste(name.prefix, fieldName, sep = ".")),
                   label = fieldLabel,
                   type = fieldType,
                   stringsAsFactors = FALSE
        )
      }
    }))
  }
}

getFormTree <- function(activity) {
  
  prefix <- switch(as.character(activity$reportingFrequency),
                   "0"="a",
                   "1"="M",
                   stop("reporting frequency should be 0 (once) or 1 (monthly)")
  )
  
  tree <- getResource(sprintf("form/%s%s/tree", prefix, activity$id))
  
  form <- tree$forms[[tree$root]]
  
  elements <- getFormElements(form, tree)
  
  structure(elements, class = c("formtree", class(elements)), tree = tree)
}


determineMonth <- function(start, end) {
  start <- as.POSIXlt(start)
  end <- as.POSIXlt(end)
  if (start$year != end$year || start$mon != end$mon) {
    cat("Warning: found a start and end date in different months\n")
  }
  format(start, format = "%Y-%m")
}
