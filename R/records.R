
#' Checks whether a record exists
#' 
#' @param formId the id of the form to check
#' @param recordId the id of the record to check
recordExists <- function(formId, recordId) {
  tryCatch({
    getRecord(formId, recordId)
    return(TRUE)
  }, 
   error = function(e) {
     if(inherits(e, "http_404")) {
       return(FALSE)
     }
     stop(e)
   })
}


#' Adds a new record
#'
#'
#' @param formId the id of the form to which the record should be added
#' @param parentRecordId the id of this record's parent record, if the form is a subform
#' @param fieldValues a named list of fields to change.
#' @param recordId the id of the new record when a custom id is desired. The given id must be in cuid-compatible format.
#' @export
#' @family record functions
#' @examples
#' \dontrun{
#'
#' # When providing field values, you can use either a field's code, or its
#' # built-in cuid. In the example below, "participant_dob" is a field code,
#' # and "cyz123456" is the same field's built-in id.
#'
#' addRecord(formId = "cyx123", fieldValues = list(participant_dob = "1980-01-01"))
#' addRecord(formId = "cyx123", fieldValues = list(cxyz123456 = "1980-01-01"))
#'
#' # The value of the field depends on its type.
#' # Most fields can be specified using an R string or number, For example:
#' addRecord(formId = "cxy123", fieldValues = list(
#'    text_field = "Alice Jones",
#'    multi_line_text = "Line 1\nLine 2",
#'    date_of_birth = "1980-01-01",
#'    week_project_start = "2022W1",
#'    month = "2023-06",
#'    quantity_field = 42.0))
#'
#' # Single- and multiple-select fields will accept either the label of the
#' # select item, or the item's built-in cuid. For multiple select, you can
#' # provide a vector of strings.
#' addRecord(formId = "cxy123", fieldValues = list(
#'    nationality = c("Palestinian", "Jordanian"),
#'    registered = "Yes"
#' ))
#'
#' # When providing a value for a reference field, you must provide
#' # the built-in ID of the related record. For example, if you a have
#' # a field that references the Afghanistan Province form
#' # (https://www.activityinfo.org/app#form/E0000001249/table),
#' # you must provide the record id, not the name of the province.
#'
#' addRecord(formId = "cxy123", fieldValues = list(
#'    name = "Bibi Khan",
#'    province = "z0000000289"))
#'
#' # When providing a value for geographic point fields, provide a named list
#' # for the point, including the latitude, longitude, and optionally the accuracy
#' # in meters reported by a geolocation sensor.
#'
#' addRecord(formId = "cxy123", fieldValues = list(
#'    name = "Water point 42",
#'    location = list(latitude = 52.0735343, longitude = 4.3304164, accuracy = 12)
#' ))
#'
#' }
addRecord <- function(formId, parentRecordId = NA_character_, fieldValues, recordId = NA_character_) {
  stopifnot(is.character(formId))
  stopifnot(is.character(parentRecordId))
  stopifnot(is.list(fieldValues))
  stopifnot(is.character(recordId))

  if (identical(recordId, NA_character_)) {
    # generate a record id if not provided
    recordId <- cuid()
  } else {
    # check provided record id does not exist before continuing
    if (recordExists(formId, recordId)) {
      stop(sprintf("Record %s in form %s already exists.", recordId, formId))
    }
  }
  changes <- list(
    list(
      formId = formId,
      recordId = recordId,
      parentRecordId = parentRecordId,
      fields = fieldValues
    )
  )

  task <- sprintf("Adding record %s to form %s",
                  changes[[1]]$recordId,
                  ifelse(is.na(parentRecordId),
                         formId,
                         sprintf("%s with parentRecordId %s", formId, parentRecordId)
                  )
  )

  postResource(
    path = "update",
    body = list(changes = changes),
    task = task
    )
  
  getRecord(formId, recordId)
}


#' Updates a single record
#'
#' @param formId a form id
#' @param recordId a record id
#' @param fieldValues a named list of fields to change
#' @export
#' @family record functions
#' @examples
#' \dontrun{
#'
#' # When updating field values, you can use either a field's code, or its
#' # built-in cuid. In the example below, "participant_dob" is a field code,
#' # and "cyz123456" is the same field's built-in id.
#'
#' updateRecord(formId = "cyx123", fieldValues = list(participant_dob = "1980-01-01"))
#' updateRecord(formId = "cyx123", fieldValues = list(cxyz123456 = "1980-01-01"))
#'
#' # To set a record to blank, use the NA value.
#' updateRecord(formId = "cupqmc2l1bvi9ys2",
#'   recordId = "ckl8h0l1bvj7lfd",
#'   fieldValues = list(HOH_NAME = NA))
#'
#' # The value of the field depends on its type.
#' # Most fields can be specified using an R string or number, For example:
#' updateRecord(formId = "cxy123", recordId = "czyz3323", fieldValues = list(
#'    text_field = "Alice Jones",
#'    multi_line_text = "Line 1\nLine 2",
#'    date_of_birth = "1980-01-01",
#'    week_project_start = "2022W1",
#'    month = "2023-06",
#'    quantity_field = 42.0))
#'
#' # Single- and multiple-select fields will accept either the label of the
#' # select item, or the item's built-in cuid. For multiple select, you can
#' # provide a vector of strings.
#' updateRecord(formId = "cxy123", recordId = "czyz3323", fieldValues = list(
#'    nationality = c("Palestinian", "Jordanian"),
#'    registered = "Yes"
#' ))
#'
#' # When providing a value for a reference field, you must provide
#' # the built-in ID of the related record. For example, if you a have
#' # a field that references the Afghanistan Province form
#' # (https://www.activityinfo.org/app#form/E0000001249/table),
#' # you must provide the record id, not the name of the province.
#'
#' updateRecord(formId = "cxy123", recordId = "czyz3323", fieldValues = list(
#'    name = "Bibi Khan",
#'    province = "z0000000289"))
#'
#' # When providing a value for geographic point fields, provide a named list
#' # for the point, including the latitude, longitude, and optionally the accuracy
#' # in meters reported by a geolocation sensor.
#'
#' updateRecord(formId = "cxy123", recordId = "czyz3323", fieldValues = list(
#'    name = "Water point 42",
#'    location = list(latitude = 52.0735343, longitude = 4.3304164, accuracy = 12)
#' ))
#'
#' }
updateRecord <- function(formId, recordId, fieldValues) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))
  stopifnot(is.list(fieldValues))
  
  if(!recordExists(formId, recordId)) {
    stop(sprintf("Record %s in form %s does not exist or you do not have permission to view it.", formId, recordId))
  }

  changes <- list(
    list(
      formId = formId,
      recordId = recordId,
      fields = fieldValues
    )
  )

  postResource(
    path = "update",
    body = list(changes = changes),
    task = sprintf("Updating record %s in form %s", recordId, formId)
  )
}

#' Delete a record
#'
#' @description
#' This call deletes a single record for the given \code{formId} and
#' \code{recordId}.
#'
#' @param formId a form id
#' @param recordId a record id
#'
#' @export
#' @family record functions
#' @examples
#' \dontrun{
#'
#' # Deletes a record
#' deleteRecord(formId = "cyx123", recordId = "c23g322j432")
#'
#' # Recover (undelete) a record
#' recoverRecord(formId = "cyx123", recordId = "c23g322j432")
#' }
deleteRecord <- function(formId, recordId) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))

  changes <- list(
    list(
      formId = formId,
      recordId = recordId,
      deleted = TRUE
    )
  )

  postResource(
    path = "update",
    body = list(changes = changes),
    task = sprintf("Delete record %s in form %s", recordId, formId)
    )
}

