
#' Fetch the sites for an activity as a data.frame
#
getSiteData <- function(activity, adminlevel.names, include.comments) {
  
  # Ensure that we are dealing with an activity from the database schema:
  stopifnot(is.activity(activity))
  
  # Fields which exist for all "classical" sites:
  query <- list(
    site.id = "_id",
    partner.id = "partner._id",
    partner.label = "partner.label",
    partner.description = "partner.[full name]",
    location.latitude = "location.latitude",
    location.longitude = "location.longitude",
    location.name = "location.name",
    location.alternate_name = "location.axe",
    project.label = "project.name",
    project.description = "project.description"
  )
  
  # Add comments if requested:
  if (include.comments) {
    query$site.comments <- "comments"
  }
  
  # Start and end date are site data if reporting frequency is "once":
  if (as.character(activity$reportingFrequency) == "0") {
    query[["start_date"]] <- "date1"
    query[["end_date"]] <- "date2"
  }
  
  # Fields which depend on the administrative levels in the country of the
  # database which contains the form:
  for (admin.level in adminlevel.names) {
    column.name <- makeColumnName(admin.level, prefix = "location.adminlevel.")

    if (column.name %in% names(query)) {
      stop("cannot create unique column name for administrative level '", admin.level, "'")
    }

    query[[column.name]] <- paste("location.[", admin.level, "].name", sep = "")
  }

  # Translation table for the attributes (from identifier to full name):
  attributes <- data.frame(
    id = vapply(activity$attributeGroups, function(x) sprintf("Q%010d", x$id), character(1L)),
    name = vapply(activity$attributeGroups, function(x) x$name, character(1L)),
    stringsAsFactors = FALSE
  )
  
  for (id in attributes$id) {
    # Use indicator identifiers instead of names for greater robustness and
    # shorter URLs:
    query[[id]] <- id
  }
  
  list(table = queryTable(activity$id, columns = query),
       column.names = attributes)
}

#'
getIndicatorData <- function(activity) {
  
  # Ensure that we are dealing with a form instance from the database schema:
  stopifnot(is.activity(activity))
  
  # Return an empty result if the form has no indicators in its design:
  if (length(activity$indicators) == 0L) {
    warning("form '", activity$name, "' has no indicators")
    return(list(table = data.frame()))
  }
  
  query <- list(site.id = "site")
  
  # Start and end date are report data if reporting frequency is "monthly":
  if (as.character(activity$reportingFrequency) == "1") {
    formId <- sprintf("M%s", activity$id)
    query[["site.id"]] <- "site"
    query[["start_date"]] <- "date1"
    query[["end_date"]] <- "date2"
    query[["report.id"]] <- "_id"
  } else {
    formId <- sprintf("a%s", activity$id)
    query[["site.id"]] <- "_id"
  }
  
  # Translation table for the indicators (from identifier to full name):
  indicators <- data.frame(
    id = vapply(activity$indicators, function(x) sprintf("i%010d", x$id), character(1L)),
    name = vapply(activity$indicators, function(x) x$name, character(1L)),
    units = vapply(activity$indicators, function(x) x$units, character(1L)),
    stringsAsFactors = FALSE
  )
  
  for (id in indicators$id) {
    # Use indicator identifiers instead of names for greater robustness and
    # shorter URLs:
    query[[id]] <- id
  }
  
  # Execute the query through the ActivityInfo API:
  list(table = queryTable(formId, query), 
       column.names = indicators)
}

