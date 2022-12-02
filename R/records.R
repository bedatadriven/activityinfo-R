
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