#' Gets the list of changes to a record
#'
#' @description
#' This calls retrieves a list of all changes to the record, and the users
#' who initially added and then have modified that record.
#'
#' @param formId a form id
#' @param recordId a record id
#' @param asDataFrame Retrieve user list as a data.frame, otherwise returns as list. Default: TRUE
#' @export
#' @family record functions
getRecordHistory <- function(formId, recordId, asDataFrame = TRUE) {
  recHist <- getResource(
    paste("form", formId, "record", recordId, "history", sep = "/"),
    task = sprintf("Get record %s history from form %s", recordId, formId)
    )
  
  if (asDataFrame == TRUE) {
    recHist <- recHist$entries
    
    recHistDF <- dplyr::tibble(
      formId = unlist(lapply(recHist, function(x) {x$formId})),
      recordId = unlist(lapply(recHist, function(x) {x$recordId})),
      version = unlist(lapply(recHist, function(x) {x$version})),
      time = format(as.POSIXct(unlist(lapply(recHist, function(x) {x$time})), origin = "1970-01-01", tz = "UTC"), "%Y-%m-%d %H:%M:%S"), #unlist(lapply(reHist, function(x) {x$time})),
      subFieldId = unlist(lapply(recHist, function(x) {x$subFieldId})),
      subFieldLabel = unlist(lapply(recHist, function(x) {x$subFieldLabel})),
      subRecordKey = unlist(lapply(recHist, function(x) {x$subRecordKey})),
      changeType = unlist(lapply(recHist, function(x) {x$changeType})),
      user = lapply(recHist, function(x) {x$user}),
      values = lapply(recHist, function(x) {x$values})
    )
    # recHistDF$time <- format(as.POSIXct(recHistDF$time, origin = "1970-01-01", tz = "UTC"), "%Y-%m-%d %H:%M:%S")
    return(recHistDF)
  }
  
  return(recHist)
}

#' Gets a single record
#'
#' @param formId a form id
#' @param recordId the record Id
#' @export
#'
#' @family record functions
#' @examples
#'
#' # Retrieve a record from the Afghan District form in the Geodatabase.
#' # See: https://www.activityinfo.org/app#form/E0000001562/table
#'
#' record <- getRecord(formId = "E0000001562", recordId = "z0000455007")
#'
#' print(record)
#' # $recordId
#' # [1] "z0000455007"
#' #
#' # $formId
#' # [1] "E0000001562"
#' #
#' # $lastEditTime
#' # [1] 1667421104
#' #
#' # $fields
#' # $fields$E00000015620000000005
#' # $fields$E00000015620000000005$latitude
#' # [1] 36.78076
#' #
#' # $fields$E00000015620000000005$longitude
#' # [1] 68.8198
#' #
#' # $fields$E00000015620000000003
#' # [1] "AF1701"
#' #
#' # $fields$E00000015620000000002
#' # [1] "E0000001249:z0000000289"
#' #
#' # $fields$E00000015620000000001
#' # [1] "Kunduz"
#'
getRecord <- function(formId, recordId) {
  getResource(
    sprintf("form/%s/record/%s", formId, recordId),
    task = sprintf("Get record %s from form %s", recordId, formId)
    )
}

#' Gets an attachment
#'
#' Retrieve an attachment and store it to a temporary file. The name
#' of the temporary file is returned.
#'
#' @param formId a form id
#' @param recordId the record Id
#' @param fieldId the attachment field id
#' @param blobId the attachment blob id
#' @export
#' @family record functions
#'
getAttachment <- function(formId, recordId, fieldId, blobId) {
  url <- modify_url(activityInfoRootUrl(), path = sprintf("resources/form/%s/record/%s/field/%s/blob/%s/signature.png",
                                                          formId,
                                                          recordId,
                                                          fieldId,
                                                          blobId))
  message("Sending GET request to ", url)

  tmp <- tempfile()

  result <- GET(url, activityInfoAuthentication(), accept_json(), write_disk(tmp))

  checkForError(result)

  if (result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  } else {
    message_for_status(result)
  }

  tmp
}


#' Create a reference field value
#'
#' @description
#' This call creates a 'reference' field value for the given \code{formId} and
#' \code{recordId}.
#'
#' @param formId the id of the form
#' @param recordId the id of the record
#' @export
reference <- function(formId, recordId) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))

  sprintf("%s:%s", formId, recordId)
}

#' Recover a deleted record
#'
#' @description
#' This call recovers a single deleted record for the given \code{formId} and
#' \code{recordId}.
#'
#' @param formId a form id
#' @param recordId a record id
#'
#' @export
#' @family record functions
#' @examples
#' \dontrun{
#'
#' # Deletes a record
#' deleteRecord(formId = "cyx123", recordId = "c23g322j432")
#'
#' # Recover (undelete) a record
#' recoverRecord(formId = "cyx123", recordId = "c23g322j432")
#' }
recoverRecord <- function(formId, recordId) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))

  path<-sprintf("form/%s/record/%s/recover",formId,recordId)
  postResource(path = path, NULL, task = sprintf("Recover record %s from form %s", recordId, formId))
}

# ---- Get records ----

#' Get a form's records as a table
#'
#' @description
#' This function will create a reference to records on the server. For large forms, 
#' this does not immediately transfer all records; you can use the [dplyr::filter],
#' [dplyr::arrange], [dplyr::slice_head], [dplyr::slice_tail], and/or [activityinfo::adjustWindow] 
#' functions to narrow the the selection of records. 
#' 
#' To prevent downloading the records before making a selection use the verbs in 
#' this order.
#' 1. [dplyr::arrange] (limited to a single column) and/or [dplyr::filter] in any combination
#' 2. [dplyr::slice_head] or [activityinfo::adjustWindow] in any combination
#'
#' @param form a form id, form schema, form tree, or activity info data frame
#' @param style a column style object that defines how table columns should be created from a form; use [activityinfo::columnStyle] to create a new style; 
#' default column styles can be set with an option or [activityinfo::defaultColumnStyle]. Default `columnNames` is set to "pretty".
#' @export
#' 
#' @examples 
#' \dontrun{
#' 
#' # Retrieve all the records from the Simple 3W template's project form:
#' # https://www.activityinfo.org/app#form/ceam1x8kq6ikcujg/table
#' 
#' records <- getRecords("ceam1x8kq6ikcujg")
#' 
#' # Now, filter by only projects with a status "Under implementation"
#' records <- getRecords("ceam1x8kq6ikcujg") %>%
#'    filter(`Project status` == "Under implementation")
#' 
#' # If you want to use the field codes, set the column style using the `columnStyle()`
#' # function and setting `columnName` argument to 'code'.
#' # You can then use the field code in your filter:
#' records <- getRecords("ceam1x8kq6ikcujg", style = columnStyle(columnNames = "code")) %>%
#'    filter(START_MONTH == "2018-01")
#' 
#' # If you prefer to work with the ActivityInfo field IDs, then you can change
#' # the column style and the `columnNames` argument to "id":
#' records <- getRecords("ceam1x8kq6ikcujg", style = columnStyle(columnNames = "id")) %>%
#'    filter(cgkh1k5kq6k0gsmv == "2018-01")
#' 
#' }
#' 
getRecords <- function(form, style) {
  UseMethod("getRecords")
}


#' @export
getRecords.activityInfoFormTree <- function(form, style = defaultColumnStyle()) {
  src <- src_activityInfo(form)
  dplyr::tbl(src, form, style)
}

#' @export
getRecords.activityInfo_tbl_df <- function(form, style) {
  x <- attr(form, "remoteRecords")
  if (missing(style)) {
    return(x)
  } else {
    getRecords(x$formTree, style)
  }
}

#' @export
getRecords.character <- function(form, style = defaultColumnStyle()) {
  fmTree <- getFormTree(form)
  getRecords(form = fmTree, style = style)
}
#' @export
getRecords.activityInfoFormSchema <- function(form, style = defaultColumnStyle()) {
  getRecords(form = form$id, style)
}

getRecords.default <- getRecords.character

# ---- Column styles ----

