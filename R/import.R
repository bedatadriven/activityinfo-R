

#' Batch imports a data.frame into an ActivityInfo form
#' @param formId The form ID
#' @param data The data.frame to import
#' @param recordIdColumn The record ID column
#' @param parentIdColumn The parent ID column required when importing a subform
#'
#' @importFrom utils head
#' @export
importTable <- function(formId, data, recordIdColumn, parentIdColumn) { 
  parentId <- NULL

  schema <- activityinfo::getFormSchema(formId)
  schemaTable <- as.data.frame(schema)
  subform <- !is.null(schema$parentFormId)

  providedCols <- names(data)

  if(!missing(recordIdColumn)) {
    recordId <- recordIdFromData(data, recordIdColumn)
    providedCols <- providedCols[providedCols != recordIdColumn]
  } else {
    recordId <- rep.int(NA_character_, times = nrow(data))
  }
  if(subform) {
    parentId <- parentIdFromData(data, parentIdColumn, schema)
    providedCols <- providedCols[providedCols != parentIdColumn]
  } else {
    parentId <- NULL
  }
  
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

  if(nrow(data) == 0) {
    warning("data.frame to import is empty")
    return()
  }

  if(missing(recordIdColumn)) {
    recordId <- matchRecordIdsByKey(schema, data, fieldIds, fieldValues)
  }
  lines <- formatImport(data, recordId, parentId, fieldIds, fieldValues)
  importId <- stageImport(paste(lines, collapse = "\n"))
  
  executeJob("importRecords", descriptor =
                              list(formId = formId,
                                   importId = importId))
  
}

recordIdFromData <- function(data, recordIdColumn) {
  recordId <- data[[recordIdColumn]]
  if(!is.character(recordIdColumn)) {
    stop(sprintf("Expected a character vector for the recordIdColumn, found %s", deparse(head(recordId))))
  }
  if(anyDuplicated(recordId[!is.na(recordId)])) {
    stop("The recordIdColumn contains duplicates.")
  }
  return(recordId)
}

parentIdFromData <- function(data, parentIdColumn, schema) {
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
                 sum(!validParentIds),
                 paste(head(parentId[!validParentIds]), collapse = ", ")))
  }
  return(parentId)
}

matchColumn <- function(colName, schema) {
  if(colName %in% schema$fieldId) {
    return(colName)
  }
  matchingCodes <- schema$fieldId[!is.na(schema$fieldCode) & tolower(schema$fieldCode) == tolower(colName)]
  if(length(matchingCodes) == 1) {
    return(matchingCodes)
  }
  matchingLabels <- schema$fieldId[tolower(schema$fieldLabel) == tolower(colName)]
  if(length(matchingLabels) == 1) {
    return(matchingLabels)
  }
  if(length(matchingLabels) > 1) {
    stop(sprintf("Ambiguous imported column name '%s', matches several fields", colName))
  } else {
    stop(sprintf("No matching field for imported column '%s'", colName))
  }
}


prepareImport <- function(field, columnName, column) {
  switch (field$type,
          FREE_TEXT = as.character(column),
          NARRATIVE = as.character(column),
          quantity = as.double(column),
          enumerated = prepareEnumImport(field, columnName, column),
          reference = prepareReference(field, column),
          date = prepareDate(field, column),
          month = prepareMonth(field, columnName, column),
          serial = prepareSerial(field, columnName, column),
          stop(sprintf("Field '%s' has unsupported type '%s'", field$label, field$type))
  )
}

