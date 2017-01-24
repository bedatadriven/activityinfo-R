
#' Fetch the sites for an activity as a data.frame
#
getSiteData <- function(activity, adminlevels, include.comments) {
  
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
  for (admin.level in names(adminlevels)) {
    column.name <- makeColumnName(admin.level, prefix = "location.adminlevel.")

    if (column.name %in% names(query)) {
      stop("cannot create unique column name for administrative level '", admin.level, "'")
    }

    query[[column.name]] <- sprintf("%s.name", adminlevels[admin.level])
    query[[paste0(column.name, ".code")]] <- sprintf("%s.code", adminlevels[admin.level])
    
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
  
  # Translation table for the indicators from identifier to full name):
  indicators <- data.frame(
    id = vapply(activity$indicators, function(x) sprintf("i%010d", x$id), character(1L)),
    name = vapply(activity$indicators, function(x) na.if.null(x$name, "character"), character(1L)),
    units = vapply(activity$indicators, function(x) na.if.null(x$units, "character"), character(1L)),
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
getFormData <- function(activity, adminlevels, include.comments) {
  
  site <- getSiteData(activity, adminlevels, include.comments)
  site.data <- site$table
  

  message(paste("Form '", activity$name, "' has ", nrow(site.data), " reports.", sep = ""))

  indicators <- getIndicatorData(activity)

  # Convert reported indicator values from a list to a data frame:
  indicator.data <- indicators$table
  # Reshape the table to create a separate row for each reported indicator value:
  indicator.columns <- grep("^i\\d+", names(indicator.data), value = TRUE)
  
  # Call melt.data.frame directly because if the old 'reshape' package
  # is loaded, its entry in the global S3 table will overwrite that
  # from reshape2. :-(
  indicator.data <- reshape2:::melt.data.frame(indicator.data,
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
  form.data$form <- rep(activity$name, times = nrow(form.data))
  form.data$form.category <- rep(na.if.null(activity$category, "character"), times = nrow(form.data))
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
#' @param database.id the numeric id of the database 
#' @param include.comments TRUE if narrative comments fields should also be included
#' @param col.names a named character vector containing alternate names for the resulting table
#' @export
getDatabaseValueTable <- function(database.id = NA, include.comments = FALSE, col.names = NULL) {
  
  message("Fetching database schema...")
  db.schema <- getDatabaseSchema(database.id)
  
  message("Fetching administrative levels...")
  adminlist <- getAdminLevels(db.schema$country$id)
  adminlevels <-  vapply(adminlist, function(x) sprintf("E%010d", x$id), character(1L))
  names(adminlevels) <- vapply(adminlist, function(x) x$name, character(1L))

  message(paste("Database contains ", length(db.schema$activities),
      " forms. Retrieving data per form...\n", sep = ""))
  
  form.data <- lapply(db.schema$activities, function(form) {
    form.data <- getFormData(form, adminlevels, include.comments)
    form.data
  })
  
  # Find common column names for combining all results into a single table:
  all.column.names <- Reduce(union, lapply(form.data, names))
  common.column.names <- Reduce(intersect, lapply(form.data, names))
  
  missing.columns <- setdiff(all.column.names, common.column.names)
  if (length(missing.columns) > 0L) {
    warning("the following column(s) is or are not shared by all forms: ",
            paste(missing.columns, collapse = ", "))
  }
  
  # Add missing columns as NAs
  form.data <- lapply(form.data, function(table) {
    missing.columns <- setdiff(all.column.names, names(table))
    for(missing.column in missing.columns) {
      table[, missing.column] <- rep(NA, times = nrow(table))
    }
    table
  })
  
  # Combine all data into a single table:
  values <- do.call(rbind, form.data)
  
  values$database.id <- rep(database.id, times = nrow(values))
  values$database <- rep(db.schema$name, times = nrow(values))
  
  # Apply column names
  for(i in seq_along(col.names)) {
    names(values)[ names(values) == names(col.names)[i] ] <- col.names[i]
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