#' A form table style constructor
#'
#' @description
#' This function is used to modify existing styles and create new styles. Most 
#' of the time other helper functions will be more immediately useful:
#' * [activityinfo::minimalColumnStyle] : retain only the columns exactly as in the web interface
#' * [activityinfo::prettyColumnStyle] : use the web interface style but include record metadata
#' * [activityinfo::allColumnStyle] : use all columns with a default to using the activityInfo formula style to label columns
#'
#' A style can be set as a default style using [activityinfo::defaultColumnStyle].
#' 
#' The column names options are:
#' * "pretty": Using the labeling logic of the web user interface as much as possible, for example "Focus Country Name"
#' * "label" : Using the form field labels in the style of ActivityInfo formulas, for example "\[Focus Country\].\[Name\]"
#' * "code" : Using form field codes as defined by the user, for example "country.name". As codes are optional, the fallback columnName option can be specified as a vector, for example c("code", "label") or c("code", "id).
#' * "id" : Using the form field unique id used by ActivityInfo, for example "c12c92vi5olfmn7khb4.c13cmf6la3lfmn7khb5"
#'
#' @param recordId include the record id of each record in the form table; 
#' default is TRUE to make it easier to join data in R
#' @param lastEditedTime the time the record was last edited; default is TRUE
#' @param referencedId include the record id for values in referenced fields; 
#' default is TRUE to make it easier to join data in R.
#' @param referencedKey key fields from the referenced form; 
#' default is TRUE to make it easier to join data in R.
#' @param allReferenceFields include all the fields in referenced records; the 
#' default is FALSE
#' @param columnNames Can be "pretty", "label", "id", c("code", "id), or c("code", "label"); default is "pretty".
#' @param .names_repair Treatment of problematic column names following the approach used in tibbles / vctrs. Default is "unique".
#' @param style a style to modify with one or more parameters
#' @param maxDepth the maximum depth of recursion in referenced forms. This is set to 2 by default.
#' 
#' @export
columnStyle <- function(
    referencedId = TRUE,
    referencedKey = TRUE,
    allReferenceFields = FALSE,
    columnNames = "pretty",
    recordId = TRUE,
    lastEditedTime = TRUE,
    .names_repair = "unique",
    style,
    maxDepth = 2
    ) {
  stopifnot(is.logical(referencedId))
  stopifnot(is.logical(referencedKey))
  stopifnot(is.character(columnNames))
  stopifnot(is.logical(recordId))
  stopifnot(is.logical(lastEditedTime))
  stopifnot("maxDepth must be a whole number" = is.numeric(maxDepth)&&maxDepth==as.integer(maxDepth)&&maxDepth>0)
  if(!missing(style)) {
    stopifnot(is.list(style))
    stopifnot("activityInfoColumnStyle" %in% class(style))
    args <- as.list(match.call())[-1]
    invisible(lapply(names(args), function(y) {
      if (y!="style") {
        style[y] <<- args[[y]]
      }
      NULL
    }))
  } else {
    style <- list(
      "referencedId" = referencedId,
      "referencedKey" = referencedKey,
      "allReferenceFields" = allReferenceFields,
      "columnNames" = columnNames,
      "recordId" = recordId,
      "lastEditedTime" = lastEditedTime,
      ".names_repair" = .names_repair,
      "maxDepth" = maxDepth
    )
    class(style) <- c("activityInfoColumnStyle", class(style))
  }

  style
}

#' A form table style with columns in the pretty style used by the web interface 
#' including record metadata
#'
#' @description
#' This function is primarily used in [activityinfo::getRecords]. See [activityinfo::minimalColumnStyle] for a style 
#' exclusively shows the same columns as in the web interface
#'
#' @param recordId include the record if of each record in the form table; 
#' default is TRUE to make it easier to join data in R
#' @param lastEditedTime the time the record was last edited; default is TRUE
#' @param referencedId include the record id for values in referenced fields; 
#' default is TRUE to make it easier to join data in R.
#' @param allReferenceFields include all the fields in referenced records; the 
#' default is FALSE
#' @param maxDepth the maximum depth of recursion in referenced forms. This is set to 2 by default.
#' @export
prettyColumnStyle <- function(
    recordId = TRUE, 
    lastEditedTime = TRUE, 
    referencedId = TRUE, 
    allReferenceFields = FALSE, 
    maxDepth = 2
    ) {
  columnStyle(referencedId = referencedId,
              referencedKey = TRUE,
              allReferenceFields = allReferenceFields,
              columnNames = "pretty",
              recordId = recordId,
              lastEditedTime = lastEditedTime,
              maxDepth = maxDepth)
}

#' A form table style including all columns with configurable label names
#'
#' @description
#' This function is primarily used in [activityinfo::getRecords].
#' 
#' The column names options are:
#' * "pretty": Using the labelling logic of the web user interface as much as possible, for example "Focus Country Name"
#' * "label" : Using the form field labels in the style of activity info formulas, for example "\[Focus Country\].\[Name\]"
#' * "code" : Using form field codes as defined by the user, for example "country.name". As codes are optional, the fallback columnName option can be specified as a vector, for example c("code", "label") or c("code", "id).
#' * "id" : Using the form field unique id used by ActivityInfo, for example "c12c92vi5olfmn7khb4.c13cmf6la3lfmn7khb5"
#'
#' @param columnNames Can be "pretty", "label", "id", c("code", "id), or c("code", "label")
#' @param maxDepth the maximum depth of recursion in referenced forms. This is set to 2 by default.
#' 
#' @export
allColumnStyle <- function(
    columnNames = c("code", "label"), 
    maxDepth = 2
    ) {
  columnStyle(referencedId = TRUE,
              referencedKey = TRUE,
              allReferenceFields = TRUE,
              columnNames = columnNames,
              recordId = TRUE,
              lastEditedTime = TRUE,
              maxDepth = maxDepth)
}

#' A form table style including all columns with ids as column names
#'
#' @description
#' This function is primarily used in [activityinfo::getRecords].
#' 
#' @param maxDepth the maximum depth of recursion in referenced forms. This is set to 3 by default.
#' 
#' @export
idColumnStyle <- function(
    maxDepth = 2
    ) {
  allColumnStyle(
    columnNames = "id", 
    maxDepth = maxDepth)
}

#' A form table style with columns limited to those in the web interface 
#' 
#' @description
#' This function is primarily used in getRecords().
#' 
#' @param maxDepth the maximum depth of recursion in referenced forms. This is set to 3 by default.
#' 
#' @export
minimalColumnStyle <- function(
    maxDepth = 2
    ) {
  prettyColumnStyle(
    referencedId = FALSE, 
    allReferenceFields = FALSE, 
    recordId = FALSE, 
    lastEditedTime = FALSE, 
    maxDepth = maxDepth)
}

#' Set or get the default column style as an R option 
#' 
#' @description
#' For example to set a column style, the following are possible:
#' 
#' defaultColumnStyle(minimalColumnStyle())
#' defaultColumnStyle(allColumnStyle())
#' 
#' Set to prettyColumnStyle but you also want all reference fields:
#' defaultColumnStyle(prettyColumnStyle(allReferenceFields = TRUE))
#' 
#' Use defaultColumnStyle() without an argument to get the current default style 
#' object.
#' 
#' @param style the style object to set as the default style for column created 
#' with a helper function such as [activityinfo::idColumnStyle], [activityinfo::prettyColumnStyle], 
#' [activityinfo::minimalColumnStyle] or [activityinfo::allColumnStyle].
#' 
#' @export
defaultColumnStyle <- function(style) {
  if(missing(style)) {
    getOption("activityInfoColumnStyle", default = columnStyle())
  } else {
    stopifnot("Style object must be of class activityInfoColumnStyle" = "activityInfoColumnStyle" %in% class(style))
    options(activityInfoColumnStyle = style)
  }
}

# ---- Query table column helpers ----

#' Create the column selection object in the pretty style used by the web 
#' interface including record metadata for queryTable()
#'
#' @description
#' This function is primarily used for [activityinfo::queryTable].
#'
#' @param x the form id, form schema, form tree, or remote records object.
#' @param select a character vector of column names to select.
#' @param ... parameters passed on to [activityinfo::prettyColumnStyle]
prettyColumns <- function(x, select, ...) {
  styleUI <- prettyColumnStyle(...)

  styleId <- styleUI
  styleId$columnNames <- "id"
  
  columns <- varNames(x, styleId, addNames = FALSE)
  names(columns) <- varNames(x, styleUI, addNames = FALSE)
  
  selectColumns(columns, select)
}

