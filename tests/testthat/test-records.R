

testthat::test_that("add, update, and deleteRecord() works", {
  
  form <- addForm(formSchema(
    database$databaseId,
    label = "Test form for records",
    elements = list(textFieldSchema("Name", code = "NAME", key = TRUE),
                    quantityFieldSchema("Age", code = "AGE"))))
  
  ageField <- form$elements[[2]]
  
  alice <- addRecord(formId = form$id, fieldValues = list(NAME = "Alice", AGE = 30))
  bob <- addRecord(formId = form$id, fieldValues = list(NAME = "Bob", AGE = 24))
  
  updateRecord(form$id, alice$recordId, fieldValues = list(AGE = 25))
  
  alice <- getRecord(form$id, alice$recordId)
  assertthat::assert_that(alice$fields[[ageField$id]] == 25)
  
  # It shouldn't be possible to add a record with an existing id
  expect_error(
    alice2 <- addRecord(formId = form$id, fieldValues = list(NAME = "Alice Duplicate", AGE = 25), recordId = alice$recordId)
  )
  
  # It is possible to add a record with a user provided id
  eliza <- addRecord(formId = form$id, fieldValues = list(NAME = "Eliza", AGE = as.integer(format(Sys.Date(), "%Y")) - 1964), recordId = cuid())
  
  # It shouldn't be possible to update or delete non-existant records
  expect_error(updateRecord(form$id, recordId = "foobar", fieldValues = list(AGE = 25)))
  expect_error(deleteRecord(form$id, recordId = "foobar"))
  
  
  # Delete records should work
  deleteRecord(form$id, recordId = bob$recordId)
  expect_error(getRecord(form$id, recordId = bob$recordId))

})

testthat::test_that("getRecordHistory() works", {
  firstFormId <- getDatabaseResources(getDatabases(FALSE)[[1]]$databaseId)$id[[1]]
  firstRecordId <- (getRecords(form = firstFormId) |> collect() |> pull(`_id`))[[1]]
  recordHistory <- getRecordHistory(formId = firstFormId, recordId = firstRecordId)
  
  testthat::expect_true(nrow(recordHistory)>0)
  
  list_columns = c("user", "values")
  character_columns = c("formId", "recordId", "time", "subFieldId", "subFieldLabel", "subRecordKey", "changeType")
  numeric_columns = c("version")
  
  invisible(sapply(numeric_columns, function(x) {
    testthat::expect_true(is.numeric(recordHistory[[x]]))
  }))
  
  invisible(sapply(list_columns, function(x) {
    testthat::expect_identical(class(recordHistory[[x]]), "list")
  }))
  
  invisible(sapply(character_columns, function(x) {
    testthat::expect_identical(typeof(recordHistory[[x]]), "character")
  }))
  
  all_columns = c(list_columns, character_columns, numeric_columns)
  
  recordHistory2 <- getRecordHistory(formId = firstFormId, recordId = firstRecordId, asDataFrame = FALSE)
  recordHistoryNames <- names(recordHistory2$entries[[1]])
  
  testthat::expect_true(all(all_columns %in% recordHistoryNames))
  
  additionalColumns <- recordHistoryNames[!(recordHistoryNames %in% all_columns)]
  if (length(additionalColumns)>0) {
    message(sprintf("There are additional names in getRecordHistory() to be added as columns: '%s'", paste(additionalColumns, collapse = "', '")))
  }
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
  caseData <- tibble("Case number"  = sprintf("%02d", 1:20), "A single select column" = rep(factor(paste0(1:5, "_stuff")), 4))
  caseSchema <- createFormSchemaFromData(caseData, database$databaseId, label = "Cases for testing pretty field names", keyColumns = c("Case number"), requiredColumns = c("Case number", "A single select column"))
  caseSchema <- caseSchema %>% 
    addFormField(
      referenceFieldSchema(label = "District (from Field)", referencedFormId = districtFormId, key = TRUE)
    )
  uploadedCaseForm <- addForm(caseSchema)
  caseFormId <- caseSchema$id
  
  withr::with_seed(seed = 100, {
    caseData <- mutate(caseData, "District (from Field)" = sample(districtRecordIds, size = 20, replace = TRUE))
  })
  
  importRecords(formId = caseFormId, caseData)
  
  cases <- getRecords(caseFormId, style = prettyColumnStyle(allReferenceFields = TRUE, maxDepth = 10))
  
  caseDf <- getRecords(caseFormId, style = minimalColumnStyle(maxDepth = 10)) %>% arrange(`Case number`) %>% slice_head(n = 10) %>% collect() %>% as.data.frame()
  
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
  
  testthat::test_that('Case data has not changed after upload and collection', {
    for (i in c("Case number", "A single select column")) {
      testthat::expect_identical(
        caseDf[[i]],
        as.character(caseData[1:10,][[i]])
      )
    }
    
    caseData <- caseData %>% left_join(
      districts %>% collect(),
      by = c("District (from Field)"="_id")
    )
    
    testthat::expect_identical(
      caseDf[1:10,][["Country (from Form) Name"]],
      caseData[1:10,][["Country (from Field) Name"]]
    )
    
    testthat::expect_identical(
      caseDf[1:10,][["District (from form) Name"]],
      caseData[1:10,][["Name"]]
    )
    
  })
  
})

