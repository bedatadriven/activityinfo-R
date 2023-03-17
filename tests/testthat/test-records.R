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
  testData <- tibble(`Identifier number` = as.character(1:500), "A single select column" = rep(factor(paste0(1:5, "_stuff")), 100), "A logical column" = ((1:500)%%7==(1:500)%%3), "A date column" = rep(seq(as.Date("2021-07-06"),as.Date("2021-07-25"),by = 1),25))
  
  schemaPackage <- createFormSchemaFromData(testData, database$databaseId, label = "getRecords() test form", keyColumns = "Identifier number", requiredColumns = "Identifier number")
  
  schemaView <- as.data.frame(schemaPackage$schema)
  
  uploadedForm <- addForm(schemaPackage$schema)
  
  importTable(formId = schemaPackage$schema$id, data = testData)
  
  rcrds <- getRecords(uploadedForm$id, style = prettyColumnStyle())
  
  dfA <- rcrds %>% 
    addFilter('[A logical column] == "True"') %>% 
    addSort(list(list(dir = "ASC", field = "_id"))) %>%
    slice_head(n = 10) %>% collect()
  
  dfB <- rcrds %>% 
    filter(`A logical column` == "True") %>% 
    addSort(list(list(dir = "ASC", field = "_id"))) %>%
    slice_head(n = 10) %>% collect()
  
  attr(dfA, "remoteRecords") <- NULL
  attr(dfB, "remoteRecords") <- NULL
  
  testthat::expect_identical(dfA,dfB)
  
  testthat::expect_warning({
    dfC <- rcrds %>% 
      filter(`A logical column` == "True") %>% 
      arrange(`_id`) %>%
      slice_head(n = 10) %>% collect()
  })

  attr(dfC, "remoteRecords") <- NULL
  
  attr(dfB, "rows") <- NULL
  attr(dfC, "rows") <- NULL
  
  testthat::expect_identical(dfB,dfC)
    
  # removing columns required for a filter will result in an error
  # expect warning using select after filter or sort
  testthat::expect_error({
    testthat::expect_warning({
      recordIds <- rcrds %>% 
        addFilter('[A logical column] == "True"') %>% 
        addSort(list(list(dir = "DESC", field = "A date column"))) %>%
        head(n = 10) %>%
        select(`_id`) %>%
        collect() %>%
        pull("_id")
    })
  })
  
  testthat::expect_no_warning({
    rcrds %>% 
      select(id = `_id`, date = `A date column`, logical = `A logical column`) %>%
      filter(logical == "True") %>% 
      rename(logical2 = logical) %>%
      collect()
  })
  
  # renaming columns required for a sort will result in an error
  testthat::expect_error({
    testthat::expect_warning({
      rcrds %>% 
        select(id = `_id`, date = `A date column`, logical = `A logical column`) %>%
        filter(logical == "True") %>% rename(date2 = date) %>% 
        addSort(list(list(dir = "DESC", field = "date"))) %>% 
        head(10) %>% 
        collect()
    })
  })
  
  rcrds %>% select(id = `Identifier number`) %>% copySchema(databaseId = "dbid", label = "new form")
  
  # no form schema elements to provide - expect warning
  testthat::expect_warning({
    rcrds %>% select(starts_with("_")) %>% copySchema(databaseId = "dbid", label = "new form")
  })
  
  # Ok to rename columns after only a filter step
  recordIds <- rcrds %>% 
    select(id = `_id`, date = `A date column`, logical = `A logical column`) %>%
    filter(logical == "True") %>% rename(logical2 = logical) %>% 
    addSort(list(list(dir = "DESC", field = "date"))) %>% 
    head(10) %>% 
    collect() %>%
    pull("id")

  testthat::expect_equal(length(recordIds), 10)
  
  rcrds %>% rename_with(function(x) {paste0(x," haha")}, starts_with("_")) %>% collect()
  
})