#' Create the column selection object for queryTable() using styles
#'
#' @description
#' This function is primarily used for [activityinfo::queryTable]. The default column style is 
#' used or can be overridden using the style parameter. 
#'
#' @param x the form id, form schema, form tree, or remote records object.
#' @param select a character vector of column names to select.
#' @param style a column style object.
#' @param forceId require the underlying expression for each column to be based 
#' on form field ids and not the code or label
styledColumns <- function(x, select, style = defaultColumnStyle(), forceId = FALSE) {
  stopifnot("activityInfoColumnStyle" %in% class(style))

  styleVars <- style
  if (styleVars$columnNames[[1]]=="pretty"||forceId) {
    styleVars$columnNames <- "id"
  }

  columns <- varNames(x, styleVars, addNames = FALSE)
  names(columns) <- varNames(x, style, addNames = FALSE)

  selectColumns(columns, select)
}

selectColumns <- function(columns, select) {
  if(!missing(select)) {
    stopifnot("select must be a character vector of column names." = is.character(select))
    columns <- columns[select]
    columns[sapply(columns, is.null)] <- NULL
  }
  columns
}


# ---- (Dim)names ----

#' @export
dimnames.activityInfoFormTree <- function(x) {
  list(
    NULL,
    varNames(x, addNames = FALSE)
  )
}

#' @export
dim.activityInfoFormTree <- function(x) {
  c(
    NA,
    length(varNames(x, addNames = FALSE))
  )
}

#' @export
dimnames.tbl_activityInfoRemoteRecords <- function(x) {
  if(!is.null(x$step$window)&&x$step$window[2]>0) {
    list(
      as.character(1:x$step$window[2]),
      unname(tblNames(x))
    )
  } else {
    list(
      NULL,
      unname(tblNames(x))
    )
  }
}

#' @export
dim.tbl_activityInfoRemoteRecords <- function(x) {
  if (!is.null(x$step$window)) {
    c(
      min(x$step$window[2], x$totalRecords),
      length(tblNames(x))
    )
  } else {
    c(x$totalRecords, length(tblNames(x)))
  }
}

## Current cannot implement this because it breaks View() in RStudio specifically due to a wrapper function
# #' @export
# names.tbl_activityInfoRemoteRecords <- function(x) {
#  colnames(x)
# }

#' @exportS3Method as.list tbl_activityInfoRemoteRecords
as.list.tbl_activityInfoRemoteRecords <- function(x, ...) {
  return(as.list(unclass(x), ...))
}

#' @export
dimnames.activityInfoFormSchema <- dimnames.activityInfoFormTree
dimnames.activityInfoRemoteRecords <- dimnames.activityInfoFormSchema

# ---- View ----

#' @importFrom tibble view
#' @exportS3Method view tbl_activityInfoRemoteRecords
view.tbl_activityInfoRemoteRecords <- function(x, title, ..., n) {
  tibble::view(x, title, ..., n)
}

#' @export
tibble::view

# ---- Tidy select and tbl_vars extensions ----

#' @importFrom dplyr tbl_vars
#' @export
tbl_vars.tbl_activityInfoRemoteRecords <- function(x) {
  tblNames(x)
}

#' @importFrom rlang rep_named
#' @importFrom dplyr as_tibble
#' @importFrom tidyselect tidyselect_data_proxy tidyselect_data_has_predicates
#' @export
tidyselect_data_proxy.tbl_activityInfoRemoteRecords <- function(x) {
  as_tibble(rep_named(tblNames(x), list(logical())), .name_repair = "minimal")
}

#' @export
tidyselect_data_has_predicates.tbl_activityInfoRemoteRecords <- function(x) {
  FALSE
}

# ---- Form schema to column variables ----

#' Get the variable and/or column names for forms
#'
#' @description
#' This function provides the list of variable names in the 
#' [activityinfo::defaultColumnStyle] but it is possible to override with another style.
#'
#' @param x the form id, form schema, form tree, or remote records object.
#' @param style a column style object.
#' @param addNames if TRUE will name the vector. Used internally to create 
#' column selection objects for [activityinfo::queryTable]. Typically a helper function such 
#' as [activityinfo::prettyColumns] should be used to create columns.
#' 
#' @export
varNames <- function(x, style, addNames) {
  UseMethod("varNames")
}

#' @importFrom vctrs vec_as_names
#' @exportS3Method varNames activityInfoFormTree
varNames.activityInfoFormTree <- function(x, style = defaultColumnStyle(), addNames = FALSE) {
  # Internal helper function with recursion control
  varNamesHelper <- function(x, visitedFormIds) {
    if (length(visitedFormIds) > style$maxDepth) return(character())
    
    fmSchema <- x$forms[[x$root]]
    
    # Check if this form has already been processed
    if (fmSchema$id %in% visitedFormIds) {
      # Form already visited; prevent infinite recursion
      return(character())
    }
    
    # Add current form id to visitedFormIds
    visitedFormIds <- c(visitedFormIds, fmSchema$id)
    
    vrNames <- character()
    
    if ("parentFormId" %in% names(fmSchema)) {
      parentSchema <- x$forms[[fmSchema$parentFormId]]    
      if (style$allReferenceFields) {
        parentVarNames <- varNamesHelper(list(root = fmSchema$parentFormId, forms = x$forms), visitedFormIds)
      } else {
        parentVarNames <- unlist(lapply(parentSchema$elements, function(y) {
          if (y$key) {
            elementVarName(y, style)
          }
        }))
        parentVarNames <- parentVarNames[lengths(parentVarNames) != 0]
      }
      
      if (length(parentVarNames) > 0) {
        if (identical(style$columnNames, "pretty")) {
          parentVarNames <- paste("Parent", parentVarNames, sep = " ")
        } else {
          parentVarNames <- paste("@parent", parentVarNames, sep = ".")
        }
      }
      
      vrNames <- c(vrNames, "@parent", parentVarNames)
    }
    
    if (style$recordId) vrNames <- c(vrNames, "_id")
    if (style$lastEditedTime) vrNames <- c(vrNames, "_lastEditTime")
    
    vrNames <- c(vrNames, unlist(lapply(fmSchema$elements, function(y) {
      elementVars(
        element = y, 
        formTree = x, 
        style = style, 
        namedElement = FALSE,
        visitedForms = visitedFormIds  # Pass visitedFormIds to elementVars
      )
    })))
    
    vrNames
  }
  
  # Start recursion with empty visitedFormIds
  vrNames <- varNamesHelper(x, visitedFormIds = character())
  
  # Ensure unique and valid variable names
  vrNames <- vctrs::vec_as_names(vrNames, repair = style[[".names_repair"]], quiet = TRUE)
  
  if (addNames) {
    names(vrNames) <- vrNames
  }
  
  vrNames
}

#' @exportS3Method varNames activityInfoFormSchema
varNames.activityInfoFormSchema <- function(x, style = defaultColumnStyle(), addNames = FALSE) {
  varNames(getFormTree(x$id), style, addNames)
}

#' @exportS3Method varNames tbl_activityInfoRemoteRecords
varNames.tbl_activityInfoRemoteRecords <- function(x, style = NULL, addNames = TRUE) {
  y <- x$step$vars
  if (!addNames) {
    unname(y)
  }
  y
}

#' @exportS3Method varNames character
varNames.character <- function(x, style = defaultColumnStyle(), addNames = FALSE) {
  varNames(getFormTree(x), style, addNames)
}

#' @exportS3Method varNames activityInfo_tbl_df
varNames.activityInfo_tbl_df <- function(x, style = NULL, addNames = TRUE) {
  warning("Getting the variable names from the collected remote records object. This can deviate from the data.frame columns if they have changed.")
  varNames(attr(x, "remoteRecords"), style = NULL, addNames)
}

#' Get form field schemas from a form tree in a named list using a column style 
#' to select and name each form field
#'
#' @description
#' This helper function provides form field schemas in a named list. This can be 
#' useful for examining and manipulating form fields. See also [activityinfo::extractSchemaFromFields].
#'
#' @param formTree the form tree object.
#' @param style a column style object.
#' 
#' @export
namedElementVarList <- function(formTree, style = defaultColumnStyle()) {
  stopifnot("A form tree must be provided" = "activityInfoFormTree" %in% class(formTree))
  fmSchema <- formTree$forms[[formTree$root]]

  unlist(lapply(fmSchema$elements, function(x) {
    elementVars(
      element = x, 
      formTree = formTree, 
      style = style, 
      namedElement = TRUE)
  }), recursive = FALSE)
}

