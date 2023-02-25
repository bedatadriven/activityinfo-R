
#' Updates a single record
#'
#' @param formId a form id
#' @param recordId a record id
#' @param fieldValues a named list of fields to change
#' @export
updateRecord <- function(formId, recordId, fieldValues) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))
  stopifnot(is.list(fieldValues))

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

#' Adds a new record
#'
#' @param formId the id of the form to which the record should be added
#' @param parentRecordId the id of this record's parent record, if the form is a subform
#' @param fieldValues a named list of fields to change
#' @export
addRecord <- function(formId, parentRecordId = NA_character_, fieldValues) {
  stopifnot(is.character(formId))
  stopifnot(is.character(parentRecordId))
  stopifnot(is.list(fieldValues))

  changes <- list(
    list(
      formId = formId,
      recordId = cuid(),
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
#' who are
#'
#' @param formId a form id
#' @param recordId a record id
#' @export
getRecordHistory <- function(formId, recordId) {
  getResource(
    paste("form", formId, "record", recordId, "history", sep = "/"),
    task = sprintf("Get record %s history from form %s", recordId, formId)
    )
}

#' Gets a single record
#'
#' @param formId a form id
#' @param recordId the record Id
#' @export
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
recoverRecord <- function(formId, recordId) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))

  path<-sprintf("form/%s/record/%s/recover",formId,recordId)
  postResource(path = path, NULL, task = sprintf("Recover record %s from form %s", recordId, formId))
}


# ---- Get records ----

#' Get a table of records
#'
#' @description
#' This function will create a reference to records on the server. You can use this like a data.frame or to download the table use the collect() function.
#'
#' @param formId a form id
#' @param recordId a record id
#' @export
getRecords <- function() {
  UseMethod("getRecords")
}

getRecords.character <- function(formId) {
  getFormSchema(formId)
}

getRecords.activityInfoFormSchema <- function(form){
  src <- form$databaseId
  firstStep(form)
}
getRecords.default <- getRecords.character

# ---- Functions to get correct column references ----

# naming can be "id", "label", c("code", "label") or c("code", "id")
columnVarStyle <- function(x) {
  getOption("activityInfoColumnVarStyle", default = list(
    referencedId = TRUE,
    referencedKey = TRUE,
    columnNames = c("code", "label")
  ))
}


#' @export
dimnames.activityInfoFormTree <- function(x) {
  style <- attr(x, "style")
  if (is.null(style)) style <- columnVarStyle()
  
  list(
    NULL,
    varNames(x, style)
  )
}

#' @export
dimnames.activityInfoFormSchema <- dimnames.activityInfoFormTree
dimnames.activityInfoRemoteRecords <- dimnames.activityInfoFormSchema

elementVarName <- function(y, style) {
  colNameStyle <- style$columnNames[[1]]

  if(colNameStyle == "code") {
    message("Getting code")
    colName <- y[["code"]]
    if(is.null(colName)) {
      message("No code")
      if (length(style$columnNames)>1&&style$columnNames[[2]] %in% c("label", "id")) {
        colNameStyle <- style$columnNames[[2]]
      } else {
        colNameStyle <- "id"
      }
    }
  }
  
  message("colNameStyle = ", colNameStyle)
  
  # need to add escaping of labels
  if(colNameStyle == "label") {
    message("Checking label for name")
    if(nchar(y[["label"]])>20) {
      colNameStyle <- "id"
    } else {
      colName <- sprintf("[%s]", y[["label"]])
    }
  } 
  
  if (colNameStyle == "id") {
    message("Checking id for name")
    colName <- y[["id"]]
  }
  
  colName
}

#' @export
varNames <- function(x, style) {
  UseMethod("varNames")
}
#' @export
varNames.activityInfoFormTree <- function(x, style) {
  fmSchema <- x$forms[[x$root]]
  
  unlist(lapply(fmSchema$elements, function(y) {

    message("Checking name for ", y$label)
    
    colName <- NULL
        
    if (inherits(y,"activityInfoReferenceFieldSchema")) {
      message("Checking reference field name")
      
      if (style$referencedId) colName <- elementVarName(y, style)
      
      if (style$referencedKey){
        refId <- y$typeParameters$range[[1]]$formId
        refFormSchema <- x$forms[[refId]]
        refFormSchemaKey <- lapply(refFormSchema$elements, function(z) {
          message("Checking reference table field name: ", z$label)
          
          if (z$key) {
            message("Returning references key field: ", z$label)
            z
          } else {
            NULL
          }
        })
        refFormSchemaKey <- refFormSchemaKey[lengths(refFormSchemaKey)!=0]
        c(colName, unlist(lapply(refFormSchemaKey, function(z) {
          paste0(refId, ".", elementVarName(z, style))
        })))
      }

    } else {
      colName <- elementVarName(y, style)
    }
    
    colName

  }))
}
#' @export
varNames.activityInfoFormSchema <- function(x, style) {
  varNames(getFormTree(x$id), style)
}
varNames.activityInfoRemoteRecords <- function(x, style) {
  
}

#elementToVarName(style)



# ---- Lazy remote table ----

# #' @export
# dplyr::tbl
#' @export
tbl.src_activityInfoFormTree <- function(src, id, style, ...) {
  stopifnot(id %in% src_tbls(src))
  
  rootForm <- src$formTree$forms[[src$formTree$root]]
  
  vars <- unlist(lapply(rootForm$elements, function(x) {elementToVar()}))

  dplyr::make_tbl(
    c("activityInfoRemoteRecords", "lazy"),
    src = src,
    step = firstStep(src, id, vars)
  )

}


# ---- Lazy steps ----

firstStep <- function(src, id, vars) {

  newStep(parent,
          vars = names(parent)
          )
}

formVars <- function(form) {
  if(!missing(form)&&inherits(form, "activityInfoFormSchema")) {

  }
}

newStep <- function(parent, vars = parent$vars) {
  stopifnot(inherits(parent, "activityInfoRemoteRecords"))
  
}

# ---- Source ----

src_activityInfo <- function(x) {
  UseMethod("src_activityInfo")
}
src_activityInfo.formTree <- function(formTree) {
  dplyr::src(subclass = c("activityInfoFormTree", "activityInfo"), formTree = formTree)
}
src_activityInfo.databaseTree <- function(dbTree) {
  dplyr::src(subclass = c("activityInfoDatabaseTree", "activityInfo"), databaseTree = dbTree)
}

# #' @export
# dplyr::src_tbls

#' @export
src_tbls.src_activityInfoFormTree <- function(x, ...) {
  names(x$formTree$forms)
}
#' @export
src_tbls.src_activityInfoDatabaseTree <- function(x, ...) {
  getDatabaseResources(dbTree)$id
}

# ---- Verbs ----

select.activityInfoRemoteRecords <- function() {
  stop("Please first use collect() to download the table. select() is not yet implemented for records on the server.")
}

