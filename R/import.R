

#' Batch imports a data.frame into an ActivityInfo form
#' 
#' @export
importTable <- function(formId, data, recordIdColumn, parentIdColumn) { 
  
  schema <- activityinfo::getFormSchema(formId)
  schemaTable <- as.data.frame(schema)
  providedCols <- names(data)
  if(!missing(recordIdColumn)) {
    providedCols <- providedCols[providedCols != recordIdColumn]
    recordId <- data[[recordIdColumn]]
    if(!is.character(recordIdColumn)) {
      stop(sprintf("Expected a character vector for the recordIdColumn, found %s", deparse(head(recordId))))
    }
    if(anyDuplicated(recordId)) {
      stop("The recordIdColumn contains duplicates.")
    }
  } else {
    recordId <- rep.int(NA_character_, times = nrow(data))
  }
  if(!is.null(schema$parentFormId)) {
    if(missing(parentIdColumn)) {
      stop("When importing to a subform, you must provide a parentIdColumn")
    }
    parentId <- as.character(data[[parentIdColumn]])
    if(!is.character(parentIdColumn)) {
      stop(sprintf("Expected a character vector for the parentIdColumn, found %s", deparse(head(parentId))))
    }
    if(anyNA(parentId)) {
      stop("The parentIdColumn contains missing values.")
    }
    existingParentIds <- queryTable(schema$parentFormId, id = "_id")
    validParentIds <- parentId %in% existingParentIds$id
    if(!all(validParentIds)) {
      stop(sprintf("The parent id column `%s` has %d invalid parent ids, including: %s",
                   parentIdColumn,
                   paste(head(parentIds[!validParentIds]), collapse = ", ")))
    }
  }
  providedCols <- providedCols[providedCols != parentIdColumn]
  
  if(length(providedCols) == 0) {
    stop("The data.frame to import does not have any fields to import.")
  }
  
  fieldIds <- sapply(providedCols, USE.NAMES = FALSE, matchColumn, schemaTable)
  fieldValues <- list()
  for(i in 1:length(fieldIds)) {
    fieldIndex <- which(fieldIds[i] == schemaTable$fieldId)
    columnName <- providedCols[i]
    fieldValues[[i]] <- prepareImport(schema$elements[[fieldIndex]], columnName, data[[columnName]])
  }
  
  if(!missing(parentIdColumn)) {
    fieldValues <- c(
      list(parentId),
      fieldValues
    )
  }
  
  fieldValues <- c(
    list(recordId),
    fieldValues
  )
  
  if(nrow(data) == 0) {
    warning("data.frame to import is empty")
    return()
  }
  recordLines <- character(nrow(data))
  fieldSeq <- seq_along(fieldValues)
  
  for(recordIndex in 1:nrow(data)) {
    record <- lapply(fieldSeq, function(fieldIndex) {
      v <- fieldValues[[fieldIndex]][recordIndex]
      if(is.na(v)) NULL else v
    })
    recordLines[recordIndex] <- rjson::toJSON(record)
  }
  
  lines <- c(
    "LINE DELIMITED JSON RECORDS",
    as.character(nrow(data)),
    rjson::toJSON(fieldIds),
    recordLines)
  
  importId <- stageImport(paste(lines, collapse = "\n"))
  
  activityinfo:::executeJob("importRecords", descriptor = 
                              list(formId = formId,
                                   importId = importId))
  
}


matchColumn <- function(colName, schema) {
  if(colName %in% schema$fieldId) {
    return(colName)
  }
  matchingCodes <- schema$fieldId[tolower(schema$fieldCode) == tolower(colName)]
  if(length(matchingCodes) == 1) {
    return(matchingCodes)
  }
  matchingLabels <- schema$fieldId[tolower(schema$fieldLabel) == tolower(colName)]
  if(length(matchingLabels) == 1) {
    return(matchingLabels)
  }
  if(length(matchingLabels) > 1) {
    stop(sprintf("Ambiguous column name '%s', matches several fields", colName))
  } else {
    stop(sprintf("No matching field for '%s'", colName))
  }
}


prepareImport <- function(field, columnName, column) {
  switch (field$type,
          FREE_TEXT = as.character(column),
          narrative = as.character(column),
          quantity = as.double(column),
          enumerated = prepareEnumImport(field, columnName, column),
          reference = prepareReference(field, column),
          date = prepareDate(field, column),
          stop(sprintf("Field '%s' has unsupported type '%s'", field$label, field$type))
  )
}

prepareEnumImport <- function(field, columnName, column) {
  items <- sapply(field$typeParameters$values, function(item) item$id)
  names(items) <- sapply(field$typeParameters$values, function(item) tolower(item$label))
  
  if(field$typeParameters$cardinality == "single") {
    prepareSingleEnumImport(field, items, columnName, column)
  } else {
    prepareMultiEnumImport(field, column)
  }
}

prepareSingleEnumImport <- function(field, items, columnName, column) {
  force(field)
  force(items)
  force(column)
  column <- as.character(column)
  itemIds <- as.character(items[tolower(column)])
  matching <- is.na(column) | !is.na(itemIds)
  if (any(!matching)) {
    badLabels <- unique(column[!matching])
    stop(
      sprintf(
        "For single-select field '%s', the imported column `%s` has values (%s) which do not match the options defined for this field (%s)",
        field$label,
        columnName,
        paste(collapse = ", ", sprintf("'%s'", badLabels)),
        paste(collapse = ", ", sprintf("'%s'", names(items)))
        
      )
    )
  }
  itemIds
}

prepareMultiEnumImport <- function(field, items, columns) {
  stop("TODO")
}

prepareReference <- function(field, column) {
  column <- as.character(column)
  valid <- grepl(column, pattern = "^[a-z][a-z0-9]{0,30}$")  
  invalid <- !is.na(column) & !valid
  if(any(invalid)) {
    badLabels <- head(unique(column[invalid]), n = 5)
    
    stop(sprintf("Field '%s' contains invalid record ids: %s",
                 field$label,
                 paste(collapse = ", ", sprintf("'%s'", badLabels))))
  }
  column
}

prepareDate <- function(field, column) {
  
  dates <- as.Date(column)
  invalid <- !is.na(column) & is.na(dates)
  if(any(invalid)) {
    badDates <- head(unique(column[invalid]), n = 5)
    
    stop(sprintf("Field '%s' contains %d invalid date values, including: %s",
                 field$label,
                 sum(invalid),
                 paste(collapse = ", ", sprintf("'%s'", badDates))))
  }
  
  strftime(dates, "%Y-%m-%d")
}



#' Stages data to import to ActivityInfo 
#' 
#' 
stageImport <- function(text) {
  
  url <- paste(activityInfoRootUrl(), "resources", "imports", "stage", sep = "/")
  
  result <- POST(url, activityinfo:::activityInfoAuthentication(), accept_json())
  
  if (result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  }
  
  response <- fromJSON(content(result, as = "text", encoding = "UTF-8"))
  
  uploadUrl <- response$uploadUrl
  if(!grepl(uploadUrl, pattern = "^https://")) {
    uploadUrl <- paste0(activityInfoRootUrl(), uploadUrl)
  }
  
  putResult <- PUT(uploadUrl, body = text, encode = "raw", activityinfo:::activityInfoAuthentication())
  if(putResult$status_code != 200) {
    stop("Failed to stage import file at ", uploadUrl, ": status = ", putResult$status_code)
  }
  
  
  response$importId
}

