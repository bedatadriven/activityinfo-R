


changeName <- function(x, from, to) {
  if (is.null(names(x))) {
    return(x)
  }

  stopifnot(is.character(from))
  stopifnot(is.character(to))

  name.index <- which(names(x) == from)

  # rename first occurrence of 'from' name:
  if (length(name.index) > 0) names(x)[name.index[1]] <- to[1]

  x
}

#' Gets the schema of a form
#'
#' The result has a class "formSchema" and can be transformed to
#' data.frame using `as.data.frame()`
#'
#'
#' @param formId the form identifier
#' @examples
#' \dontrun{
#' formSchema <- getFormSchema("ck2lt9wp3g")
#' formSchemaTable <- as.data.frame(getFormSchema("ck2lt9wp3g"))
#' }
#' @return A list with class \sQuote{formSchema}.
#' @export
#' 
getFormSchema <- function(formId) {
  stopifnot(is.character(formId))
  schema <- getResource(
    sprintf("form/%s/schema", formId),
    task = sprintf("Getting form %s schema", formId)
  )

  asFormSchema(schema)
}

# Enforce some types to make other
# operations easier
asFormSchema <- function(schema) {
  schema$elements <- lapply(schema$elements, function(e) {
    asFormFieldSchema(e)
  })
  class(schema) <- c("activityInfoFormSchema", "formSchema", class(schema))
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
  if (!is.null(schema$parentFormId)) {
    cat(sprintf("  parentFormId: %s\n", schema$parentFormId))
  }
  cat(sprintf("  elements: %d\n", length(schema$elements)))

  for (field in schema$elements) {
    # cat(sprintf("    %s: %s\n", field$id, field$label))
    # attrs <- c(
    #   if (field$key) "Key" else NULL,
    #   if (field$required) "Required" else NULL
    # )
    #
    # if (length(attrs)) {
    #   cat(sprintf("      %s\n", paste(attrs, collapse = ", ")))
    # }
    #
    # if (is.character(field$description)) {
    #   cat(sprintf("      description: %s\n", field$description))
    # }
    # cat(sprintf("      type: %s\n", field$type))
    print(field)
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
  null2na <- function(y) if (is.null(y) || !nzchar(y)) NA else y

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
    stringsAsFactors = FALSE
  )
}

#' @importFrom dplyr as_tibble
#' @export
as_tibble.formSchema <- function(x, ..., .rows, .name_repair, rownames) {
  as_tibble(as.data.frame(x), .rows, .name_repair, rownames)
}

#' Delete a form
#'
#' Deletes a form given the form id and the database id of the
#' database containing that form.
#'
#' @param databaseId The id of the database containing the form
#' @param formId The id of the form
#'
#' @export
deleteForm <- function(databaseId, formId) {
  request <- databaseUpdates()
  request$resourceDeletions <- list(formId)

  result <- postResource(
    sprintf("databases/%s", databaseId),
    request,
    task = sprintf("Requesting to delete form with id %s from database %s", formId, databaseId)
  )

  tryCatch(
    expr = {
      getFormSchema(formId = formId)
      stop(sprintf("Failed to delete form %s: it is still on the server.", formId))
    },
    error = function(e) {
      message(sprintf("Confirmed deletion of form %s", formId))
      invisible(TRUE)
    }
    )
}

#' Adds a new form to a database
#' @rdname addForm
#' @param databaseId the id of the database
#' @param schema the schema of the form to add
#' @param folderId the id of the folder to which this form should be added
#' @param ... ignored
#' @export
#' @examples
#' \dontrun{
#' addForm(formSchema(
#'   databaseId = myDatabaseId,
#'   label = "ActivityInfo form generated from R",
#'   elements = list(
#'     textFieldSchema(label = "What is your name?", code = "name", required = TRUE),
#'     dateFieldSchema(label = "When were you born?", code = "dob"))))
#' }
#' @seealso [activityinfo::formSchema], [activityinfo::formFieldSchema], \code{vignette("add-and-manipulate-forms", package = "activityinfo")}
addForm <- function(...) {
  UseMethod("addForm")
}

#' @export
#' @rdname addForm
addForm.formSchema <- function(schema, folderId = schema$databaseId, ...) {
  schema <- prepFormSchemaForUpload(schema)

  request <- list(
    formResource = list(
      id = schema$id,
      parentId = schema$databaseId,
      type = "FORM",
      label = schema$label,
      visibility = "PRIVATE"
    ),
    formClass = schema
  )

  result <- postResource(
    sprintf("databases/%s/forms", schema$databaseId),
    request,
    task = sprintf("Adding a new form '%s' with id %s in database %s", schema$label, schema$id, schema$databaseId)
  )

  # The API returns all affected forms, as well as the database tree.
  # Extract only the form we added
  schemaResult <- result$forms[[ which(sapply(result$forms, function(f) f$id == schema$id)) ]]$schema

  asFormSchema(schemaResult)

}