elementVars <- function(element, formTree, style = defaultColumnStyle(), namedElement = FALSE, includeFirst = TRUE, useParentLabel, parentLabel, visitedForms = NULL) {
  # Initialize visitedForms if NULL
  if (is.null(visitedForms)) {
    visitedForms <- character()
  } else if (length(visitedForms) > style$maxDepth) {
    return(NULL)
  }
  
  elementList <- list()
  
  useParentLabel <- (!missing(useParentLabel) && useParentLabel)
  if (useParentLabel) {
    stopifnot(!missing(parentLabel) && is.character(parentLabel) && length(parentLabel) == 1)
    stopifnot("There is a parent label for a form element but no parent form." = length(visitedForms)>0)
  } else {
    parentLabel <- ""
  }
  
  # check if the element is a reference field and form has been visited
  isRefId <- inherits(element, "activityInfoReferenceFieldSchema")
  refFormVisited <- FALSE
  if (isRefId) {
    refFormId <- element$typeParameters$range[[1]]$formId
    if (refFormId %in% visitedForms) {
      refFormVisited <- TRUE
    }
  }
  
  if (
    (includeFirst && !(isRefId && !style$referencedId))||refFormVisited) {
    fieldName <- elementVarName(element, style)
    
    if (useParentLabel && parentLabel != "") {
      if (style$columnNames[[1]] == "pretty") {
        fullName <- paste0(parentLabel, " ", fieldName)
      } else {
        fullName <- paste0(parentLabel, ".", fieldName)
      }
    } else {
      fullName <- fieldName
    }
    
    elementList[[fullName]] <- element
  }

  if (!refFormVisited) { 
    # If it is a reference field, get all related fields according to the style
    if (isRefId && (style$referencedKey || style$allReferenceFields)) {
      
      newVisitedForms <- c(visitedForms, refFormId)
      
      refFormSchema <- formTree$forms[[refFormId]]
      
      # Collect all the referenced form fields
      refFormSchemaElements <- lapply(refFormSchema$elements, function(x) {
        if (x$key || style$allReferenceFields) {
          x
        } else {
          NULL
        }
      })
      refFormSchemaElements <- refFormSchemaElements[lengths(refFormSchemaElements) != 0]
      
      
      # test whether to use form labels (shallow ref) or field labels (deep ref)
      hasRefFields <- any(sapply(refFormSchemaElements, function(e) inherits(e, "activityInfoReferenceFieldSchema")))
      isShallowRef <- !hasRefFields && length(visitedForms) <= 1 && parentLabel == ""
      
      fieldName <- elementVarName(element, style)
      
      refElementLists <- lapply(refFormSchemaElements, function(z) {
        if (style$columnNames[[1]] == "pretty" && !isShallowRef) {
            refParentLabel <- refFormSchema$label
        } else {
          if (parentLabel != "") {
            refParentLabel <- paste0(parentLabel, ".", fieldName)
          } else {
            refParentLabel <- fieldName
          }
        }
        
        elementVars(
          element = z,
          formTree = formTree,
          style = style,
          namedElement = TRUE,
          includeFirst = TRUE,
          useParentLabel = TRUE,
          parentLabel = refParentLabel,
          visitedForms = newVisitedForms
        )
      })
      
      refElementList <- do.call(c, refElementLists)
      
      elementList <- c(elementList, refElementList)
    }
  }

  if (namedElement) {
    return(elementList)
  } else {
    return(names(elementList))
  }
}
 
elementVarName <- function(y, style) {
  stopifnot(style$columnNames %in% c("pretty", "label", "code", "id"))

  colNameStyle <- style$columnNames[[1]]

  colName = NULL

  if(colNameStyle == "code") {
    colName <- y[["code"]]
    if(is.null(colName)) {
      if (length(style$columnNames)>1&&style$columnNames[[2]] %in% c("label", "id")) {
        colNameStyle <- style$columnNames[[2]]
      } else {
        colNameStyle <- "id"
      }
    }
  }

  if (colNameStyle == "pretty") {
    colName <- trimws(y[["label"]])
  } else {
    # need to add escaping of labels
    if(colNameStyle == "label") {
      if(nchar(y[["label"]])>255) {
        colNameStyle <- "id"
      } else {
        colName <- trimws(y[["label"]])

        if (!grepl(pattern = "^[A-Za-z_][A-Za-z0-9_]*$", colName)) {
        # check with Alex on non ASCII letters:
        #if (!grepl("^[\\p{L}\\p{M}]+$", colName, perl = TRUE)) {
          colName <- sprintf("[%s]", colName)
        }
      }
    }

    if (colNameStyle == "id") {
      colName <- y[["id"]]
    }
  }

  if(is.null(colName)) {
    stop("No column name found. Check with package maintainer.")
  }

  colName
}



# ---- Lazy remote table ----

#' @importFrom dplyr tbl
#' @exportS3Method tbl src_activityInfo
tbl.src_activityInfo <- function(src, formTree, style = defaultColumnStyle(),...) {
  stopifnot(formTree$root %in% dplyr::src_tbls(src))

  recordsMetadata <- getTotalLastEditTime(formTree)
  totalRecords = recordsMetadata[["totalRecords"]]
  lastEditTime = recordsMetadata[["lastEditTime"]]
  
  step = firstStep(formTree, style, totalRecords)
  idStyle <- style
  idStyle$columnNames <- "id"

  elements = namedElementVarList(formTree = formTree, style = idStyle)

  dplyr::make_tbl(
    c("activityInfoRemoteRecords", "lazy"),
    "src" = src,
    "formTree" = formTree,
    "style" = style,
    "columns" = step$columns,
    "step" = step,
    "elements" = elements,
    "totalRecords" = totalRecords,
    "lastEditTime" = lastEditTime
  )
}

getTotalLastEditTime <- function(formTree) {
  df <- queryTable(formTree$root, columns = list("id"="_id", "lastEditTime" = "_lastEditTime"), asTibble = TRUE, makeNames = FALSE, window = c(0L,1L), sort=list(list(dir = "DESC", field = "_lastEditTime")))
  totalRecords <- attr(df, "totalRows")
  if (totalRecords==0) {
    # required to check the formTree as queryTable used in totalRecords does not error if there are no permissions but returns 0 rows
    formTree <- getFormTree(formTree$root)
    df <- queryTable(formTree$root, columns = list("id"="_id", "lastEditTime" = "_lastEditTime"), asTibble = TRUE, makeNames = FALSE, window = c(0L,1L), sort=list(list(dir = "DESC", field = "_lastEditTime")))
    totalRecords <- attr(df, "totalRows")
  }
  lastEditTime = df[[1,"lastEditTime"]]
  list(totalRecords = totalRecords, lastEditTime = lastEditTime, df = df)
}

getTotalRecords <- function(formTree) {
  df <- queryTable(formTree$root, columns = list("id"="_id"), asTibble = TRUE, makeNames = FALSE, window = c(0L,1L))
  totalRecords <- attr(df, "totalRows")
  if (totalRecords==0) {
    # required to check the formTree as queryTable used in totalRecords does not error if there are no permissions but returns 0 rows
    formTree <- getFormTree(formTree$root)
    df <- queryTable(formTree$root, columns = list("id"="_id"), asTibble = TRUE, makeNames = FALSE, window = c(0L,1L))
    totalRecords <- attr(df, "totalRows")
  }
  totalRecords
}

#' Add an ActivityInfo API style filter
#'
#' @description
#' This adds a filter to an ActivityInfo remote records object. Usually one 
#' would use the [dplyr::filter] verb instead. The [dplyr::filter] verb attempts 
#' to translate R expressions into ActivityInfo style filters. 
#' 
#' But if [dplyr::filter] is not successful, it can be useful to add this filter formula using addFilter()
#'
#' @param x the remote records object fetched with [activityinfo::getRecords].
#' @param formulaFilter a character string with the formula.
#' 
#' @export
addFilter <- function(x, formulaFilter) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  stopifnot("ActivityInfo formula filter must be a character vector" = is.character(formulaFilter))

  if(getOption("activityinfo.verbose.requests"))
    message(sprintf("Adding filter: %s", formulaFilter))
  
  x$step <- newStep(x$step, filter = formulaFilter)

  x
}

