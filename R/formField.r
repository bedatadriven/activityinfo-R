#' Create a simple form field schema
#' 
#' This is the function to create a basic offline form field schema. It is 
#' recommended to use the specific functions for each schema type such as 
#' textFieldSchema() or serialNumberFieldSchema().
#'
#' @param type The type character string defining the form field type.
#' @param label The label of the form field
#' @param description The description of the form field
#' @param code The code name of the form field
#' @param id The id of the form Field; default is to generate a new cuid
#' @param key Whether the form field is a key field; default is FALSE
#' @param required Whether the form field is required; default is FALSE
#' @param hideFromEntry Whether the form field is hidden during data entry; default is FALSE
#' @param hideInTable Whether the form field is hidden during data display; default is FALSE
#' @param relevanceRules Relevance rules for the form field
#' @param validationRules Validation rules for the form field
#' @param reviewerOnly Whether the form field is for reviewers only; default is FALSE
#' @param typeParameters The type parameters object specific to the type given.
#'
#' @export
formFieldSchema <- function(type, label, description = NULL, code = NULL, id = cuid(), key = FALSE, required = FALSE, hideFromEntry = FALSE, hideInTable = FALSE, relevanceRules = "", validationRules = "", reviewerOnly = FALSE, typeParameters = NULL) {

  schema <- list()
  
  schema$id <- id
  
  if (!is.null(code)) {
    schema$code = code
  }
  
  schema$label <- label
  schema$relevanceCondition <- relevanceRules
  schema$validationCondition <- validationRules
  
  schema$tableVisible <- !hideFromEntry
  
  schema$required <- required
  
  if (!is.null(description)) {
    schema$description = description
  }
  
  schema$type <- type
  schema$key <- key
  
  schema$typeParameters <- typeParameters
  
  schema <- asFormFieldSchema(schema)
  
  schema
  
}

asFormFieldSchema <- function(e) {
  e$key <- identical(e$key, TRUE)
  e$required <- identical(e$required, TRUE)
  e$tableVisible <- !identical(e$tableVisible, FALSE)
  if(is.null(e$code)) {
    e["code"] <- list(NULL)
  }
  if(is.null(e$description)) {
    e["description"] <- list(NULL)
  }
  class(e) <- c("activityInfoFormFieldSchema", "formField", class(e))
  
  e <- addFormFieldSchemaCustomClass(e)
  e
}

addFormFieldSchemaCustomClass <- function(e) {
  if (e$type == "FREE_TEXT") {
    if (e$typeParameters$barcode) {
      class(e) <- c("activityInfoBarcodeFieldSchema", class(e))
    } else {
      class(e) <- c("activityInfoTextFieldSchema", class(e))
    }
  } else if (e$type == "serial") {
    class(e) <- c("activityInfoSerialNumberFieldSchema", class(e))
  }
  return(e)
}

validateFormFieldSchema <- function(schema) {
  stopifnot("activityInfoFormFieldSchema" %in% class(schema))
  # check if has cuid
  # check if has all standard properties
  # ...
}

#' Pretty print a form field schema
#'
#' @param x an object of class \code{activityInfoFormFieldSchema}.
#' @param ... ignored
#'
#' @export
print.activityInfoFormFieldSchema <- function(x, ...) {
  cat(sprintf("%s (%s)\n", class(x)[1], x$type))
  cat(sprintf("    %s: %s\n", x$id, x$label))
  
  xNames <- names(x)
  
  for(nm in xNames) {
    if(nm == "typeParameters") {
      tNames <- names(x[[nm]])
      cat("      Type parameters: \n")
      for (nm2 in tNames) {
        cat(sprintf("        %s: %s\n", nm2, x[[nm]][nm2]))
      }
    } else {
      cat(sprintf("      %s: %s\n", nm, x[nm]))
    }
  }
  
  
  attrs <- c(
    if (x$key) "Key" else NULL,
    if (x$required) "Required" else NULL
  )
  
  if (length(attrs)) {
    cat(sprintf("      %s\n", paste(attrs, collapse = ", ")))
  }
  
  if (is.character(x$description)) {
    cat(sprintf("      description: %s\n", x$description))
  }
  
  cat(sprintf("      type: %s\n", x$type))
  
}

#' Create a text form field schema
#' 
#' @inheritParams formFieldSchema
#'
#' @export
textFieldSchema <- function(label, description = NULL, code = NULL, id = cuid(), key = FALSE, required = FALSE, hideFromEntry = FALSE, hideInTable = FALSE, relevanceRules = "", validationRules = "", reviewerOnly = FALSE) {
  schema <- do.call(
    formFieldSchema, 
    args = c(
      list(type = "FREE_TEXT"),
      as.list(environment()),
      list(
        typeParameters = list("barcode" = FALSE)
        )
      )
  )
  
  # schema <- formFieldSchema(type = "FREE_TEXT", typeParameters = )
  validateTextFieldSchema(schema)
  schema
}