#' @export
#' @rdname addForm
addForm.character <- function(databaseId, schema, folderId = databaseId, ...) {
  schema$databaseId <- databaseId
  if (!("activityInfoFormSchema" %in% class(schema))) {
    schema <- asFormSchema(schema)
  }
  addForm(schema, folderId)
}

#' @export
#' @rdname addForm
addForm.default <- addForm.character

#' Create a form schema object
#'
#' Generates a new form schema object which can be used to add a new form
#' to ActivityInfo.
#'
#' @param databaseId The identifier of the database containing the form
#' @param label The label of the form
#' @param id The identifier of the form; if unused will generate a new cuid
#' @param elements The elements/form fields of the form
#' @param folderId The identifier of the folder containing the form
#' @export
#' @examples
#' survey <- formSchema(
#'    databaseId = "cyx12345gh",
#'    label = "ActivityInfo form generated from R",
#'    elements = list(
#'      textFieldSchema(label = "What is your name?", code = "name", required = TRUE),
#'      dateFieldSchema(label = "When were you born?", code = "dob")))
#' \dontrun{
#' addForm(survey)
#' }
#'
formSchema <- function(databaseId, label, id = cuid(), elements = list(), folderId = databaseId) {
  stopifnot(is.character(label))
  stopifnot("The label must have one or more characters." = nchar(label)>0)
  asFormSchema(list(
    id = id,
    databaseId = databaseId,
    label = label,
    elements = elements
  ))
}

validateFormSchema <- function(form) {
  stopifnot("activityInfoFormSchema" %in% class(form))
  for(e in form$elements) {
    isFormFieldSchema(e)
  }
}

#' Updates a form schema
#'
#' @param schema a form schema
#'
#' @return Returns the updated form schema from the ActivityInfo server
#'
#' @export
updateFormSchema <- function(schema) {
  schema <- prepFormSchemaForUpload(schema)

  result <- postResource(
    sprintf("form/%s/schema", schema$id),
    body = schema,
    task = sprintf("Update of form schema for form %s (%s)", schema$label, schema$id),
    requireStatus = 200
  )

  asFormSchema(result$forms[[1]]$schema)
}

# Touch up structure to avoid problems with toJson
prepFormSchemaForUpload <- function(schema) {
  schema$elements <- lapply(schema$elements, function(x) {
    n <- sapply(x, length)
    x <- x[n != 0]
    x
  })
  schema
}

#' Queries the Form Tree of a Form
#'
#' @param formId the form identifier
#' @return A list with class \sQuote{formTree}.
#' @export
getFormTree <- function(formId) {
  stopifnot(is.character(formId))
  tree <- getResource(
    paste("form", formId, "tree", sep = "/"),
    task = sprintf("Getting form %s tree", formId)
  )

  if (length(tree$forms)==0) stop(sprintf("The form id %s provided an empty form tree. Please check access rights and whether the id is correct.", formId))

  # enforce some types to make other operations easier:
  tree$forms <- lapply(tree$forms, function(form) {
    asFormSchema(form$schema)
  })

  class(tree) <- c("activityInfoFormTree", "formTree")
  tree
}

#' Relocating a form moves the form, together with all of its subforms,
#' records, and record history, to a new database.
#'
#' In order to relocate a form, the user must have "delete" permission in the
#' source database, and permission to add new forms in the target database.
#'
#' @param formId the id of the form to move
#' @param newDatabaseId the id of the database to which the form should be moved.
#' @export
relocateForm <- function(formId, newDatabaseId) {
  postResource(
    sprintf("/form/%s/database", formId),
    body = list(databaseId = newDatabaseId),
    task = sprintf("Relocating form %s to database %s", formId, newDatabaseId)
  )
}

