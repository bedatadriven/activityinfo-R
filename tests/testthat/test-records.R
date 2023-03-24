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


testthat::test_that("Pretty field names are correct with deep and shallow reference fields in form trees", {
  # Create a country table
  countryData <- tibble("Code" = paste0(letters[1:2], letters[1:2], letters[1:2]), "Name" = paste0("Country ", 1:2))
  countrySchemaPackage <- createFormSchemaFromData(countryData, database$databaseId, label = "Country (from Form)", keyColumns = c("Name"), requiredColumns = c("Code", "Name"))
  uploadedCountryForm <- addForm(countrySchemaPackage$schema)
  countryFormId <- countrySchemaPackage$schema$id
  importTable(formId = countryFormId, data = countryData)
    
  countries <- getRecords(countryFormId)
  countryRecordIds <- countries %>% select(id = `_id`) %>% collect() %>% pull(id)
  
  # Create a district table with a country key field
  districtData <- tibble(Code = paste0("D", 1:10), "Name" = paste0("District ", 1:10))
  districtSchemaPackage <- createFormSchemaFromData(districtData, database$databaseId, label = "District (from form)", keyColumns = c("Name"), requiredColumns = c("Code", "Name"))
  districtSchema <- districtSchemaPackage$schema %>% 
    addFormField(
      referenceFieldSchema(label = "Country (from Field)", referencedFormId = countryFormId, key = TRUE)
    )
  uploadedDistrictForm <- addForm(districtSchema)
  districtFormId <- districtSchema$id
  
  # adding some countries to the district table
  districtData <- mutate(districtData, "Country (from Field)" = sample(countryRecordIds, size = 10, replace = TRUE))
  
  importTable(formId = districtFormId, data = districtData)
  
  districts <- getRecords(districtFormId)
  districtRecordIds <- districts %>% select(id = `_id`) %>% collect() %>% pull(id)
  
  # Create a case table that references districts
  caseData <- tibble("Case number"  = as.character(1:20), "A single select column" = rep(factor(paste0(1:5, "_stuff")), 4))
  caseSchemaPackage <- createFormSchemaFromData(caseData, database$databaseId, label = "Cases for testing pretty field names", keyColumns = c("Case number"), requiredColumns = c("Case number", "A single select column"))
  caseSchema <- caseSchemaPackage$schema %>% 
    addFormField(
      referenceFieldSchema(label = "District (from Field)", referencedFormId = districtFormId, key = TRUE)
    )
  uploadedCaseForm <- addForm(caseSchema)
  caseFormId <- caseSchema$id
  
  caseData <- mutate(caseData, "District (from Field)" = sample(districtRecordIds, size = 20, replace = TRUE))
  importTable(formId = caseFormId, caseData)

  cases <- getRecords(caseFormId, style = prettyColumnStyle(allReferenceFields = TRUE))
  
  
  
  # with a single reference field - it should give the label of the reference form
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
  
  importTable(formId = personFormId, data = newRef1Values, recordIdColumn = "personId")
  
  copiedForm <- rcrds %>% copySchema(label = "New reference table", databaseId = database$databaseId)
  
  addForm(copiedForm)
  
  importTable(formId = copiedForm$id, data = testData)
  
  getFormSchema(personFormId) %>%
    addFormField(
      referenceFieldSchema(label = "Ref 2", referencedFormId = uploadedForm$id),
      upload = TRUE
    )
  person <- getRecords(personFormId, prettyColumnStyle(allReferenceFields = TRUE))
  
  # with three reference fields (one the same) - it should give the label of the reference field
  getFormSchema(personFormId) %>%
    addFormField(
      referenceFieldSchema(label = "Ref 3", referencedFormId = uploadedForm$id),
      upload = TRUE
    )
  person <- getRecords(personFormId, prettyColumnStyle(allReferenceFields = TRUE))
  
  # filter on reference field - does not work
  filteredRow <- person %>% 
    select(starts_with("Ref"), `Respondent name`) %>% 
    filter(`Ref 1 Identifier number` == "107")
  
  testthat::expect_equal(
    object = filteredRow  %>% 
      collect() %>% 
      nrow(), 
    expected = 1)
  
  
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
  


  # filter
})