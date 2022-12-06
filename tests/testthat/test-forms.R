# Seems like this could be removed -- does not actually test anything in the function (returns a 404 error)
testthat::test_that("getFormSchema() returns an error if the 'formId' is invalid", {
  testthat::expect_error({
    suppressWarnings(suppressMessages(
      getFormSchema(formId = 'INVALID')
    ))
  }, class = "http_404")
})

testthat::test_that("getFormSchema() output Schema is valid", {
  output = suppressWarnings(suppressMessages(getFormSchema(formId = personFormId)))
  testthat::expect_true( inherits(output, "formSchema") & all(names(output) %in% c("id", "schemaVersion", "databaseId", "label", "elements")) & length(output$elements) > 0 )
  #expectActivityInfoSnapshot(output)
})

testthat::test_that("getFormSchema() and as.data.frame.formSchema() return a Schema data.frame with the expected columns", {
  
  output = suppressWarnings(suppressMessages(getFormSchema(formId = personFormId)))
  #expectActivityInfoSnapshot(output)
  
  output = as.data.frame(output)
  
  testthat::expect_true( inherits(output, "data.frame") & nrow(output) == 2 & ncol(output) == 17 )
  testthat::expect_true( all(c(
    "databaseId",
    "formId", 
    "formLabel",
    "formParentId",
    "fieldId",
    "fieldCode",
    "fieldLabel",
    "fieldDescription",
    "validationCondition",
    "relevanceCondition",
    "fieldRequired",
    "key",
    "referenceFormId",
    "formula",
    "dataEntryVisible",
    "tableVisible") %in% names(output)))
  
  
})

testthat::test_that("getFormSchema() returns a Schema data.frame for a subform", {
  output = getFormSchema(formId = childrenSubformId)
  output = as.data.frame(output)
  
  testthat::expect_true( all(output$parentFormId == personFormId) )
})

testthat::test_that("getFormTree() returns a formTree for parent and child forms (1 level deep)", {
  parentForm <- getFormTree(personFormId)
  childForm <- getFormTree(childrenSubformId)
  
  testthat::expect_s3_class(parentForm, "formTree")
  testthat::expect_s3_class(childForm, "formTree")

  testthat::expect_s3_class(childForm$forms[[1]], "formSchema")
  testthat::expect_s3_class(parentForm$forms[[1]], "formSchema")
  
  parentForm$forms <- parentForm$forms[names(childForm$forms)]
  
  testthat::expect_identical(childForm$forms, parentForm$forms)
  testthat::expect_identical(childForm$root, childrenSubformId)
  testthat::expect_identical(parentForm$root, personFormId)
  
  #expectActivityInfoSnapshot(parentForm)
  #expectActivityInfoSnapshot(childForm)
  
})

# updateFormSchemaResult should have names forms and database - why does it not return the updated schema?
testthat::test_that("updateFormSchema() api call returns object with database and forms", {
  testthat::expect_true(all(c("database", "forms") %in% names(updateFormSchemaResult)))
  
  #expectActivityInfoSnapshot(updateFormSchemaResult)
})

testthat::test_that("relocateForm() works", {
  testthat::expect_error(relocateForm(childrenSubformId, database2$databaseId), class = "activityinfo_api")
  move1 <- relocateForm(personFormId, database2$databaseId)
  testthat::expect_equal(move1$code, "RELOCATED")
  move2 <- relocateForm(personFormId, database$databaseId)
  testthat::expect_equal(move2$code, "RELOCATED")
})