#' Creates a form schema from a data set by guessing the field types required
#'
#' This function helps to create new form schemas for existing datasets.
#'
#' @param x the data.frame or tibble for which to create form fields and a form 
#' schema
#' @param databaseId the id of the database to which the form should belong.
#' @param label the label of the new form
#' @param folderId the id of the folder where the form should reside; defaults to the database id
#' @param keyColumns a character vector of the column names of the form fields that should be form keys
#' @param requiredColumns a character vector of the column names of the form fields that should be required
#' @param logicalAsSingleSelect by default TRUE and converts logical columns in the data frame to a single select form field; if FALSE then it will convert TRUE to 1 and FALSE to 0
#' @param logicalText the single select replacement values for c(TRUE, FALSE); default is c("True","False")
#' @param upload immediately upload the new form
#' @export
createFormSchemaFromData <- function(x, databaseId, label, folderId = databaseId, keyColumns = character(), requiredColumns = keyColumns, logicalAsSingleSelect = TRUE, logicalText = c("True","False"), upload = FALSE) {
  stopifnot("A data frame or tibble must be provided to formSchemaFromData()" = is.data.frame(x))
  stopifnot("databaseId must be a singe character string" = is.character(databaseId)&&length(databaseId)==1)
  stopifnot("The label for the new form schema must not be empty" = !missing(label)&&is.character(label)&&length(label)==1&&nchar(label)>0)
  stopifnot("The folderId must be a single character string if defined" = is.character(folderId)&&length(folderId)==1)
  stopifnot("The keyColumns named must be provided as a character vector" = is.character(keyColumns))
  stopifnot("logicalAsSingleSelect must be TRUE or FALSE" = is.logical(logicalAsSingleSelect))
  stopifnot("Logical text values must be length 2" = is.character(logicalText)&&length(logicalText)==2)

  providedCols <- names(x)

  stopifnot("Some key columns do not exist in the data.frame provided" = keyColumns %in% providedCols)
  stopifnot("Some required columns do not exist in the data.frame provided" = keyColumns %in% providedCols)

  fmSchema <- formSchema(databaseId = databaseId, label = label, folderId = folderId)

  addIt <- function(fieldSchema) fmSchema <<- addFormField(fmSchema, fieldSchema)
  keyStop <- function(type, pCol) stop(sprintf("Column '%s' of type %s cannot be a key column", pCol, type))

  x2 <- x


  lapply(providedCols, function(pCol) {
    y <- x[[pCol]]
    fieldClass <- class(y)
    key <- pCol %in% keyColumns
    required <- pCol %in% requiredColumns

    if ("character" %in% fieldClass) {
      maxLength <- max(nchar(y, allowNA = TRUE, keepNA = FALSE))
      hasNewLine <- any(grepl("(\\r\\n|\\r|\\n)", y))
      if ((maxLength>1024||hasNewLine)&&key) {
        stop(sprintf("Key column %s values invalid. Check for linebreaks or values with >1024 characters.", pCol))
      }
      if (!hasNewLine&&maxLength<=1024) {
        addIt(textFieldSchema(label = pCol, key = key, required = required))
      } else {
        # default to Narrative for longer fields > 1024 characters and fields with new lines
        addIt(multilineFieldSchema(label = pCol))
      }
    } else if ("factor" %in% fieldClass) {
      # default to single select field using factor labels; they must be unique
      addIt(singleSelectFieldSchema(label = pCol, options = levels(y), key = key, required = required))
    } else if ("integer" %in% fieldClass) {
      if (key) keyStop("quantity", pCol)
      addIt(quantityFieldSchema(label = pCol, required = required))
    } else if ("numeric" %in% fieldClass) {
      if (key) keyStop("quantity", pCol)
      addIt(quantityFieldSchema(label = pCol, required = required))
    } else if ("logical" %in% fieldClass) {
      if (logicalAsSingleSelect) {
        x2[,pCol] <<- ifelse(y, logicalText[[1]], logicalText[[2]])
        addIt(singleSelectFieldSchema(label = pCol, options = c(logicalText[[1]], logicalText[[2]]), key = key, required = required))
      } else {
        if (key) keyStop("quantity", pCol)
        x2[,pCol] <<- ifelse(y, 1L, 0L)
        addIt(quantityFieldSchema(label = pCol, required = required))
      }
    } else if ("Date" %in% fieldClass) {
      addIt(dateFieldSchema(label = pCol, key = key, required = required))
    } else if ("POSIXt" %in% fieldClass) {
      warning(sprintf("POSIXt time+date column %s will be a text form field. Separate date into another column to store as date.", pCol))
      x2[,pCol] <<- as.character(y)
      addIt(textFieldSchema(label = pCol, key = key, required = required))
    } else {
      stop(sprintf("Unrecognized column type with class(es) (%s) in column %s", paste(fieldClass, collapse = ", "), pCol))
    }
  })
  
  if(upload) {
    addForm(fmSchema)
    importRecords(formId = fmSchema$id, data = x2)
  }
  
  list(schema = fmSchema, data = x2)
}