testthat::test_that("getRecords() works", {
  testData <- tibble(
    `Identifier number` = sprintf("%03d", 1:500), 
    "A single select column" = rep(factor(paste0(1:5, "_stuff")), 100), 
    "A logical column" = ((1:500)%%7==(1:500)%%3), 
    "A date column" = rep(seq(as.Date("2021-07-06"),as.Date("2021-07-25"),by = 1),25))
  schema <- createFormSchemaFromData(
    testData, 
    database$databaseId, 
    label = "getRecords() test form", 
    keyColumns = "Identifier number", 
    requiredColumns = "Identifier number")
  
  # add a sub-form
  
  childSubformId <- cuid()
  schema <- addFormField(schema, subformFieldSchema(
    code = "child",
    label = "Children",
    description = "Child records",
    subformId = childSubformId))

  childData <- tibble(
    `Child identifier number` = sprintf("%03d", 1:250),
    `parent` = sprintf("%03d", 2*(1:250)), 
    "Sub-form Content" = rep(factor(paste0(1:5, "_child_stuff")), 50))
  childSchema <- createFormSchemaFromData(
    childData, 
    database$databaseId, 
    label = "getRecords() child form", 
    keyColumns = "Child identifier number", 
    requiredColumns = "Child identifier number", 
    parentFormId = schema$id, 
    parentRecordIdColumn = "parent")
  childSchema$id <- childSubformId
  
  schemaView <- as.data.frame(schema)
  uploadedForm <- addForm(schema)
  uploadedChildForm <- addForm(childSchema)

  importRecords(formId = schema$id, data = testData)
  
  # get ActivityInfo cuids for the parent records after import
  parentRecords <- 
    getRecords(schema$id, style = prettyColumnStyle()) %>% 
    select(`_id`,`Identifier number`) %>%  collect() %>% 
    rename(parentRecordId = `_id`, parent = `Identifier number`)
  childData <- left_join(childData, parentRecords, by = 'parent')
  
  importRecords(formId = childSchema$id, data = childData, parentRecordIdColumn = 'parentRecordId')
  
  testthat::test_that('varNames works on a child form with reference records.', {
    childVarNames = varNames(childSchema$id, prettyColumnStyle(allReferenceFields = TRUE))
  })
  
  testthat::test_that('Can retrieve child form with all reference records using getRecords().', {
    childRecords <- getRecords(childSchema$id, style = prettyColumnStyle(allReferenceFields = TRUE))
    nChildRecords <- childRecords %>% collect() %>% nrow()
    testthat::expect_identical(nChildRecords, 250L)
  })

  rcrds <- getRecords(uploadedForm$id, style = prettyColumnStyle())
  rcrdsMin <- getRecords(uploadedForm$id, style = minimalColumnStyle())
  rcrdsMinDf <- rcrdsMin %>% arrange(`Identifier number`) %>% collect() %>% as.data.frame()
  
  testthat::test_that('getRecords returns the number of child records',{
    testthat::expect_equal(rcrdsMinDf %>% pull(Children) %>% sum(), 250L)
  })
  
  testthat::test_that('Form data has not changed after upload and collection', {
    for (i in names(testData)) {
      testthat::expect_identical(
        toupper(rcrdsMinDf[[i]]),
        toupper(as.character(testData[[i]]))
      )
    }
  })

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
    newSchema2 <-rcrds %>% select(-`_id`, -`_lastEditTime`) %>% extractSchemaFromFields(databaseId = "dbid", label = "new form")
    
    schemaToCompare <- schema
    schemaToCompare$label <- "new form"
    schemaToCompare$id <- newSchema$id
    schemaToCompare$databaseId <- "dbid"

    identicalForm(canonicalizeActivityInfoObject(schemaToCompare), canonicalizeActivityInfoObject(newSchema2))
    expectActivityInfoSnapshotCompare(newSchema, "extractSchemaFromFields")

    # no form schema elements to provide - expect warning
    testthat::expect_warning({
      rcrds %>% select(starts_with("_")) %>% extractSchemaFromFields(databaseId = "dbid", label = "new form")
    })
    
    testthat::test_that("It is possible to copy a form and upload the data to the new form", {
      copiedForm <- rcrds %>% 
        extractSchemaFromFields(label = "New reference table", databaseId = database$databaseId) %>%
        deleteFormField(label = "Children")
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
    
    names(newRef1Values) <- c("personId", person[["columns"]][["Ref 1"]])
    
    importRecords(formId = personFormId, data = newRef1Values, recordIdColumn = "personId")
    
    personMinimalRef <- getRecords(personFormId, minimalColumnStyle())
    personMinimalRefDf <- as.data.frame(personMinimalRef)
    
    testthat::expect_true("Ref 1 Identifier number" %in% colnames(personMinimalRef))
    testthat::expect_true("107" %in% personMinimalRefDf[["Ref 1 Identifier number"]])
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
    
    testthat::expect_true(
      all(
        paste0(c("Ref 1", "Ref 2", "Ref 3"), " Identifier number") %in% 
          names(filteredRowDf))
    )
    
    testthat::expect_equal(
      object = filteredRow  %>% 
        collect() %>% 
        nrow(), 
      expected = 1)
  })
  
})