#' Add an ActivityInfo API style sort object
#'
#' @description
#' This adds a single sorted column to an ActivityInfo remote records object. 
#' Usually one would use the [dplyr::arrange] verb instead.
#'
#' @param x the remote records object fetched with [activityinfo::getRecords].
#' @param sort the sort object in the following format: list(list(dir = "ASC", field = "\[Name\]")) or list(list(dir = "DESC", field = "\[Name\]"))
#' 
#' @export
addSort <- function(x, sort) {
  checkSortList(sort)
  if (!is.null(x$step$sort)) {
    stop("It is not possible to add more than one sorting column at the moment with addSort().")
    # newSort <- x$step$sort
    # invisible(lapply(sort, function(y) {
    #   newSort[[length(newSort)+1]] <<- y
    # }))
    # x$step <- newStep(x$step, sort = newSort)
  } else {
    x$step <- newStep(x$step, sort = sort)
  }
  x
}

addSelect <- function(.data, new_vars) {
  new_columns <- .data$step$columns[new_vars]
  names(new_columns) <- names(new_vars)
  new_vars[names(new_vars)] <- names(new_vars)

  newStep(.data$step, vars = new_vars, columns = new_columns)
}

#' Adjust the offset and limit of a remote records object
#'
#' @description
#' This adds a single sorted column to an ActivityInfo remote records object. 
#' Usually one would use the [dplyr::slice_head] or [dplyr::slice_tail] verbs 
#' instead.
#'
#' @param x the remote records object fetched with [activityinfo::getRecords].
#' @param offSet an integer. Default is 0L for no offset.
#' @param limit an integer. Optional.
#' 
#' @export
adjustWindow <- function(x, offSet = 0L, limit) {
  stopifnot(offSet>=0&&is.integer(offSet))
  if (is.null(x$step$window)) {
    oldWindow <- c(0L, as.integer(x$totalRecords))
  } else {
    oldWindow <- x$step$window
  }

  if(missing(limit)) {
    window <- c(oldWindow[1] + offSet, oldWindow[2])
    x$step <- newStep(x$step, window = window)
  } else {
    stopifnot(limit>=0)
    stopifnot(is.integer(limit))
    window <- c(oldWindow[1] + offSet, min(oldWindow[2], limit))
    x$step <- newStep(x$step, window = window)
  }
  x
}


#' Get the columns of a remote records object
#'
#' @description
#' This provides the columns of the remote records object created with [activityinfo::getRecords]
#'
#' @param x the remote records object fetched with [activityinfo::getRecords].
#' 
#' @export
tblColumns <- function(x) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  columns <- x$step$columns
  columns[x$step$vars]
}

tblNames <- function(x) {
  x$step$vars
}

tblFieldTypes <- function(x) {
  columns <- tblColumns(x)
  types <- unlist(lapply(columns, function(y) {
    type <- class(x$elements[[y]])[1]
    type <- sub("^activityInfo([a-zA-Z0-9]+)FieldSchema$", "\\1", type)
    type
  }))
  types[types!="NULL"]
}

#' Get the sort ActivityInfo API object of a remote records object
#'
#' @description
#' This provides the sort object used in [activityinfo::queryTable] of the remote records object created with [activityinfo::getRecords]
#'
#' @param x the remote records object fetched with [activityinfo::getRecords].
#' 
#' @export
tblSort <- function(x) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  x$step$sort
}

#' Get the filter object of a remote records object
#'
#' @description
#' This provides the columns used in [activityinfo::queryTable] of the remote records object created with [activityinfo::getRecords]
#'
#' @param x the remote records object fetched with [activityinfo::getRecords].
#' 
#' @export
tblFilter <- function(x) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  step <- x$step
  combinedFilter <- character()

  repeat{
    combinedFilter <- c(step$filter, combinedFilter)
    if(!exists("parent", where = x)){
      break
    }
    step <- step$parent
  }

  if (length(combinedFilter)>0) {
    return(paste0("(", combinedFilter, ")", collapse = "&&"))
  } else {
    NULL
  }
}

#' Get the window object of a remote records object
#'
#' @description
#' This provides the window used in [activityinfo::queryTable] of the remote records object created with [activityinfo::getRecords]
#'
#' @param x the remote records object fetched with [activityinfo::getRecords].
#' @param limit an additional limit that can be used to specify the maximum number of records to query.
#' 
#' @export
tblWindow <- function(x, limit) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  window <- x$step$window
  if (!missing(limit)) {
    if (is.null(window)) {
      window <- c(0L, as.integer(x$totalRecords))
    }
    window[2] <- min(window[2], limit)
  }
  window
}

#' Create a new form schema copied from each form field represented in a remote 
#' records object
#'
#' @description
#' This function is useful for creating new forms based on existing forms and 
#' may be used to copy only the fields in a single form or any combination of 
#' fields in a form tree that can be fetched with [activityinfo::getRecords]. 
#' Note some form elements such as section headers will not be represented.
#'
#' @param x the remote records object fetched with [activityinfo::getRecords].
#' @param databaseId the id of the database where the form should reside.
#' @param label the label of the form
#' @param useColumnNames change the label of each field to the corresponding column name in the remote records object
#' @param ... parameters to pass on to [activityinfo::formSchema]
#' @export
extractSchemaFromFields <- function(x, databaseId, label, useColumnNames = FALSE, ...) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  fmSchema <- formSchema(databaseId = databaseId, label = label, ...)

  codes <- character(0)
  
  lapply(names(x$step$columns), function(colName) {
    y <- x$elements[[x$step$columns[colName]]]
    if(!is.null(y)) {
      y$id <- cuid()
      if (is.null(y$code)) {
        codes[length(codes)+1] <<- NA
      } else {
        if (y$code %in% codes) {
          codes[length(codes)+1] <<- y$code
          codes[!is.na(codes)] <<- gsub("([.])", "_", make.names(codes[!is.na(codes)], unique = TRUE))
          warning("Recoding duplicate code in form field '", y$label,"': '",y$code,"' to '", codes[length(codes)], "'")
          y$code <- codes[length(codes)]
        } else {
          codes[length(codes)+1] <<- y$code
        }
      }
      if (useColumnNames) {
        y$label <- colName
      }
      fmSchema <<- addFormField(fmSchema, y)
    }
  })
  
  if (length(fmSchema$elements)==0) {
    warning(sprintf("No form schema columns available. An empty schema will be provided for form with id %s.", fmSchema$id))
  } else {
    checkForm(fmSchema, warnDuplicateLabels = TRUE)
  }

  fmSchema
}

# ---- Lazy steps ----

firstStep <- function(
    formTree,
    style,
    totalRecords = 256,
    vars = varNames(formTree, style = style, addNames = TRUE),
    columns = styledColumns(
      formTree,
      style = style,
      forceId = TRUE)
    ) {
  step <- list(
    "vars" = vars,
    "columns" = columns,
    "filter" = NULL,
    "sort" = NULL,
    "window" = NULL,
    "requiredVars" = NULL)
  class(step) <- c("activityInfoStep")
  step
}

newStep <- function(parent, vars = parent$vars, columns = parent$columns, filter = parent$filter, sort = parent$sort, window = parent$window) {
  stopifnot(inherits(parent, "activityInfoStep"))
  step <- list(
    "parent" = parent,
    "vars" = vars,
    "columns" = columns,
    "filter" = filter,
    "sort" = sort,
    "window" = window,
    "requiredVars" = NULL)
  class(step) <- c("activityInfoStep")
  step
}

# ---- Table formatting ----

tblLabel <- function(x) {
  x$formTree$forms[[x$formTree$root]]$label
}

