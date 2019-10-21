


#' Updates a single record
#' 
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
addRecord <- function(formId, parentRecordId, fieldValues) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))
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

#' Delete a single record
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

#' Executes a record transaction
#' 
executeTransaction <- function(changes) {
  
  url <- paste(activityInfoRootUrl(), "resources", "update", sep = "/")
  
  result <- POST(url, body = list(changes = changes), encode = "json",  activityInfoAuthentication(), accept_json())
  if(result$status_code == 400) {
    stop(content(result, as = "text"))
  }
  invisible(result)
}


#' Creates a 'reference' field value
#' 
#' @export
#' @param formId the id of the form
#' @param recordId the id of the record
reference <- function(formId, recordId) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))

  sprintf("%s:%s", formId, recordId)  
}