testthat::test_that("getRecords() subform column count increases with maxDepth", {
  numLayers <- 5
  formIds <- character(numLayers)
  formSchemas <- vector("list", length = numLayers)
  formData <- vector("list", length = numLayers)
  
  # create ids up front for creation of the subform fields
  for (i in 1:numLayers) {
    formIds[[i]] <- cuid()
  }
  
  # Create the forms
  for (i in 1:numLayers) {
    formData[[i]] <- tibble::tibble(
      Name = paste("Form", i, "Record", 1:5)
    )
    label <- paste("Form", i)
    keyColumns <- "Name"
    requiredColumns <- "Name"
    databaseId <- database$databaseId
    parentFormId <- if (i == 1) NULL else formIds[[i-1]]
    
    schema <- createFormSchemaFromData(
      formData[[i]],
      databaseId = databaseId,
      label = label,
      keyColumns = keyColumns,
      requiredColumns = requiredColumns,
      parentFormId = parentFormId
    )
    schema$id <- formIds[[i]]
    
    if (i<numLayers) {
        schema <- addFormField(schema, subformFieldSchema(
          code = "child",
          label = "Children",
          description = "Child records",
          subformId = formIds[[i+1]]))
    }
    
    formSchemas[[i]] <- schema
  }
  
  # Upload the forms
  for (i in 1:numLayers) {
    addForm(schema=formSchemas[[i]])
  }
  
  # Import records into each form
  for (i in 1:numLayers) {
    if (i == 1) {
      # No parent for the first form
      importRecords(formId = formIds[i], data = formData[[i]])
    } else {
      # Get parent records
      parentRecords <- getRecords(formIds[i - 1]) %>%
        select(`_id`) %>%
        collect()
      parentRecordIds <- parentRecords$`_id`
      # Link records to parents
      formData[[i]] <- formData[[i]] %>%
        mutate(
          parentRecordId = rep(parentRecordIds, length.out = nrow(formData[[i]]))
        )
      importRecords(formId = formIds[i], data = formData[[i]], parentRecordIdColumn = "parentRecordId")
    }
  }
  
  # Test that the number of columns increases with maxDepth
  previousN <- 0
  for (depth in 1:numLayers) {
    colNames <- getRecords(formIds[[numLayers]], style = allColumnStyle(maxDepth = depth)) %>%
      colnames()
    n <- length(colNames)
    testthat::expect_gt(n, previousN)
    previousN <- n
  }
})


