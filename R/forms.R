

cuid <- function(domain, id) {
  stopifnot(nchar(domain) == 1)
  stopifnot(is.numeric(id))
  
  sprintf("%s%010d", domain, id)
}

#' Returns the id of the form containing the sites
#' associated with a 'classic' activity
site.form.id <- function(activityId) cuid("a", activityId)


#' Returns the id of the form containing the monthly reports
#' associated with a 'classic' activity
monthly.reports.form.id <- function(activityId) cuid("M", activityId)

admin.level.form.id <- function(adminLevelId) cuid("E", adminLevelId)

#' Returns the name of the field containing the value of a 'classic' attribute group
attribute.field.name <- function(attributeGroupId) cuid("Q", attributeGroupId)

#' Returns the name of the field containing the value of a 'classic' indicator
indicator.field.name <- function(indicatorId) cuid("i", indicatorId)


extractOldId <- function(s) {
  if (all(grepl("^[[:alpha:]]0*", s))) {
    as.integer(sub("^[[:alpha:]]0*", "", s))
  } else {
    s
  }
}

#' Queries the schema of a form
#' 
#' @export
#' @param the formId
getFormSchema <- function(formId) {
  stopifnot(is.character(formId))
  getResource(sprintf("form/%s/schema", formId))
}
