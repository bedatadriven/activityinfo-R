
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
  
  fmSchm <- fmSchm %>% 
    addFormField(textFieldSchema(label = "Text field 1", code = "txt1", id = "text1")) %>%
    addFormField(textFieldSchema(label = "Text field 2", code = "txt2", id = "text2")) %>%
    addFormField(textFieldSchema(label = "Text field 3", code = "txt3", id = "text3")) %>%
    addFormField(textFieldSchema(label = "Text field 4", code = "txt4", id = "text4")) %>%
    addFormField(textFieldSchema(label = "Text field 5", code = "txt5", id = "text5"))
    
  test1 <- fmSchm %>% deleteFormField(code = c("txt1", "txt3"))
  expectActivityInfoSnapshot(test1)
  
  test2 <- fmSchm %>% deleteFormField(id = c("text4"))
  expectActivityInfoSnapshot(test2)
  
  test3 <- fmSchm %>% deleteFormField(label = c("Text field 1", "Text field 5"))
  expectActivityInfoSnapshot(test3)

  testthat::expect_warning({
    fmSchm %>% deleteFormField(id = c("Text field 1", "Text field 5"))
  }, regexp = "No matching field")
  
  test_that("The form sanity checks are working", {
    fmSchm2 <- fmSchm
    fmSchm2$elements[length(fmSchm2$elements)+1] <- fmSchm2$elements[length(fmSchm2$elements)]
    testthat::expect_error({
      fmSchm2 %>% deleteFormField(id = "text5")
    })
  })
  
  test_that("The sanity checks for duplicate labels are working", {
    fmSchm2 <- fmSchm
    fmSchm2$elements[[length(fmSchm2$elements)]]$label <- "Text field 4"
    testthat::expect_error({
      fmSchm2 %>% deleteFormField(label = "Text field 4")
    }, regexp = "ambiguous")
  })
  
  fmSchm %>% deleteFormField(label = c("Text field 1", "Text field 5"), upload = TRUE)
  
  fmSchm2 <- getFormSchema(formId = fmSchm$id)
  
  deleteForm(databaseId = fmSchm$databaseId, formId = fmSchm$id)
  
  identicalForm(fmSchm %>% deleteFormField(label = c("Text field 1", "Text field 5")), fmSchm2)
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
  
  fmSchm <- fmSchm %>% 
    addFormField(barcodeFieldSchema(label = "A barcode field")) %>%
    addFormField(textFieldSchema(label = "A text field")) %>%
    addFormField(serialNumberFieldSchema(label = "A serial number field"))
    
  dbMetadata <- addForm(databaseId = databaseId, schema = fmSchm)
  fmSchm2 <- getFormSchema(formId = fmSchm$id)
  
  deleteForm(databaseId = databaseId, formId = fmSchm2$id)
  
  identicalForm(fmSchm, fmSchm2)
})

testthat::test_that("addFormField will warn and mitigate adding fields with same id or codes.", {
  databaseId = database$databaseId
  fmSchm <- formSchema(databaseId = databaseId, label = paste0("R form with multiple fields test ", cuid()))
  
  dupCuid <- cuid()
  
  newField <- barcodeFieldSchema(label = "A barcode field", id = dupCuid)
  newFieldDuplicateId <- textFieldSchema(label = "A text field", id = dupCuid, code = "duplicate")
  newFieldDuplicateCode <- serialNumberFieldSchema(label = "A serial number field", code = "duplicate")
    
  testthat::expect_warning({
    fmSchm <- fmSchm %>% 
      addFormField(newField) %>%
      addFormField(newFieldDuplicateId)
  }, regexp = "form field with the same id")

  testthat::expect_warning({
    fmSchm <- addFormField(fmSchm, newFieldDuplicateCode)
  }, regexp = "form field with the same code")
  
})

testthat::test_that("migrateFieldData() works", {
  df <- data.frame(a = 1:10, b = as.character(1:10), c = factor(1:10))
  newForm <- createFormSchemaFromData(df, database$databaseId, label = "Migrate field test", upload = TRUE)
  
  newSchema <- newForm %>% 
    addFormField(
      dateFieldSchema(label = "newA")
    ) %>%
    addFormField(
      quantityFieldSchema(label = "newB")
    ) %>% 
    addFormField(
      singleSelectFieldSchema(label = "newC", options = as.list(letters[1:10]))
    )
  
  updateFormSchema(schema = newSchema)
  
  records <- getRecords(newSchema, prettyColumnStyle())
  
  migrateFieldData(
    records, 
    from = a, 
    to = newA, 
    function(x) {
      sprintf("2023-03-%02d", x)
    })
  
  migrateFieldData(
    records, 
    from = b, 
    to = newB, 
    function(x) {
      as.numeric(x)
    })
  
  migrateFieldData(
    records, 
    from = c, 
    to = newC, 
    function(x) {
      letters[as.numeric(x)]
    })
  
  recordsMinimal <- getRecords(newSchema, minimalColumnStyle()) %>% collect() %>% as.data.frame()
  
  testthat::expect_snapshot(recordsMinimal)
})

