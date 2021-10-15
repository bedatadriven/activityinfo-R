
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

  executeTransaction(list(
      list(
        formId = formId,
        recordId = recordId,
        fields = fieldValues
      )
    )
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

  executeTransaction(list(
    list(
      formId = formId,
      recordId = cuid(),
      parentRecordId = parentRecordId,
      fields = fieldValues
    )
  ))
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

  executeTransaction(changes = list(
    list(
      formId = formId,
      recordId = recordId,
      deleted = TRUE
    )
  ))
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
  getResource(paste("form", formId, "record", recordId, "history", sep = "/"))
}

#' Executes a record transaction
#'
#' @importFrom httr modify_url POST content message_for_status
#' @noRd
executeTransaction <- function(changes) {

  url <- modify_url(activityInfoRootUrl(), path = c("resources", "update"))

  result <- POST(url, body = list(changes = changes), encode = "json",  activityInfoAuthentication(), accept_json())

  if(result$status_code != 200) {
    stop(content(result, as = "text"))
  } else {
    message_for_status(result)
  }

  invisible(result)
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