#' Validate a text form field schema
#'
#' @param schema The text form field schema to validate
#'
#' @export
validateTextFieldSchema <- function(schema) {
  validateTextFieldOrBarcodeSchema(schema)
  stopifnot(schema$typeParameters$barcode==FALSE)
  stopifnot("activityInfoTextFieldSchema" %in% class(schema))
}

validateTextFieldOrBarcodeSchema <- function(schema) {
  validateFormFieldSchema(schema)
  stopifnot(schema$type == "FREE_TEXT")
  stopifnot(is.logical(schema$typeParameters$barcode))
  stopifnot(length(schema$typeParameters$barcode)==1)
  stopifnot(length(schema$typeParameters)==1)
}

#' Create a barcode form field schema
#'
#' @param ... See arguments defined in \link[activityinfo]{formFieldSchema}
#'
#' @export
barcodeFieldSchema <- function(...) {
  schema <- formFieldSchema(type = "FREE_TEXT", typeParameters = list("barcode" = TRUE), ...)
  validateBarcodeFieldSchema(schema)
  schema
}

#' Validate a barcode form field schema
#'  
#' @param schema The barcode form field schema to validate
#' 
#' @export
validateBarcodeFieldSchema <- function(schema) {
  validateTextFieldOrBarcodeSchema(schema)
  stopifnot("activityInfoBarcodeFieldSchema" %in% class(schema))
  stopifnot("A barcode Field Schema must have the type parameter barcode = TRUE." = identical(schema$typeParameters$barcode, TRUE))
}

#' Create a text form field schema
#' 
#' @param digits The number of digits in the serial number
#' @param prefixFormula A formula as a character string defining the prefix for 
#' the serial number
#' @param ... See arguments defined in \link[activityinfo]{formFieldSchema}
#'
#' @export
serialNumberFieldSchema <- function(..., digits = 5, prefixFormula = NULL) {
  typeParameters <- list(digits = digits)
  if(!is.null(prefixFormula)&&is.character(prefixFormula)&&length(prefixFormula)>0) {
    typeParameters$prefixFormula = prefixFormula
  }
  schema <- formFieldSchema(type = "serial", typeParameters = typeParameters, ...)
  validateSerialNumberFieldSchema(schema)
  schema
}

#' Validate a serial number form field schema
#' 
#' @param schema The schema of the serial number form field
#'
#' @export
validateSerialNumberFieldSchema <- function(schema) {
  validateFormFieldSchema(schema)
  parameters <- names(schema)
  stopifnot(schema$validationCondition=="")
  stopifnot(schema$relevanceCondition=="")
  stopifnot(identical(schema$required, FALSE))
  stopifnot(schema$type == "serial")
  stopifnot("activityInfoSerialNumberFieldSchema" %in% class(schema))
  stopifnot(is.numeric(schema$typeParameters$digits))
  stopifnot(length(schema$typeParameters$digits)==1)
  if("prefixFormula" %in% names(schema$typeParameters)) {
    stopifnot(is.character(schema$typeParameters$prefixFormula)&&length(schema$typeParameters$prefixFormula)==1)
  }
}

#' Add a new form field
#' 
#' Adds a new form field to an offline form schema or else downloads the form 
#' schema and adds the new form field. Note that the either the upload argument 
#' must be TRUE for the field to be added automatically online or the user will 
#' also need to use updateFormSchema() to upload the changes after they are 
#' completed.
#' 
#' @rdname addFormField
#' @param formId The identifier of the form online
#' @param formSchema The offline schema of the form
#' @param schema The form field schema to be added to the form
#' @param upload Default is FALSE. If TRUE the modified form schema will be uploaded.
#' @param ... ignored
#'
#' @export
addFormField <- function(...) {
  UseMethod("addFormField")
}

#' @rdname addFormField
#' @export
addFormField.character <- function(formId, schema, upload = FALSE, ...) {
  validateFormFieldSchema(schema)
  formSchema <- getFormSchema(formId = formId)
  formSchema$elements[[length(formSchema$elements)+1]] <- schema
  if (upload == TRUE) {
    updateFormSchema(formSchema)
  } else {
    formSchema
  }
}

#' @rdname addFormField
#' @export
addFormField.formSchema <- function(formSchema, schema, upload = FALSE, ...) {
  validateFormFieldSchema(schema)
  validateFormSchema(formSchema)
  formSchema$elements[[length(formSchema$elements)+1]] <- schema
  if (upload == TRUE) {
    updateFormSchema(formSchema)
  } else {
    formSchema
  }
}

#' @rdname addFormField
#' @export
addFormField.default <- addFormField.character