#' @importFrom pillar tbl_format_header style_subtle align
#' @export
tbl_format_header.tbl_activityInfoRemoteRecords <- function(x, setup, ...) {
  # The setup object may know the total number of rows

  window <- tblWindow(x)
  columns <- tblColumns(x)
  
  named_header <- list(
    "Form (id)" = sprintf("%s (%s)", tblLabel(x), x$formTree$root),
    "Total form records" = x$totalRecords,
    "Last edit time" = format(as.POSIXct(x$lastEditTime, origin = "1970-01-01", tz = "UTC"), "%Y-%m-%d %H:%M:%S"),
    "Table fields types" = tblFieldTypes(x),
    "Table filter" = tblFilter(x),
    "Table sort" = tblSort(x),
    "Table Window" = if (is.null(window)) "No offset or limit" else sprintf("offSet: %d; Limit: %d", window[1], window[2])
  )

  # Adapted from pillar
  header <- paste0(
    align(paste0(names(named_header), ":")),
    " ",
    named_header
  )

  style_subtle(paste0("# ", header))
}

#' @importFrom tibble tbl_sum
#' @export
tbl_sum.tbl_activityInfoRemoteRecords <- function(x, ...) {
  c("ActivityInfo Remote Records" = tblLabel(x), NextMethod())
}


#' @export
tbl_sum.activityInfo_tbl_df <- function(x, ...) {
  c("ActivityInfo tibble" = sprintf("Remote form: %s (%s)",tblLabel(attr(x, "remoteRecords")), attr(x, "remoteRecords")$formTree$root), NextMethod())
}

# select.tbl_activityInfoRemoteRecords <- function(x) {
#
# }

# ---- Source ----


src_activityInfo <- function(x) {
  UseMethod("src_activityInfo")
}
#' @exportS3Method src_activityInfo formTree
src_activityInfo.formTree <- function(x) {
  dplyr::src(subclass = c("activityInfoFormTree", "activityInfo"), formTree = x, url <- activityInfoRootUrl())
}
#' @exportS3Method src_activityInfo databaseTree
src_activityInfo.databaseTree <- function(x) {
  dplyr::src(subclass = c("activityInfoDatabaseTree", "activityInfo"), databaseTree = x, url <- activityInfoRootUrl())
}

#' @importFrom dplyr src_tbls
#' @exportS3Method src_tbls src_activityInfoFormTree
src_tbls.src_activityInfoFormTree <- function(x, ...) {
  names(x$formTree$forms)
}

#' @exportS3Method src_tbls src_activityInfoDatabaseTree
src_tbls.src_activityInfoDatabaseTree <- function(x, ...) {
  getDatabaseResources(x)$id
}

# ---- Dplyr Verbs ----

warn_collect <- function(fn, warningMessage = sprintf("Collecting data for function %s()", fn)) {
  warning(warningMessage)
}

#' @export
#' @importFrom dplyr group_by
group_by.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_by")
  .data <- collect(.data)
  group_by(.data, ...)
}

#' @exportS3Method group_vars tbl_activityInfoRemoteRecords
#' @importFrom dplyr group_vars
group_vars.tbl_activityInfoRemoteRecords <- function(x) {
  character(0)
}

#' @export
#' @importFrom dplyr summarise
summarise.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("summarise")
  .data <- collect(.data)
  summarise(.data, ...)
}

#' @export
#' @importFrom dplyr mutate
mutate.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("mutate")
  .data <- collect(.data)
  mutate(.data, ...)
}


#' @exportS3Method filter tbl_activityInfoRemoteRecords
#' @importFrom dplyr filter
filter.tbl_activityInfoRemoteRecords <- function(.data, ...) {

  if (!is.null(tblWindow(.data))) {
    # should collect if window has already been applied  
    warn_collect("filter", "Collecting data for dplyr::filter() as dplyr::slice_*() window functions have already been applied.")
    .data <- collect(.data)
    filter(.data, ...)
  } else {
    exprs <- rlang::enquos(...)

    tryCatch({
      result <- lapply(exprs, function(x) {
        toActivityInfoFormula(.data, !!x)
        })
      addFilter(.data, paste(as.character(result, collapse = "&&")))
      },
      error = function(e) {
        warn_collect("filter", "Could not convert r expression to an ActivityInfo formula so collecting data for dplyr::filter().")
        .data <- collect(.data)
        filter(.data, ...)
      })
  }
}

#' @export
dplyr::filter

#' @export
#' @importFrom dplyr collect
collect.tbl_activityInfoRemoteRecords <- function(x, ...) {
  newTbl <- queryTable(
    x$formTree,
    columns = tblColumns(x),
    asTibble = TRUE,
    makeNames = FALSE,
    filter = tblFilter(x),
    sort = tblSort(x),
    window = tblWindow(x)
  )
  class(newTbl) <- c("activityInfo_tbl_df", class(newTbl))
  attr(x = newTbl, which = "remoteRecords") <- x
  newTbl
}

#' @export
dplyr::collect

# can implement predicate function and create a function factory for the field types
# need to change this to use the columns and adjust the var names
#' @importFrom dplyr select
#' @importFrom tidyselect eval_select
#' @importFrom rlang set_names
#' @export
select.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  if (!is.null(tblFilter(.data))||!is.null(tblSort(.data))) warning("Using select() after a filter or sort step. Be careful not to remove a required variable from your selection.")

  loc <- tidyselect::eval_select(rlang::expr(c(...)), .data)

  new_vars <- set_names(colnames(.data)[loc], names(loc))

  .data$step <- addSelect(.data, new_vars)
  .data
}

#' @importFrom dplyr rename
#' @export
rename.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  if (!is.null(tblSort(.data))) warning("Using rename() after a sort/dplyr::arrange() step. Be careful not to rename a required variable from your selection or collect() the data first.")

  loc <- tidyselect::eval_select(rlang::expr(c(...)), .data)

  new_vars <- rlang::set_names(colnames(.data), colnames(.data))
  names(new_vars)[loc] <- names(loc)

  .data$step <- addSelect(.data, new_vars)
  .data
}

#' @importFrom dplyr rename_with
#' @importFrom tidyselect everything
#' @inheritParams dplyr::rename_with
#' @export
rename_with.tbl_lazy <- function(.data, .fn, .cols = everything(), ...) {
  if (!is.null(tblSort(.data))) warning("Using rename_with() after a sort/dplyr::arrange() step. Be careful not to rename a required variable from your selection or collect() the data first.")

  .fn <- rlang::as_function(.fn)
  cols <- tidyselect::eval_select(rlang::enquo(.cols), .data)

  new_vars <- set_names(colnames(.data))
  names(new_vars)[cols] <- .fn(new_vars[cols], ...)

  .data$step <- addSelect(.data, new_vars)
  .data
}


#' @importFrom dplyr slice_head
#' @export
slice_head.tbl_activityInfoRemoteRecords <- function(.data, ..., n, prop) {
  if (missing(n)) {
    if (missing(prop)) stop("slice_head() must either be provide the number of rows n or prop.")
    stopifnot(prop>=0&&prop<=1)
    n <- prop * .data$totalRecords
  }
  head(.data, n = n)
}

#' @importFrom dplyr slice_tail
#' @export
slice_tail.tbl_activityInfoRemoteRecords <- function(.data, ..., n, prop) {
  if (missing(n)) {
    if (missing(prop)) stop("slice_tail() must either be provide the number of rows n or prop.")
    stopifnot(prop>=0&&prop<=1)
    n <- prop * .data$totalRecords
  }
  tail(.data, n = n)
}

#' @export
#' @importFrom dplyr arrange
arrange.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  exprs <- rlang::enquos(...)
  if (!is.null(tblWindow(.data))) {
    # should collect if window has already been applied
    warn_collect("arrange", "Collecting data for dplyr::arrange() as dplyr::slice_head/tail() window functions have already been applied.")
    .data <- collect(.data)
    filter(.data, ...)
  }
  if (length(exprs)>1||!is.null(tblSort(.data))) {
    # should collect if sorting more than one column
    warn_collect("arrange", "Collecting data for dplyr::arrange() to sort more than one column.")
    .data <- collect(.data)
    arrange(.data, ...)
  } else {
    expr2 <- rlang::quo_get_expr(exprs[[1]])
    if (is.symbol(expr2)) {
      chexpr <- rlang::as_name(expr2)
      if (chexpr %in% tblNames(.data)) {
        return(addSort(x = .data, sort = list(list(dir = "ASC", field = chexpr))))
      }
    } else if (is.call(expr2)) {
      fn <- as.character(expr2[[1]])
      if (fn == "desc") {
        chexpr <- as.character(expr2[[2]])
        if (chexpr %in% tblNames(.data)) {
          return(addSort(x = .data, sort = list(list(dir = "DESC", field = chexpr))))
        }
      }
    }
    warn_collect("arrange")
    .data <- collect(.data)
    arrange(.data, ...)
  }
}

