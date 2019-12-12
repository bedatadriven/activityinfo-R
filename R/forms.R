

legacy <- function(domain, id) {
  stopifnot(nchar(domain) == 1)
  stopifnot(is.numeric(id))

  sprintf("%s%010d", domain, id)
}

#' Returns the id of the form containing the sites
#' associated with a 'classic' activity
site.form.id <- function(activityId) legacy("a", activityId)


#' Returns the id of the form containing the monthly reports
#' associated with a 'classic' activity
monthly.reports.form.id <- function(activityId) legacy("M", activityId)

admin.level.form.id <- function(adminLevelId) legacy("E", adminLevelId)

#' Returns the name of the field containing the value of a 'classic' attribute group
attribute.field.name <- function(attributeGroupId) legacy("Q", attributeGroupId)

#' Returns the name of the field containing the value of a 'classic' indicator
indicator.field.name <- function(indicatorId) legacy("i", indicatorId)


extractOldId <- function(s) {
  if (all(grepl("^[[:alpha:]]0*", s))) {
    as.integer(sub("^[[:alpha:]]0*", "", s))
  } else {
    s
  }
}

#' Queries the schema of a form
#'
#' @param formId formId
#' @examples \dontrun{
#' getFormSchema("ck2lt9wp3g")
#' }
#' @export
getFormSchema <- function(formId) {
  stopifnot(is.character(formId))
  getResource(sprintf("form/%s/schema", formId))
}

#' Updates a form schema
#'
#' @param schema a form schema
#' @export
updateFormSchema <- function(schema) {

  # Touch up structure to avoid problems with toJson
  schema$elements <- lapply(schema$elements, function(x) {
    n <- sapply(x, length)
    x <- x[ n!= 0 ]
    x
  })

  url <- sprintf("%s/resources/form/%s/schema", activityInfoRootUrl(), schema$id)

  result <- POST(url, body = schema, encode = "json",  activityInfoAuthentication(), accept_json())

  if (result$status_code != 200) {
    stop(sprintf("Update of form schema failed with status code %d %s: %s",
                 result$status_code,
                 http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  }
}

#' Queries the Form Tree of a Form
#'
#' @export
#' @param the formId
getFormTree <- function(formId) {
  stopifnot(is.character(formId))
  getResource(paste("form", formId, "tree", sep = "/"))
}
