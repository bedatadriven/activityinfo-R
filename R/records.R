


#' Updates a single record
#' 
#' @param fieldValues a named list of fields to change
#' @export
updateRecord <- function(formId, recordId, fieldValues) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))
  stopifnot(is.list(fieldValues))
  
  txt <- list(
    changes = list(
      list(
        formId = formId,
        recordId = recordId,
        fields = fieldValues
      )
    )
  )
  
  url <- paste(activityInfoRootUrl(), "resources", "update", sep = "/")
  
  result <- POST(url, body = body, encode = "json",  activityInfoAuthentication(), accept_json())
  
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

