

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
  
  # Enforce some types to make other 
  # operations easier
  schema$elements <- lapply(schema$elements, function(e) {
    e$key <- identical(e$key, TRUE)
    e$required <- identical(e$required, TRUE)
    class(e) <- "formField"
    e
  })
  class(schema) <- "formSchema"
  schema
}

#' @export
print.formSchema <- function(schema) {
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

#' Flatten form field to a table
#'
#' @param element a \code{formField} element as found in a form schema.
#' @param ... additional arguments passed on to \code{\link{data.frame}}.
#' @param stringsAsFactors should character vectors be converted to factors?
#' @export
as.data.frame.formField <- function(element, ..., stringsAsFactors = FALSE) {

  nulls <- sapply(element, is.null)
  element[nulls] <- NA_character_
  
  if(element$type == "reference") {
    element["referencedFormId"] <- element$typeParameters$range[[1]]$formId  
  } else {
    element["referencedFormId"] <- NA_character_
  }

  ## add 'key' if not exists:
  if (!"key" %in% names(element)) {
    element[["key"]] <- NA_character_
  }
  
  

  ## exclude typeParameters sub-list (if exists):
  if ("typeParameters" %in% names(element)) {
    element <- element[-which(names(element) == "typeParameters")]
  }

  data.frame(unclass(element), ..., stringsAsFactors = stringsAsFactors)
}

#' Flatten form schema to a table
#'
#' @param form.schema A list returned by \code{\link{getFormSchema}}.
#' @param ... additional arguments passed on to \code{\link{as.data.frame}}.
#' @param stringsAsFactors should character vectors be converted to factors?
#' @export
as.data.frame.formSchema <- function(form, ..., stringsAsFactors = FALSE) {

  ## pop elements list
  form.sans.elements <- form[-which(names(form) == "elements")]
  if (is.null(form.sans.elements[["parentFormId"]])) {
    form.sans.elements[["parentFormId"]] <- NA_character_
  }
  if (is.null(form.sans.elements[["subFormKind"]])) {
    form.sans.elements[["subFormKind"]] <- NA_character_
  }

  form.sans.elements <- changeName(form.sans.elements, from = "parentFormId", to = "formParentId")
  form.sans.elements <- changeName(form.sans.elements, from = "id", to = "formId")
  form.sans.elements <- changeName(form.sans.elements, from = "label", to = "formLabel")

  # convert each of the form fields to a data frame:
  elements <- do.call(rbind, lapply(form$elements, as.data.frame, stringsAsFactors = stringsAsFactors))

  elements <- changeName(elements, from = "id", to = "fieldId")
  elements <- changeName(elements, from = "label", to = "fieldLabel")
  elements <- changeName(elements, from = "code", to = "fieldCode")
  elements <- changeName(elements, from = "type", to = "fieldType")
  elements <- changeName(elements, from = "description", to = "fieldDescription")
  elements <- changeName(elements, from = "required", to = "fieldRequired")
  
  res <- cbind(
    as.data.frame(form.sans.elements, ..., stringsAsFactors = stringsAsFactors),
    elements
  )
  
  # remove columns:
  remove.cols <-
    c(
      "schemaVersion",
      "subFormKind",
      "relevanceCondition",
      "visible",
      "key"
    )
  res <- res[, setdiff(names(res), remove.cols)]

  # reorder columns:
  first.cols <- c("databaseId", "formId", "formLabel")
  res <- res[, c(first.cols, setdiff(names(res), first.cols))]

  res
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
  
  postResource(sprintf("databases/%s/forms", databaseId), request)
  
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
