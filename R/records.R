


#' Updates a single record
#' 
#' @param fieldValues a named list of fields to change
#' @export
updateRecord <- function(formId, recordId, fieldValues) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))
  stopifnot(is.list(fieldValues))
  
  putResource(sprintf("form/%s/record/%s", formId, recordId), list(
    fieldValues = fieldValues
  ))
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

