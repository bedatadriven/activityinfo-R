

testthat::test_that("the function returns an error if the 'formId' is invalid", {

  testthat::expect_error( suppressWarnings(suppressMessages(activityinfo::getFormSchema(formId = 'INVALID'))) )
})


testthat::test_that("the function verifies that the output Schema is valid", {

  output = suppressWarnings(suppressMessages(activityinfo::getFormSchema(formId = FORM_ID)))

  testthat::expect_true( inherits(output, "formSchema") & all(names(output) %in% c("id", "schemaVersion", "databaseId", "label", "elements")) & length(output$elements) > 0 )
})


testthat::test_that("the function returns a Schema data.frame with the expected columns", {

  output = suppressWarnings(suppressMessages(activityinfo::getFormSchema(formId = FORM_ID)))
  output = as.data.frame(output)

  testthat::expect_true( inherits(output, "data.frame") & nrow(output) == 7 & ncol(output) == 16 )
})

testthat::test_that("the function returns a Schema data.frame for a subform", {
  
  output = suppressWarnings(suppressMessages(activityinfo::getFormSchema(formId = "c57pp2ql7hd1hue9")))
  output = as.data.frame(output)
  testthat::expect_true( all(output$parentFormId == "cxo4ffkl7hd0zkl3zzz") )
  
})
