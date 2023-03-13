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
  
  rcrds <- getRecords(uploadedForm$id, style = )
  
  rcrds %>% 
    addFilter('[a_logical_column] == "True"') %>% 
    addSort(list(list(dir = "ASC", field = "date_col"))) %>%
    slice_head(n = 10)
  
  recordIds <- rcrds %>% 
    addFilter('[a_logical_column] == "True"') %>% 
    addSort(list(list(dir = "ASC", field = "date_col"))) %>%
    head(n = 10) %>% 
    mutate(a10 = as.numeric(`a`) + 10) %>% 
    pull("_id")
  
  testthat::expect_equal(length(recordIds), 10)
})