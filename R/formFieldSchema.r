#' Create a simple form field schema
#'
#' @export
formFieldSchema <- function(type, label, description = NULL, code = NULL, id = cuid(), key = FALSE, required = TRUE, hideFromEntry = FALSE, hideInTable = FALSE, relevanceRules = "", validationRules = NA, reviewerOnly = FALSE) {
  schema <- list()
  
  schema$id <- id
  
  if (!is.null(code)) {
    schema$code = code
  }
  
  schema$label <- label
  schema$relevanceCondition <- relevanceRules
  schema$validationCondition <- validationCondition
  schema$required <- required
  
  if (!is.null(description)) {
    schema$code = description
  }
  
  schema$type <- type
  
}

#' Create a text form field schema
#'
#' @export
textFieldSchema <- function(..., barcode = FALSE) {
  schema <- formFieldSchema(...)
  assertthis::is_boolean(barcode)
  schema$typeParameters <- list(barcode = barcode)
  validateTextFieldSchema(schema)
  schema
}

#' Validate a text form field schema
#'
#' @export
validateTextFieldSchema <- function(schema) {
  checkSettings(schema, "textField")
  stopifnot(is.boolean(schema$typeParameters$barcode))
  stopifnot(length(schema$typeParameters)==1)
}

#' Create a barcode form field schema
#'
#' @export
barcodeFieldSchema <- function(...) {
  schema <- textFieldSchema(..., barcode = TRUE)
  validateBarcodeFieldSchema(schema)
}

#' Validate a barcode form field schema
#'
#' @export
validateBarcodeFieldSchema <- function(schema) {
  checkSettings(schema, "textField")
  stopifnot(length(schema$typeParameters)==1)
  stopifnot(identical(schema$typeParameters$barcode, TRUE),"A barcode Field Schema must have the type parameter barcode = TRUE.")
}

#' Add a new form field
#'
#' @export
addFormField <- function(formId, schema) {
  formSchema <- getFormSchema(formId = formId)
  formSchema$elements <- append(formSchema$elements, schema)
}

#addFormField(formId = "cjs349hlcnbsp9y2", schema = barcodeFieldSchema(label = "barcode r test", description = "The inventory item barcode."))
#
# Function that checks the settings of each field type and throws error if it is not correct

#' Check form field schema settings
#'
#' @export
checkSettings <- function(...) {}