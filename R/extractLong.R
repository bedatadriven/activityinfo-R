
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
    id = vapply(activity$attributeGroups, function(x) attribute.field.name(x$id), character(1L)),
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
    formId <- monthly.reports.form.id(activity$id)
    query[["site.id"]] <- "site"
    query[["start_date"]] <- "date1"
    query[["end_date"]] <- "date2"
    query[["report.id"]] <- "_id"
  } else {
    formId <- site.form.id(activity$id)
    query[["site.id"]] <- "_id"
  }
  
  # Translation table for the indicators from identifier to full name):
  indicators <- data.frame(
    id = vapply(activity$indicators, function(x) indicator.field.name(x$id), character(1L)),
    name = vapply(activity$indicators, function(x) na.if.null(x$name, "character"), character(1L)),
    units = vapply(activity$indicators, function(x) na.if.null(x$units, "character"), character(1L)),
    category = vapply(activity$indicators, function(x) na.if.null(x$category, "character"), character(1L)),
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
  
  if(nrow(indicator.metadata) > 0) {
    indicator.data <- merge(indicator.data, indicator.metadata, by = "indicator.id", all.x = TRUE)
  } 
  
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

getFormDimensions <- function(form, prefix = NULL) {
  dimensions <- vector("list", length(form$elements))
  dimensions <- setNames(dimensions, lapply(form$elements, function(field) makeColumnName(field$label, prefix)))
  
  for (field in form$elements) {
    # exclude subform fields
    if (identical(field$type, "subform")) {
      next
    } 
    # exclude measure fields
    if (identical(field$type, "quantity") || identical(field$type, "calculated")) {
      next
    }
    dimensions[[makeColumnName(field$label, prefix)]] <- field$id
  }
  Filter(Negate(is.null), dimensions)
}

getFormMeasures <- function(form, prefix = NULL) {
  measures <- vector("list", length(form$elements))
  measures <- setNames(measures, lapply(form$elements, function(field) makeColumnName(field$label, prefix)))

  for (field in form$elements) {
    if (identical(field$type, "quantity") || identical(field$type, "calculated")) {
      measures[[makeColumnName(field$label, prefix)]] <- field$id
    } 
  }
  Filter(Negate(is.null), measures)
}

#'
#' @importFrom reshape2 melt
createDataFrame <- function(records, dimensions, measures, as.value.table = FALSE) {
  if (is.element("parentId",names(records$columns))) {
    # Sub-Form
    df <- data.frame(c(as.data.columns(list(subFormRecordId = records$columns[["subFormRecordId"]], parentId = records$columns[["parentId"]]), records$rows),
                       as.data.columns(records$columns[names(dimensions)], records$rows),
                       as.data.columns(records$columns[names(measures)], records$rows)))
  } else {
    # Form
    df <- data.frame(as.data.columns(records$columns, records$rows))
  }
  if (as.value.table) {
    df <- reshape2:::melt.data.frame(df,
                                     measure.vars = names(measures),
                                     variable.name = "Quantity",
                                     value.name = "Value",
                                     na.rm = TRUE)
  }
  return(df)
}

as.data.column <- function(column, nrows) {
  if (identical(column$storage, "empty")) {
    col <- rep(NA, times = nrows)
  } else {
    col <- unname(Map(nullToNA,column$value))
  }
  unlist(col)
}

as.data.columns <- function(columns, nrows) {
  data.columns <- vector("list", length(columns))
  data.columns <- setNames(data.columns, names(columns))
  for (colName in names(columns)) {
    data.columns[[colName]] <- as.data.column(columns[[colName]])
  }
  data.columns
}

nullToNA <- function(val) {
  if (is.null(val)) {
    return(NA)
  } else {
    return(val)
  }
}


#' Extract all Form Records, including all Sub-Form Records, in "long" format.
#' 
#' The Form Record Table is returned as a data.frame, with: 
#' - All Form and Sub-Form Record Tables merged into a single table, with missing values given as <NA>.
#' - Columns for all Form and Sub-Form Fields.
#' - Rows for each Form and Sub-Form Record. If @param as.value.table is TRUE, each row gives a measured value, specified by the "Quantity" and "Value" fields.
#' 
#' @param form.id the full alphanumeric id of the form 
#' @param as.value.table specify whether to include Quantity/Calculated Fields as separete rows
#' @param col.names a named character vector containing alternate names for the resulting table
#' @export
getFormRecordTable <- function(form.id = NA, as.value.table = FALSE, col.names = NULL) {
  
  message("\nFetching Form Tree...")
  form.tree <- getFormTree(form.id)
  root.form <- form.tree$forms[[form.tree$root]]
  root.form.dimensions <- getFormDimensions(root.form)
  root.form.measures <- getFormMeasures(root.form)
  
  message("Fetching Root Form Records...")
  root.form.records <- getResource(paste("form",root.form$id,"query","columns", sep = "/"))
  message(paste("Form ",root.form$label, " has ", root.form.records$rows, " records.", sep = ""))
  
  message("Fetching Sub-Form Records...")
  sub.forms <- lapply(root.form$elements, function (element) {
    if (identical(element$type,"subform")) {
      sub.form.id <- element$typeParameters$formId
      sub.form.schema <- form.tree$forms[[sub.form.id]]
      sub.form.name <- sub.form.schema$label
      sub.form.dimensions <- getFormDimensions(sub.form.schema, paste(sub.form.name,"",sep="."))
      sub.form.measures <- getFormMeasures(sub.form.schema, paste(sub.form.name,"",sep="."))
      
      sub.form.records <- getResource(paste("form",sub.form.id,"query","columns", sep = "/"),
                                      c(subFormRecordId = "[_id]", 
                                        parentId = "[parent]",
                                        sub.form.dimensions,
                                        sub.form.measures))
      message(paste("Sub-Form ",sub.form.name, " has ", sub.form.records$rows, " records.", sep = ""))
      sub.form.table <- createDataFrame(sub.form.records, 
                                        sub.form.dimensions, 
                                        sub.form.measures, 
                                        as.value.table)
      
      # add Sub-Form Id and Name columns
      sub.form.table$subFormId <- rep(sub.form.id, nrow(sub.form.table))
      sub.form.table$subFormName <- rep(sub.form.name, nrow(sub.form.table))
      
      return(list(id = sub.form.id,
                  schema = sub.form.schema,
                  dimensions = sub.form.schema,
                  measures = sub.form.measures,
                  records = sub.form.records,
                  table = sub.form.table))
    }
  })
  sub.forms <- Filter(Negate(is.null), sub.forms)
  
  # Create root form data frame - only melt into value table if there are no subforms
  root.form.table <- createDataFrame(root.form.records, 
                                     root.form.dimensions, 
                                     root.form.measures,
                                     as.value.table && length(sub.forms) == 0)
  
  # Correct the Id Field, and add Form Id and Form Name
  colnames(root.form.table)[names(root.form.table) == "X.id"] <- "recordId"
  root.form.table$formId <- rep(form.id, times = nrow(root.form.table))
  root.form.table$formName <- rep(root.form$label)
  
  # Check whether we need to merge in Sub-Form Record Tables
  if (length(sub.forms) > 0 && root.form.records$rows > 0) {
    # Find common column names for combining all results into a single table, and add missing columns as NAs
    sub.form.column.names <- Reduce(union, lapply(sub.forms, function(sub.form) names(sub.form$table)))
    sub.forms <- lapply(sub.forms, function(sub.form) {
      missing.columns <- setdiff(sub.form.column.names, names(sub.form$table))
      for (missing.column in missing.columns) {
        sub.form$table[, missing.column] <- rep(NA, times = nrow(sub.form$table))
      }
      sub.form
    })
    
    # Merge all Sub Form Tables into one via a row concatenation
    sub.form.table <- do.call(rbind, lapply(sub.forms, function(sub.form) sub.form$table))
    
    # Merge Sub Form Tables into Root Form Table via a Left Outer Join
    record.table <- merge(x = root.form.table, y = sub.form.table, by.x = "recordId", by.y = "parentId", all.x = TRUE)
  } else {
    record.table <- root.form.table
  }
  
  # Apply column names
  for(i in seq_along(col.names)) {
    names(record.table)[ names(record.table) == names(col.names)[i] ] <- col.names[i]
  }
  
  return(record.table)
}


#' Extract all Form Record Tables for a Database in "long" format.
#' 
#' Each Form Record Table is returned as a data.frame, with:
#' - Columns for all Form Fields.
#' - Rows for each Form Record. If @param as.value.table is TRUE, each row gives a measured value, specified by the "Quantity" and "Value" fields.
#' 
#' Returns a list of all Form Record Tables. 
#' If @param as.single.table is TRUE, all Form Record Tables will be concatenated into a single table, with missing values given as <NA>.
#' 
#' @param database.id the numeric id of the database 
#' @param as.value.table specify whether to include Quantity/Calculated Fields as separete rows
#' @param as.single.table specify whether to merge all Form Record Tables into a single table
#' @export
getDatabaseRecordTable <- function(database.id = NA, as.value.table = FALSE, as.single.table = FALSE) {
  
  message("Fetching database schema...")
  db.schema <- getDatabaseSchema(database.id)
  
  message(paste("Database contains ", length(db.schema$activities),
                " forms. Retrieving data per form...\n", sep = ""))
  
  form.records <- lapply(db.schema$activities, function(form) {
    form.records <- getFormRecordTable(site.form.id(form$id), as.value.table)
    form.records
  })
  
  if (as.single.table) {
    # Find common column names for combining all results into a single table:
    all.column.names <- Reduce(union, lapply(form.records, names))
    common.column.names <- Reduce(intersect, lapply(form.records, names))
    
    missing.columns <- setdiff(all.column.names, common.column.names)
    if (length(missing.columns) > 0L) {
      warning("the following column(s) is or are not shared by all forms: ",
              paste(missing.columns, collapse = ", "))
    }
    
    # Add missing columns as NAs
    form.records <- lapply(form.records, function(table) {
      missing.columns <- setdiff(all.column.names, names(table))
      for(missing.column in missing.columns) {
        table[, missing.column] <- rep(NA, times = nrow(table))
      }
      table
    })
    
    # Combine all data into a single table:
    values <- do.call(rbind, form.records)
    
    values$database.id <- rep(database.id, times = nrow(values))
    values$database <- rep(db.schema$name, times = nrow(values))
  } else {
    values <- form.records
  }
  
  return(values)
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
  adminlevels <-  vapply(adminlist, function(x) admin.level.form.id(x$id), character(1L))
  names(adminlevels) <- vapply(adminlist, function(x) x$name, character(1L))

  message(paste("Database contains ", length(db.schema$activities),
      " forms. Retrieving data per form...\n", sep = ""))
  
  form.data <- lapply(db.schema$activities, function(form) {
    form.data <- getFormData(form, adminlevels, include.comments)
    
    # Check for duplicated enum field names, as this will cause errors during rbind() later
    columns <- names(form.data)
    if (any(duplicated(columns))) {
      stop(paste("Duplicate field names found in Form '", form$name, 
                 "'. Please correct and rerun extraction.", sep = ""))
    }
    
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
  
  if(!is.null(prefix)) s <- tolower(s)
  s <- gsub("\\s+|\\.+|-+", "_", trimws(s))
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