#### Automatic dplyr verb collection ####

#' @importFrom utils lsf.str
additionalDplyrVerbs <- function() {
  result <- lapply(
    paste0("dplyr::`",utils::lsf.str("package:dplyr"),"`"), 
    function(x) {
      fn <- eval(parse(text = x))
      fn_name <- substr(x, 9, nchar(x)-1)
      if (!is.null(formals(fn))&&names(formals(fn))[[1]]==".data"&&!(fn_name %in% paste0(utils::lsf.str("package:activityinfo")))) {
        fn_text <- sprintf(
          "#' @importFrom dplyr %s\n#' @exportS3Method %s tbl_activityInfoRemoteRecords\n%s.tbl_activityInfoRemoteRecords <- function(.data, ...) {\n  warn_collect(\"%s\")\n  .data <- collect(.data)\n  %s(.data, ...)\n}", 
          fn_name,
          fn_name, 
          fn_name, 
          fn_name, 
          fn_name
        )
        return(fn_text)
      }
      return(NULL)
    }
  )
  paste(result[lengths(result)>0], collapse = "\n\n")
}


#' @importFrom dplyr add_row
#' @exportS3Method add_row tbl_activityInfoRemoteRecords
add_row.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("add_row")
  .data <- collect(.data)
  add_row(.data, ...)
}

#' @export
#' @importFrom dplyr arrange_
arrange_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("arrange_")
  .data <- collect(.data)
  arrange_(.data, ...)
}

#' @export
#' @importFrom dplyr distinct
distinct.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("distinct")
  .data <- collect(.data)
  distinct(.data, ...)
}

#' @export
#' @importFrom dplyr distinct_
distinct_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("distinct_")
  .data <- collect(.data)
  distinct_(.data, ...)
}

#' @importFrom dplyr distinct_prepare
#' @exportS3Method distinct_prepare tbl_activityInfoRemoteRecords
distinct_prepare.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("distinct_prepare")
  .data <- collect(.data)
  distinct_prepare(.data, ...)
}

#' @export
#' @importFrom dplyr do
do.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("do")
  .data <- collect(.data)
  do(.data, ...)
}

#' @export
#' @importFrom dplyr do_
do_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("do_")
  .data <- collect(.data)
  do_(.data, ...)
}

#' @export
#' @importFrom dplyr filter_
filter_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("filter_")
  .data <- collect(.data)
  filter_(.data, ...)
}

#' @export
#' @importFrom dplyr group_by_
group_by_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_by_")
  .data <- collect(.data)
  group_by_(.data, ...)
}

#' @importFrom dplyr group_by_prepare
#' @exportS3Method group_by_prepare tbl_activityInfoRemoteRecords
group_by_prepare.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_by_prepare")
  .data <- collect(.data)
  group_by_prepare(.data, ...)
}

#' @export
#' @importFrom dplyr group_data
group_data.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_data")
  .data <- collect(.data)
  group_data(.data, ...)
}

#' @export
#' @importFrom dplyr group_indices
group_indices.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_indices")
  .data <- collect(.data)
  group_indices(.data, ...)
}

#' @export
#' @importFrom dplyr group_indices_
group_indices_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_indices_")
  .data <- collect(.data)
  group_indices_(.data, ...)
}

#' @export
#' @importFrom dplyr group_map
group_map.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_map")
  .data <- collect(.data)
  group_map(.data, ...)
}

#' @export
#' @importFrom dplyr group_modify
group_modify.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_modify")
  .data <- collect(.data)
  group_modify(.data, ...)
}

#' @importFrom dplyr group_rows
#' @exportS3Method group_rows tbl_activityInfoRemoteRecords
group_rows.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_rows")
  .data <- collect(.data)
  group_rows(.data, ...)
}

#' @importFrom dplyr group_walk
#' @exportS3Method group_walk tbl_activityInfoRemoteRecords
group_walk.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("group_walk")
  .data <- collect(.data)
  group_walk(.data, ...)
}

#' @export
#' @importFrom dplyr mutate_
mutate_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("mutate_")
  .data <- collect(.data)
  mutate_(.data, ...)
}

#' @export
#' @importFrom dplyr nest_by
nest_by.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("nest_by")
  .data <- collect(.data)
  nest_by(.data, ...)
}

#' @export
#' @importFrom dplyr pull
pull.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("pull")
  .data <- collect(.data)
  pull(.data, ...)
}

#' @export
#' @importFrom dplyr reframe
reframe.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("reframe")
  .data <- collect(.data)
  reframe(.data, ...)
}

#' @export
#' @importFrom dplyr relocate
relocate.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("relocate")
  .data <- collect(.data)
  relocate(.data, ...)
}

#' @export
#' @importFrom dplyr rename_
rename_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("rename_")
  .data <- collect(.data)
  rename_(.data, ...)
}

#' @export
#' @importFrom dplyr select_
select_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("select_")
  .data <- collect(.data)
  select_(.data, ...)
}

#' @export
#' @importFrom dplyr slice_
slice_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("slice_")
  .data <- collect(.data)
  slice_(.data, ...)
}

# this can be implemented by allowing the recordIds to be downloaded on demand
#' @importFrom dplyr slice
#' @export
slice.tbl_activityInfoRemoteRecords <- function(...) {
  warn_collect("slice")
  .data <- collect(.data)
  slice(.data, ...)
}

#' @importFrom dplyr slice_min
#' @export
slice_min.tbl_activityInfoRemoteRecords <- function(...) {
  warn_collect("slice_min")
  .data <- collect(.data)
  slice_min(.data, ...)
}

#' @importFrom dplyr slice_max
#' @export
slice_max.tbl_activityInfoRemoteRecords <- function(...) {
  warn_collect("slice_max")
  .data <- collect(.data)
  slice_max(.data, ...)
}

#' @importFrom dplyr slice_sample
#' @export
slice_sample.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("slice_sample")
  .data <- collect(.data)
  slice_sample(.data, ...)
}


#' @export
#' @importFrom dplyr summarise_
summarise_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("summarise_")
  .data <- collect(.data)
  summarise_(.data, ...)
}

#' @export
#' @importFrom dplyr summarize
summarize.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("summarize")
  .data <- collect(.data)
  summarize(.data, ...)
}

#' @export
#' @importFrom dplyr summarize_
summarize_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("summarize_")
  .data <- collect(.data)
  summarize_(.data, ...)
}

#' @export
#' @importFrom dplyr tbl_ptype
tbl_ptype.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("tbl_ptype")
  .data <- collect(.data)
  tbl_ptype(.data, ...)
}

#' @export
#' @importFrom dplyr transmute
transmute.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("transmute")
  .data <- collect(.data)
  transmute(.data, ...)
}

#' @export
#' @importFrom dplyr transmute_
transmute_.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("transmute_")
  .data <- collect(.data)
  transmute_(.data, ...)
}


#' @importFrom dplyr with_groups
#' @exportS3Method with_groups tbl_activityInfoRemoteRecords
with_groups.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("with_groups")
  .data <- collect(.data)
  with_groups(.data, ...)
}



# ---- Utils ----

#' @importFrom utils head
#' @export
head.tbl_activityInfoRemoteRecords <- function(x, n = 6L, ...) {
  n <- as.integer(n)
  adjustWindow(x, offSet = 0L, limit = n)
}

#' @importFrom utils tail
#' @export
tail.tbl_activityInfoRemoteRecords <- function(x, n = 6L, ...) {
  n <- as.integer(n)
  adjustWindow(x, offSet = max(0L, x$step$window[2] - n), limit = n)

}

# ---- Base ----

#' @export
as.data.frame.tbl_activityInfoRemoteRecords <- function(x, ...) {
  as.data.frame(collect(x))
}