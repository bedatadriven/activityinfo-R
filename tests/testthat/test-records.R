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


testthat::test_that("getRecords() pretty field names are correct with deep reference fields in form trees", {
  # Create a country table
  countryData <- tibble("Code" = paste0(letters[1:2], letters[1:2], letters[1:2]), "Name" = paste0("Country ", 1:2))
  countrySchema <- createFormSchemaFromData(countryData, database$databaseId, label = "Country (from Form)", keyColumns = c("Name"), requiredColumns = c("Code", "Name"), codes = c("code", "name"))
  uploadedCountryForm <- addForm(countrySchema)
  countryFormId <- countrySchema$id
  importRecords(formId = countryFormId, data = countryData)
  
  countries <- getRecords(countryFormId)
  countryRecordIds <- countries %>% select(id = `_id`) %>% collect() %>% pull(id)
  
  # Create a district table with a country key field
  districtData <- tibble(Code = paste0("D", 1:10), "Name" = paste0("District ", 1:10))
  districtSchema <- createFormSchemaFromData(districtData, database$databaseId, label = "District (from form)", keyColumns = c("Name"), requiredColumns = c("Code", "Name"), codes = c("code", "name"))
  districtSchema <- districtSchema %>% 
    addFormField(
      referenceFieldSchema(label = "Country (from Field)", referencedFormId = countryFormId, key = TRUE)
    )
  uploadedDistrictForm <- addForm(districtSchema)
  districtFormId <- districtSchema$id
  
  # adding some countries to the district table
  withr::with_seed(seed = 100, {
    districtData <- mutate(districtData, "Country (from Field)" = sample(countryRecordIds, size = 10, replace = TRUE))
  })
  
  importRecords(formId = districtFormId, data = districtData)
  
  districts <- getRecords(districtFormId)
  districtRecordIds <- districts %>% select(id = `_id`) %>% collect() %>% pull(id)
  
  # Create a case table that references districts
  caseData <- tibble("Case number"  = as.character(1:20), "A single select column" = rep(factor(paste0(1:5, "_stuff")), 4))
  caseSchema <- createFormSchemaFromData(caseData, database$databaseId, label = "Cases for testing pretty field names", keyColumns = c("Case number"), requiredColumns = c("Case number", "A single select column"))
  caseSchema <- caseSchemaPackage %>% 
    addFormField(
      referenceFieldSchema(label = "District (from Field)", referencedFormId = districtFormId, key = TRUE)
    )
  uploadedCaseForm <- addForm(caseSchema)
  caseFormId <- caseSchema$id
  
  withr::with_seed(seed = 100, {
    caseData <- mutate(caseData, "District (from Field)" = sample(districtRecordIds, size = 20, replace = TRUE))
  })
  
  importRecords(formId = caseFormId, caseData)
  
  cases <- getRecords(caseFormId, style = prettyColumnStyle(allReferenceFields = TRUE))
  
  caseDf <- getRecords(caseFormId, style = minimalColumnStyle()) %>% slice_head(n = 10) %>% collect() %>% as.data.frame()
  
  testthat::test_that("No errors are thrown when filtering on a variable name that is also found up the tree", {
    testthat::expect_no_error({
      getRecords(caseFormId) %>% filter(`District (from form) Name` == "District 10")
    })
  })
  
  testthat::test_that("In extractSchemaFromFields(), form with duplicate codes from reference tables will be fixed with make.names", {
    testthat::expect_warning({
      testthat::expect_warning({
        cases %>% select(contains("name")) %>% extractSchemaFromFields("dbId", "Test")
      }, regexp = "Recoding duplicate code", )
    }, regexp = "duplicated field labels")
  })
  
  testthat::test_that("In extractSchemaFromFields(), form with has duplicate labels can be fixed with useColumnNames = TRUE", {
    testthat::expect_no_warning({
      testthat::expect_warning({
        cases %>% select(contains("name")) %>% extractSchemaFromFields("dbId", "Test", useColumnNames = TRUE)
      }, regexp = "Recoding duplicate code")
    })
  })
  
  
  testthat::expect_snapshot(caseDf)
})

