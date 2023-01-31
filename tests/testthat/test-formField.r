
testField <- function(fieldSchema) {
  databaseId = database$databaseId
  fmSchm <- formSchema(databaseId = databaseId, label = paste0("R form ",fieldSchema$label , " test ", cuid()))
  fmSchm <- addFormField(formSchema = fmSchm, schema = fieldSchema)
  dbMetadata <- addForm(databaseId = databaseId, schema = fmSchm)
  fmSchm2 <- getFormSchema(formId = fmSchm$id)
  
  deleteForm(databaseId = databaseId, formId = fmSchm2$id)

  identicalForm(fmSchm, fmSchm2)
}

test_that("Barcode fields can be created and uploaded and downloaded and are identical", {
  testField(barcodeFieldSchema(label = "A barcode field"))
})

test_that("Text fields can be created and uploaded and downloaded and are identical", {
  testField(textFieldSchema(label = "A text field"))
})

test_that("Serial number fields can be created and uploaded and downloaded and are identical", {
  testField(serialNumberFieldSchema(label = "A serial number field"))
})

test_that("Form with many fields can be created and uploaded and downloaded and are identical", {
  databaseId = database$databaseId
  fmSchm <- formSchema(databaseId = databaseId, label = paste0("R form with multiple fields test ", cuid()))
  
  fmSchm <- fmSchm |> 
    addFormField(barcodeFieldSchema(label = "A barcode field")) |>
    addFormField(textFieldSchema(label = "A text field")) |>
    addFormField(serialNumberFieldSchema(label = "A serial number field"))
    
  dbMetadata <- addForm(databaseId = databaseId, schema = fmSchm)
  fmSchm2 <- getFormSchema(formId = fmSchm$id)
  
  deleteForm(databaseId = databaseId, formId = fmSchm2$id)
  
  identicalForm(fmSchm, fmSchm2)
})