testthat::test_that("getRecords() column count increases with maxDepth in deep references and stops in cycles", {
  numLayers <- 5
  formIds <- character(numLayers)
  formSchemas <- vector("list", length = numLayers)
  formData <- vector("list", length = numLayers)
  
  # Create IDs upfront
  for (i in 1:numLayers) {
    formIds[[i]] <- cuid()
  }
  
  # Create the forms
  for (i in 1:numLayers) {
    formData[[i]] <- tibble::tibble(
      Name = paste("Form", i, "Record", 1:5)
    )
    label <- paste("Form", i)
    keyColumns <- "Name"
    requiredColumns <- "Name"
    databaseId <- database$databaseId
    
    schema <- createFormSchemaFromData(
      formData[[i]],
      databaseId = databaseId,
      label = label,
      keyColumns = keyColumns,
      requiredColumns = requiredColumns
    )
    schema$id <- formIds[[i]]
    
    if (i < numLayers) {
      # Add reference field to next form
      schema <- addFormField(schema, referenceFieldSchema(
        label = paste("Reference to Form", i + 1),
        referencedFormId = formIds[[i + 1]],
        key = FALSE
      ))
    }
    
    formSchemas[[i]] <- schema
  }
  
  # Upload the forms
  for (i in numLayers:1) {
    addForm(schema = formSchemas[[i]])
  }
  
  # Import records into each form in reverse order
  for (i in numLayers:1) {
    if (i < numLayers) {
      # Get records of the next form to reference
      nextFormRecords <- getRecords(formIds[[i + 1]]) %>%
        select(`_id`) %>%
        collect()
      nextFormRecordIds <- formData[[i]][[paste("Reference to Form", i + 1)]] <- nextFormRecords$`_id`
    }
    importRecords(formId = formIds[[i]], data = formData[[i]])
  }
  
  # First, save the number of columns at each depth without cycles
  columnCountsNoCycles <- integer(numLayers)
  for (depth in 1:numLayers) {
    colNames <- getRecords(formIds[[1]], style = allColumnStyle(maxDepth = depth)) %>%
      colnames()
    n <- length(colNames)
    columnCountsNoCycles[depth] <- n
  }
  
  # Now, add cyclic references
  # Form 1 references Form 1, creating a cycle
  formSchemas[[1]] <- addFormField(formSchemas[[1]], referenceFieldSchema(
    label = "Self reference",
    referencedFormId = formIds[[1]],
    key = FALSE
  ))
  updateFormSchema(formSchemas[[1]])
  
  # Update the data in Form 1 to include the new reference
  form1Records <- getRecords(formIds[[1]]) %>%
    select(`_id`) %>%
    collect()
  formData[[1]][["Self reference"]] <- form1Records$`_id`
  formData[[1]][["id"]] <- form1Records$`_id`
  importRecords(formId = formIds[[1]], data = formData[[1]], recordIdColumn = "id")
  
  
  # Form 3 references Form 1, creating a cycle
  formSchemas[[3]] <- addFormField(formSchemas[[3]], referenceFieldSchema(
    label = "Reference to Form 1",
    referencedFormId = formIds[[1]],
    key = FALSE
  ))
  updateFormSchema(formSchemas[[3]])
  
  # Update the data in Form 3 to include the new reference
  form3Records <- getRecords(formIds[[3]]) %>%
    select(`_id`) %>%
    collect()
  formData[[3]][["Reference to Form 1"]] <- form1Records$`_id`
  formData[[3]][["id"]] <- form3Records$`_id`
  importRecords(formId = formIds[[3]], data = formData[[3]], recordIdColumn = "id")
  
  # Now, save the number of columns at each depth with cycles
  columnCountsWithCycles <- integer(numLayers)
  for (depth in 1:numLayers) {
    colNames <- getRecords(formIds[[1]], style = allColumnStyle(maxDepth = depth)) %>%
      colnames()
    n <- length(colNames)
    columnCountsWithCycles[depth] <- n
  }
  
  # Compare the number of columns at each depth
  for (depth in 1:numLayers) {
    if (depth >= 3) {
      # Added one new field in Form 3
      expectedIncrease <- 2
    } else {
      # Added one new field in Form 1
      expectedIncrease <- 1
    }
    expectedN <- columnCountsNoCycles[depth] + expectedIncrease
    actualN <- columnCountsWithCycles[depth]
    testthat::expect_equal(actualN, expectedN)
  }
  
  # Check that the number of columns does not increase after the last form
  # Compare the number of columns at each depth
  for (depth in numLayers+1:numLayers+3) {
    colNames <- getRecords(formIds[[1]], style = allColumnStyle(maxDepth = depth)) %>%
      colnames()
    n <- length(colNames)
    testthat::expect_equal(n, expectedN)
  }
})
