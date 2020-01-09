

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
  cat(sprintf("  elements:\n", length(schema$elements)))
  
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

#' Flatten form schema as a table
#'
#' @param form.schema A list returned by \code{getFormSchema}.
#' @export
as.data.frame.formSchema <- function(form) {

  ## pop elements list
  form.sans.elements <- form[-which(names(form) == "elements")]
  if (is.null(form.sans.elements[["parentFormId"]])) {
    form.sans.elements[["parentFormId"]] <- NA_character_
  }
  if (is.null(form.sans.elements[["subFormKind"]])) {
    form.sans.elements[["subFormKind"]] <- NA_character_
  }
  
  elements <- do.call(rbind, lapply(seq_along(form$elements), function(j) {
    element <- form$elements[[j]]
    ## turn NULL to NA:
    nulls <- sapply(element, is.null)
    element[nulls] <- NA_character_
    ## add 'key' if not exists:
    if (!"key" %in% names(element)) {
      element[["key"]] <- NA_character_
    }
    ## exclude typeParameters sub-list (if exists):
    if ("typeParameters" %in% names(element)) {
      element <- element[-which(names(element) == "typeParameters")]
    }
    data.frame(element,
               stringsAsFactors = FALSE)
  }))
  
  res <- data.frame(
    as.data.frame(form.sans.elements, stringsAsFactors = FALSE),
    elements,
    stringsAsFactors = FALSE
  )
  
  ## remove rows where code is NA:
  res <- res[!is.na(res$code), ]
  
  ### prettify data --------------------------------------- ###
  ## drop columns:
  remove.cols <-
    c(
      "schemaVersion",
      "subFormKind",
      "label",
      "id.1",
      "relevanceCondition",
      "visible",
      "key"
    )
  res <- res[, !(names(res) %in% remove.cols)]
  ## reorder columns:
  first.cols <- c("databaseId", "id")
  res <- res[, c(first.cols, setdiff(names(res), first.cols))]
  ## rename columns:
  colnames(res)[which(colnames(res) == "id")] <- "formId"
  colnames(res)[which(colnames(res) == "label.1")] <- "question"
  
  data.frame(res, stringsAsFactors = FALSE)
  
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
