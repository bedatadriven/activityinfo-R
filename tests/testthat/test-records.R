testthat::test_that("updateRecord() works", {

})

testthat::test_that("addRecord() works", {

})

testthat::test_that("deleteRecord() works", {

})

testthat::test_that("getRecordHistory() works", {

})

testthat::test_that("getRecord() works", {

})


testthat::test_that("getAttachment() works", {

})

testthat::test_that("reference() works", {

})

testthat::test_that("recoverRecord() works", {

})


testthat::test_that("getRecords() works", {
  testData <- data.frame(a = as.character(1:500), b = rep(factor(paste0(1:5, "_stuff")), 100), a_logical_column = ((1:500)%%7==(1:500)%%3), date_col = rep(seq(as.Date("2021-07-06"),as.Date("2021-07-15"),by = 1),50))
  
  schemaPackage <- formSchemaFromData(testData, database$databaseId, label = "getRecords() test form", keyColumns = "a", requiredColumns = "a")
  
  schemaView <- as.data.frame(schemaPackage$schema)
  
  uploadedForm <- addForm(schemaPackage$schema)
  
  importTable(formId = schemaPackage$schema$id, data = testData)
  
  records <- getRecords(uploadedForm$id)
  
  records %>% addFilter('[a_logical_column] == "True"')
  
  records %>% head(2)
  
})