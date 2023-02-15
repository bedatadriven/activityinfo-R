
testField <- function(fieldSchema) {
  testthat::expect_identical(length(class(fieldSchema)), 4L)
  
  length(class(barcodeFieldSchema("Test")))
  
  databaseId = database$databaseId
  fmSchm <- formSchema(databaseId = databaseId, label = paste0("R form ",fieldSchema$label , " test ", cuid()))
  
  fmSchm <- addFormField(formSchema = fmSchm, schema = fieldSchema)
  dbMetadata <- addForm(databaseId = databaseId, schema = fmSchm)
  fmSchm2 <- getFormSchema(formId = fmSchm$id)
  
  deleteForm(databaseId = databaseId, formId = fmSchm2$id)

  identicalForm(fmSchm, fmSchm2)
}

test_that("Test deleteFormField()", {
  
  fmSchm <- formSchema(databaseId = database$databaseId, label = "R form with multiple fields to delete")
  
  fmSchm <- fmSchm |> 
    addFormField(textFieldSchema(label = "Text field 1", code = "txt1", id = "Text1")) |>
    addFormField(textFieldSchema(label = "Text field 2", code = "txt2", id = "Text2")) |>
    addFormField(textFieldSchema(label = "Text field 3", code = "txt3", id = "Text3")) |>
    addFormField(textFieldSchema(label = "Text field 4", code = "txt4", id = "Text4")) |>
    addFormField(textFieldSchema(label = "Text field 5", code = "txt5", id = "Text5"))
    
  test1 <- fmSchm %>% deleteFormField(code = c("txt1", "txt3"))
  expectActivityInfoSnapshot(test1)
  
  test2 <- fmSchm %>% deleteFormField(id = c("Text4"))
  expectActivityInfoSnapshot(test2)
  
  test3 <- fmSchm %>% deleteFormField(code = c("Text field 1", "Text field 5"))
  expectActivityInfoSnapshot(test3)

  testthat::expect_warning({
    fmSchm %>% deleteFormField(id = c("Text field 1", "Text field 5"))
  })
  
  fmSchm %>% deleteFormField(label = c("Text field 1", "Text field 5"), upload = TRUE)
  
  fmSchm2 <- getFormSchema(formId = fmSchm$id)
  
  deleteForm(databaseId = fmSchm$databaseId, formId = fmSchm$id)
  
  identicalForm(fmSchm %>% deleteFormField(label = c("Text field 1", "Text field 5")), fmSchm2)
})

test_that("Test addFormField()", {
  
})

test_that("Test roundtrip of attachmentFieldSchema()", {
  testField(attachmentFieldSchema(label = "A attachment FieldSchema field"))
})

test_that("Barcode fields can be created and uploaded and downloaded and are identical", {
  testField(barcodeFieldSchema(label = "A barcode field"))
})

test_that("Test roundtrip of calculatedFieldSchema()", {
  testthat::expect_error({
    testField(calculatedFieldSchema(label = "A calculatedFieldSchema field"))
  })
  testField(calculatedFieldSchema(label = "A calculatedFieldSchema field", formula = "1==1"))
})

test_that("Test roundtrip of dateFieldSchema()", {
  testField(dateFieldSchema(label = "A dateFieldSchema field"))
})

# test_that("Test roundtrip of fortnightFieldSchema()", {
#   testField(fortnightFieldSchema(label = "A fortnightFieldSchema field"))
# })

test_that("Test roundtrip of geopointFieldSchema()", {
  testField(geopointFieldSchema(label = "A geopointFieldSchema field", manualEntryAllowed = FALSE))
  testField(geopointFieldSchema(label = "A geopointFieldSchema field", requiredAccuracy = 10, manualEntryAllowed = TRUE))
  testField(geopointFieldSchema(label = "A geopointFieldSchema field", requiredAccuracy = 25, manualEntryAllowed = FALSE))
})

test_that("Test roundtrip of monthFieldSchema()", {
  testField(monthFieldSchema(label = "A monthFieldSchema field"))
})

test_that("Test roundtrip of multilineFieldSchema()", {
  testField(multilineFieldSchema(label = "A multilineFieldSchema field"))
})

test_that("Test roundtrip of multipleSelectFieldSchema()", {
  testField(multipleSelectFieldSchema(label = "A multipleSelectFieldSchema field"))
  testField(multipleSelectFieldSchema(label = "A multipleSelectFieldSchema field", options = toSelectOptions(c(
    "Option 1",
    "Option 2",
    "Option 3"
  ))))
})

test_that("Test roundtrip of quantityFieldSchema()", {
  testField(quantityFieldSchema(label = "A quantityFieldSchema field"))
})

test_that("Test roundtrip of referenceFieldSchema()", {
  testField(referenceFieldSchema(label = "A referenceFieldSchema field", referencedFormId = "A dummy formId"))
})

test_that("Test roundtrip of sectionFieldSchema()", {
  testField(sectionFieldSchema(label = "A sectionFieldSchema field"))
})

test_that("Serial number fields can be created and uploaded and downloaded and are identical", {
  testField(serialNumberFieldSchema(label = "A serial number field"))
})

test_that("Test roundtrip of singleSelectFieldSchema()", {
  testField(singleSelectFieldSchema(label = "A singleSelectFieldSchema field"))
  testField(singleSelectFieldSchema(label = "A singleSelectFieldSchema field", options = toSelectOptions(c(
    "Option 1",
    "Option 2",
    "Option 3"
  ))))
})

test_that("Test roundtrip of subformFieldSchema() - dummy subform id", {
  subformCuid = cuid()
  testField(subformFieldSchema(label = "A subformFieldSchema field", subformId = subformCuid))
})

test_that("Test roundtrip of subformFieldSchema() with creation of subform", {
})


test_that("Text fields can be created and uploaded and downloaded and are identical", {
  testField(textFieldSchema(label = "A text field"))
})

test_that("Test roundtrip of userFieldSchema()", {
  testthat::expect_error({testField(userFieldSchema(label = "A userFieldSchema field"))})
  testField(userFieldSchema(label = "A userFieldSchema field", databaseId = database$databaseId))
})

test_that("Test roundtrip of weekFieldSchema()", {
  testField(weekFieldSchema(label = "A weekFieldSchema field"))
})

test_that("Test toSelectOptions()", {
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