testthat::test_that("getRecords() works", {
  testData <- tibble(`Identifier number` = as.character(1:500), "A single select column" = rep(factor(paste0(1:5, "_stuff")), 100), "A logical column" = ((1:500)%%7==(1:500)%%3), "A date column" = rep(seq(as.Date("2021-07-06"),as.Date("2021-07-25"),by = 1),25))
  schema <- createFormSchemaFromData(testData, database$databaseId, label = "getRecords() test form", keyColumns = "Identifier number", requiredColumns = "Identifier number")
  schemaView <- as.data.frame(schema)
  uploadedForm <- addForm(schema)
  importRecords(formId = schema$id, data = testData)
  
  rcrds <- getRecords(uploadedForm$id, style = prettyColumnStyle())
  
  rcrdsMin <- getRecords(uploadedForm$id, style = minimalColumnStyle())
  
  rcrdsMinDf <- rcrdsMin %>% collect %>% as.data.frame()
  
  testthat::expect_snapshot(rcrdsMinDf)
  
  dfA <- rcrds %>% 
    addFilter('[A logical column] == "True"') %>% 
    addSort(list(list(dir = "ASC", field = "_id"))) %>%
    adjustWindow(offSet = 0L, limit = 10L) %>% collect()
  dfB <- rcrds %>% 
    filter(`A logical column` == "True") %>% 
    addSort(list(list(dir = "ASC", field = "_id"))) %>%
    slice_head(n = 10) %>% collect()
  
  attr(dfA, "remoteRecords") <- NULL
  attr(dfB, "remoteRecords") <- NULL
  
  testthat::expect_identical(dfA,dfB)
  
  dfC <- rcrds %>% 
    filter(`A logical column` == "True") %>% 
    arrange(`_id`) %>%
    slice_head(n = 10) %>% collect()
  
  attr(dfC, "remoteRecords") <- NULL
  
  attr(dfB, "rows") <- NULL
  attr(dfC, "rows") <- NULL
  
  testthat::expect_identical(dfB,dfC)
  
  testthat::test_that("The data is collected when more than one column is sorted in arrange().", {
    testthat::expect_warning({
      rcrds %>% 
        filter(`A logical column` == "True") %>% 
        arrange(`_id`, `A logical column`) %>%
        slice_head(n = 10) %>% collect()
    })
  })
  
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
  
  # filters will work even if the column is renamed in a lazy remote records object
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
  
  testthat::test_that("Copying of schemas with extractSchemaFromFields()", {
    newSchema <- rcrds %>% select(id = `Identifier number`) %>% extractSchemaFromFields(databaseId = "dbid", label = "new form")
    
    expectActivityInfoSnapshot(newSchema)
    
    # no form schema elements to provide - expect warning
    testthat::expect_warning({
      rcrds %>% select(starts_with("_")) %>% extractSchemaFromFields(databaseId = "dbid", label = "new form")
    })
    
    testthat::test_that("It is possible to copy a form and upload the data to the new form", {
      copiedForm <- rcrds %>% extractSchemaFromFields(label = "New reference table", databaseId = database$databaseId)
      addForm(copiedForm)
      importRecords(formId = copiedForm$id, data = testData)
    })
    
  })  
  
  testthat::test_that("head() works", {
    recordIds <- rcrds %>% 
      select(id = `_id`, date = `A date column`, logical = `A logical column`) %>%
      filter(logical == "True") %>% 
      addSort(list(list(dir = "DESC", field = "date"))) %>% 
      head(10) %>% 
      collect() %>%
      pull("id")
    
    testthat::expect_equal(length(recordIds), 10)
  })
  
  testthat::test_that("rename_with() verb works", {
    renameWith <- rcrds %>% rename_with(function(x) {paste0(x," haha")}, starts_with("_")) %>% collect()
    
    testthat::expect_true(c("_id haha") %in% colnames(renameWith))
  })
  
  testthat::test_that("Reference field with shallow reference table should provide field based names", {
    getFormSchema(personFormId) %>%
      addFormField(
        referenceFieldSchema(label = "Ref 1", referencedFormId = uploadedForm$id),
        upload = TRUE
      )
    
    person <- getRecords(personFormId, prettyColumnStyle(allReferenceFields = TRUE))
    personIds <- person %>% select(id = `_id`) %>% collect() %>% pull(id)
    
    newRef1Values <- tibble(personId = personIds, values = c(NA, "107"))
    
    newRef1Values <- newRef1Values %>% 
      left_join(
        rcrds %>% 
          select(refId = `_id`, values = `Identifier number`) %>% 
          collect(),
        by = "values"
      ) %>% 
      select(-values)
    
    names(newRef1Values) <- c("personId", person$columns[["Ref 1"]])
    
    importRecords(formId = personFormId, data = newRef1Values, recordIdColumn = "personId")
    
    personMinimalRef <- getRecords(personFormId, minimalColumnStyle())
    personMinimalRefDf <- as.data.frame(personMinimalRef)
    
    testthat::expect_true("Ref 1 Identifier number" %in% colnames(personMinimalRef))
    testthat::expect_snapshot(personMinimalRefDf)
  })
  
  getFormSchema(personFormId) %>%
    addFormField(
      referenceFieldSchema(label = "Ref 2", referencedFormId = uploadedForm$id),
      upload = TRUE
    )
  
  # with three reference fields (one the same) - it should give the label of the reference field
  getFormSchema(personFormId) %>%
    addFormField(
      referenceFieldSchema(label = "Ref 3", referencedFormId = uploadedForm$id),
      upload = TRUE
    )
  person <- getRecords(personFormId, prettyColumnStyle(allReferenceFields = TRUE))
  personMinRef <- getRecords(personFormId, minimalColumnStyle())
  
  testthat::test_that("filter on reference field works", {
    filteredRow <- personMinRef %>% 
      select(starts_with("Ref"), `Respondent name`) %>% 
      filter(`Ref 1 Identifier number` == "107")
    
    filteredRowDf <- as.data.frame(filteredRow)
    
    testthat::expect_snapshot(filteredRowDf)
    
    testthat::expect_equal(
      object = filteredRow  %>% 
        collect() %>% 
        nrow(), 
      expected = 1)
  })
  
  
})