prepareEnumImport <- function(field, columnName, column) {
  items <- sapply(field$typeParameters$values, function(item) item$id)
  names(items) <- sapply(field$typeParameters$values, function(item) tolower(item$label))
  
  # Replace empty strings with NAs
  column[!nzchar(column)] <- NA_character_
  
  # If this vector has labels, then add those to the lookup table
  if(inherits(column, "haven_labelled")) {
    columnLabels <- attr(column, "labels")
    names(columnLabels) <- tolower(names(columnLabels))
    codedItems <- items
    names(codedItems) <- tolower(columnLabels[ names(codedItems) ])
    items <- c(items, codedItems)
  }
  
  if(field$typeParameters$cardinality == "single") {
    prepareSingleEnumImport(field, items, columnName, column)
  } else {
    prepareMultiEnumImport(field, items, columnName, column)
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

prepareMultiEnumImport <- function(field, items, columnName, column) {
  column <- as.character(column)
  rows <- strsplit(column, split = "\\s*,\\s*")
  
  lapply <- lapply(rows, function(row) {
    if(length(row) == 1 && is.na(row)) {
      return(NA_character_)
    }
    itemIds <- as.character(items[tolower(row)])
    matching <- !is.na(itemIds)
    if (any(!matching)) {
      badLabels <- unique(row[!matching])
      stop(
        sprintf(
          "For multi-select field '%s', the imported column `%s` has values (%s) which do not match the options defined for this field (%s)",
          field$label,
          columnName,
          paste(collapse = ", ", sprintf("'%s'", badLabels)),
          paste(collapse = ", ", sprintf("'%s'", names(items)))
          
        )
      )
    }
    itemIds
  })
  
  
}

prepareReference <- function(field, column) {
  if(grepl(field$typeParameters$range, pattern = "@users$")) {
    return(prepareUserReference(field, column))
  }
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

prepareUserReference <- function(field, column) {
  column <- as.character(column)
  valid <- grepl(column, pattern = "^[0-9]{0,30}$")  
  invalid <- !is.na(column) & !valid
  if(any(invalid)) {
    badLabels <- head(unique(column[invalid]), n = 5)
    
    stop(sprintf("Field '%s' contains invalid user ids: %s",
                 field$label,
                 paste(collapse = ", ", sprintf("'%s'", badLabels))))
  }
  column
}


prepareSerial <- function(field, columnName, column) {
  stop(sprintf("Column '%s': importing serial numbers not (yet) supported", columnName))
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


prepareMonth <- function(field, columnName, column) {

  months <- as.character(column)
  valid <- grepl(pattern = "\\d{4}-\\d{2}", x = column)
  if(any(!valid)) {
    badMonths <- head(unique(column[!valid]), n = 5)

    stop(sprintf("Column '%s' contains %d invalid month values, including: %s",
                 columnName,
                 sum(!valid),
                 paste(collapse = ", ", sprintf("'%s'", badMonths))))
  }
  months
}

matchRecordIdsByKey <- function(schema, data, fieldIds, fieldValues) {
  keyFieldIds <- findKeyFieldIds(schema)
  keys <- which(fieldIds %in% keyFieldIds)

  provided <- as.data.frame(fieldValues[keys])
  names(provided) <- sprintf("k%d", seq_along(keyFieldIds))

  # Check that our input does not include duplicates according to the key
  # fields
  dups <- duplicated(provided)
  if(any(dups)) {
    stop(sprintf("There are %d duplicate rows (by key fields %s) in the input, including row(s) %s",
                 sum(dups),
                 paste(sprintf("`%s`", names(data)[keys]), collapse =", "),
                 paste(head(which(dups)), collapse = ", ")))
  }

  # Match against existing rows
  lookup <- queryLookupTable(schema$id, keyFieldIds)
  matched <- merge(provided, lookup, by = names(provided), all.x = TRUE)

  return(matched$id)
}

findKeyFieldIds <- function(schema) {
  fieldIds <- sapply(schema$elements, function(e) e$id)
  keys <- sapply(schema$elements, function(e) identical(e$key, TRUE))

  return(fieldIds[keys])
}

queryLookupTable <- function(formId, keyFieldIds) {
  columns <- as.list(keyFieldIds)
  names(columns) <- sprintf("k%d", seq_along(keyFieldIds))
  columns[["id"]] <- "_id"

  queryTable(formId, columns, truncate.strings = FALSE)
}

formatImport <- function(data, recordId, parentId, fieldIds, fieldValues) {


  if(!is.null(parentId)) {
    fieldValues <- c(
      list(parentId),
      fieldValues
    )
  }

  fieldValues <- c(
    list(recordId),
    fieldValues
  )

  recordLines <- character(nrow(data))
  fieldSeq <- seq_along(fieldValues)

  for(recordIndex in 1:nrow(data)) {
    record <- lapply(fieldSeq, function(fieldIndex) {
      v <- fieldValues[[fieldIndex]][[recordIndex]]
      if(length(v) == 1 && is.na(v)) NULL else v
    })
    recordLines[recordIndex] <- toJSON(record)
  }

  c("LINE DELIMITED JSON RECORDS",
    as.character(nrow(data)),
    toJSON(as.list(fieldIds)),
    recordLines)
}



#' Stages data to import to ActivityInfo
#' 
#' @param text The text of the file to import.
stageImport <- function(text) {
  
  url <- paste(activityInfoRootUrl(), "resources", "imports", "stage", sep = "/")
  
  result <- POST(url, activityInfoAuthentication(), accept_json())
  
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
  
  putResult <- PUT(uploadUrl, body = text, encode = "raw", activityInfoAuthentication())
  if(putResult$status_code != 200) {
    stop("Failed to stage import file at ", uploadUrl, ": status = ", putResult$status_code)
  }

  response$importId
}