#'
#' @importFrom reshape2 melt
getFormData <- function(activity, adminlevel.names, include.comments) {
  
  site <- getSiteData(activity, adminlevel.names, include.comments)
  site.data <- site$table
  
  if(nrow(site.data) == 0) {
    message(paste("Form '", activity$name,
        "' has no reports. Skipping...", sep = ""))
    return(invisible())
  } else {
    message(paste("Form '", activity$name,
        "' has ", nrow(site.data), " reports.", sep = ""))
  }
  
  indicators <- getIndicatorData(activity)
  
  if (nrow(indicators$table) == 0) {
    message(paste("Form '", activity$name,
        "' has no indicator values in any report. Skipping...", sep = ""))
    return(invisible())
  }
  
  # Convert reported indicator values from a list to a data frame:
  indicator.data <- indicators$table
  # Reshape the table to create a separate row for each reported indicator value:
  indicator.columns <- grep("^i\\d+", names(indicator.data), value = TRUE)
  indicator.data <- melt(indicator.data,
                                   measure.vars = indicator.columns,
                                   variable.name = "indicator.id",
                                   value.name = "indicator.value",
                                   na.rm = TRUE)
  
  indicator.metadata <- indicators$column.names
  names(indicator.metadata) <- paste("indicator", names(indicator.metadata), sep = ".")
  indicator.data <- merge(indicator.data, indicator.metadata, by = "indicator.id", all.x = TRUE)
  
  # Merge site (meta) data and reported values:
  form.data <- merge(indicator.data, site.data, by = "site.id", all.x = TRUE)
  # Add form name and category:
  form.data$form <- activity$name
  form.data$form.category <- na.if.null(activity$category)
  # Sort columns alphabetically to group related columns together:
  form.data <- form.data[, order(names(form.data))]
  # Rename the columns with attribute values:
  names(form.data) <- vapply(names(form.data), function(colname) {
    if (colname %in% site$column.names$id) {
      site$column.names$name[match(colname, site$column.names$id)]
    } else {
      colname
    }
  }, character(1L), USE.NAMES = FALSE)
  
  form.data
}


#' Extract a full database in "long" format
#' 
#' The resulting data.frame includes a row for each reported indicator
#' and month, with columns for the site's location, the administrative levels,
#' and for each of the single-valued attributes defined.
#' 
#' @export
getDatabaseValueTable <- function(database.id = NA, include.comments = FALSE) {
  
  message("Fetching database schema...")
  db.schema <- getDatabaseSchema(database.id)
  
  message("Fetching administrative levels...")
  adminlevel.names <- vapply(getAdminLevels(db.schema$country$id), function(x) {
    x$name
  }, character(1L))
  
  message(paste("Database contains ", length(db.schema$activities),
      " forms. Retrieving data per form...\n", sep = ""))
  
  form.data <- lapply(db.schema$activities, function(form) {
    # Check if the data in the form is reported monthly or just once:
    monthly <- switch(as.character(form$reportingFrequency), "0"=FALSE, "1"=TRUE)
    
    form.data <- getFormData(form, adminlevel.names, include.comments)
    
    if (!monthly) {
      form.data$report.id <- rep(NA_character_, nrow(form.data))
    }
    
    form.data
  })
  
  # Remove forms without data entries:
  form.data <- form.data[!vapply(form.data, is.null, logical(1L))]
  
  # Find common column names for combining all results into a single table:
  common.column.names <- Reduce(intersect, lapply(form.data, names))
  
  # Combine all data into a single table:
  values <- do.call(rbind, lapply(form.data, function(table) table[, common.column.names]))
  
  # Warn the user if any column(s) is or are missing in the combined result:
  all.column.names <- unique(do.call(c, lapply(form.data, names)))
  missing.columns <- setdiff(all.column.names, common.column.names)
  if (length(missing.columns) > 0L) {
    warning("the following column(s) is or are not shared by all forms: ",
            paste(missing.columns, collapse = ", "))
  }
  return(values)
}


makeColumnName <- function(s, prefix = NULL) {
  
  stopifnot(is.character(s))
  
  s <- gsub("\\s+|\\.+|-+", "_", trimws(tolower(s)))
  s <- gsub("#", "nr", s)
  
  if (is.null(prefix)) {
    make.names(s)  
  } else {
    make.names(paste(prefix, s, sep = ""))
  }
}


na.if.null <- function(x, mode) {
  if (is.null(x)) as.vector(NA, mode) else x
}
