

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


changeName <- function(x, from, to) {
  if (is.null(names(x))) return(x)

  stopifnot(is.character(from))
  stopifnot(is.character(to))

  name.index <- which(names(x) == from)

  # rename first occurrence of 'from' name:
  if (length(name.index) > 0) names(x)[name.index[1]] <- to[1]

  x
}

#' Queries the schema of a form
#' 
#' The result has a class "formSchema" and can be transformed to 
#' data.frame using `as.data.frame()`
#' 
#'
#' @param formId the form identifier
#' @examples \dontrun{
#' formSchema <- getFormSchema("ck2lt9wp3g")
#' formSchemaTable <- as.data.frame(getFormSchema("ck2lt9wp3g"))
#' }
#' @return A list with class \sQuote{formSchema}.
#' @export
getFormSchema <- function(formId) {
  stopifnot(is.character(formId))
  schema <- getResource(sprintf("form/%s/schema", formId))
  
  as.schema(schema)
}

# Enforce some types to make other 
# operations easier
as.schema <- function(schema) {
  schema$elements <- lapply(schema$elements, function(e) {
    e$key <- identical(e$key, TRUE)
    e$required <- identical(e$required, TRUE)
    class(e) <- "formField"
    e
  })
  class(schema) <- "formSchema"
  schema  
}

#' Pretty print a form schema
#'
#' @param x an object of class \code{formSchema}.
#' @param ... ignored
#' @export
print.formSchema <- function(x, ...) {
  schema <- x
  cat("Form Schema Object\n")
  cat(sprintf("  id:           %s\n", schema$id))
  cat(sprintf("  label:        %s\n", schema$label))
  cat(sprintf("  databaseId:   %s\n", schema$databaseId))
  if(!is.null(schema$parentFormId)) {
    cat(sprintf("  parentFormId: %s\n", schema$parentFormId))
  }
  cat(sprintf("  elements: %d\n", length(schema$elements)))
  
  for(field in schema$elements) {
    cat(sprintf("    %s: %s\n", field$id, field$label))
    attrs <- c( 
        if(field$key) "Key" else NULL,
        if(field$required) "Required" else NULL)
    
    if(length(attrs)) {
      cat(sprintf("      %s\n", paste(attrs, collapse = ", ")))
    }
              
    if(is.character(field$description)) {
      cat(sprintf("      description: %s\n", field$description))
    }
    cat(sprintf("      type: %s\n", field$type))
  }
}


#' Flatten form schema to a table
#'
#' @param x an object of class \emph{formSchema} as returned by \code{\link{getFormSchema}}.
#' @param row.names NULL or a character vector giving the row names for the data frame. Missing values are not allowed.
#' @param optional logical, if \code{TRUE} then converting column names is optional.
#' @param ... additional arguments passed on to \code{\link{as.data.frame}}.
#' @details Note that if \code{stringsAsFactors} is not explicitly set to \code{TRUE}, then this method uses
#' \code{FALSE} as a default, not \code{default.stringsAsFactors()}.
#' @export
as.data.frame.formSchema <- function(x, row.names = NULL, optional = FALSE, ...) {

  nfields <- length(x$elements)
  null2na <- function(y) if(is.null(y) || !nzchar(y)) NA else y
  
  data.frame(
    row.names = row.names,
    databaseId = rep.int(x$databaseId, nfields),
    formId = rep.int(x$id, nfields),
    formLabel = rep.int(x$label, nfields),
    formParentId = rep.int(null2na(x$parentFormId), nfields),
    fieldId = sapply(x$elements, function(e) e$id),
    fieldCode = sapply(x$elements, function(e) null2na(e$code)),
    fieldType = sapply(x$elements, function(e) null2na(e$type)),
    fieldLabel = sapply(x$elements, function(e) null2na(e$label)),
    fieldDescription = sapply(x$elements, function(e) null2na(e$description)),
    validationCondition = sapply(x$elements, function(e) null2na(e$validationCondition)),
    relevanceCondition = sapply(x$elements, function(e) null2na(e$relevanceCondition)),
    fieldRequired = sapply(x$elements, function(e) null2na(e$required)),
    key = sapply(x$elements, function(e) identical(e$key, TRUE)),
    referenceFormId = sapply(x$elements, function(e) null2na(e$typeParameters$range[[1]]$formId)),
    formula = sapply(x$elements, function(e) null2na(e$typeParameters$formula)),
    dataEntryVisible = sapply(x$elements, function(e) !identical(e$dataEntryVisible, FALSE)),
    tableVisible = sapply(x$elements, function(e) !identical(e$tableVisible, FALSE)),
    stringsAsFactors = FALSE)
}

#' Adds a new form to a database
#' @param databaseId the id of the database 
#' @param schema the schema of the form to add
#' @param folderId the id of the folder to which this form should be added  
#' @export
addForm <- function(databaseId, schema, folderId = databaseId) {
  
  schema$databaseId <- databaseId
  
  request <- list(
    formResource = list(id = schema$id,
                        parentId = databaseId,
                        type = "FORM",
                        label = schema$label,
                        visibility = "PRIVATE"),
    formClass = schema)
  
  postResource(
    sprintf("databases/%s/forms", databaseId), 
    request, 
    task = sprintf("Adding a new form '%s' with id %s in database %s", schema$label, schema$id, databaseId))
  
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

  result <- postResource(
    sprintf("form/%s/schema", schema$id),
    body = schema, 
    task = sprintf("Update of form schema for form %s (%s)", schema$label, schema$id), 
    requireStatus = 200)
  
  result
}

#' Queries the Form Tree of a Form
#'
#' @param formId the form identifier
#' @return A list with class \sQuote{formTree}.
#' @export
getFormTree <- function(formId) {
  stopifnot(is.character(formId))
  tree <- getResource(paste("form", formId, "tree", sep = "/"))

  # enforce some types to make other operations easier:
  tree$forms <- lapply(tree$forms, function(form) {
	  schema <- form$schema
    schema$elements <- lapply(schema$elements, function(e) {
      e$key <- identical(e$key, TRUE)
      e$required <- identical(e$required, TRUE)
      class(e) <- "formField"
      e
    })

    class(schema) <- "formSchema"
    schema
  })

  class(tree) <- "formTree"
  tree
}

#' Relocating a form moves the form, together with all of its subforms,
#' records, and record history, to a new database.
#'
#' In order to relocate a form, the user must have "delete" permission in the
#' source database, and permission to add new forms in the target database.
#' 
#' @param formId the id of the form to move
#' @param databaseId the id of the database to which the form should be moved.
#' @export
relocateForm <- function(formId, newDatabaseId) {
  
  postResource(sprintf("/form/%s/database", formId),
                              body = list(databaseId = newDatabaseId))
  
}
