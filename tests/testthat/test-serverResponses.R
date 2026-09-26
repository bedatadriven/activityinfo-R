# Databases may or may not have an individual owner, depending on the server
# version and when the database was created. These tests use fixed server
# responses so that both cases are always tested, whatever the test server.

databasesJson <- '[
  {"databaseId":"cowner1","label":"With owner","description":"","ownerId":"5148353961132032","billingAccountId":5308023665328128,"suspended":false,"publishedTemplate":false,"languages":[]},
  {"databaseId":"cowner2","label":"Without owner","description":null,"ownerId":null,"billingAccountId":5308023665328128,"suspended":false,"publishedTemplate":false,"languages":[]}
]'

billingDatabasesJson <- '[
  {"databaseId":"cowner1","label":"With owner","description":"","owner":{"id":"5148353961132032","name":"Bob","email":"bob@example.com"},"formCount":1,"userCount":2,"basicUserCount":0,"recordCount":3,"lastRecordUpdate":"2026-01-01","billingAccountId":5308023665328128,"suspended":false,"publishedTemplate":false},
  {"databaseId":"cowner2","label":"Without owner","description":null,"owner":null,"formCount":0,"userCount":0,"basicUserCount":0,"recordCount":0,"lastRecordUpdate":null,"billingAccountId":5308023665328128,"suspended":false,"publishedTemplate":false}
]'

mockResponse <- function(fn, json, env = parent.frame()) {
  response <- activityinfo:::fromActivityInfoJson(json)
  mock <- list(function(...) response)
  names(mock) <- fn
  do.call(testthat::local_mocked_bindings, c(mock, list(.env = env)))
}

mockDatabases <- function(json, env = parent.frame()) {
  mockResponse("getResource", json, env)
}

testthat::test_that("getDatabases() works with and without database owners", {
  mockDatabases(databasesJson)

  df <- getDatabases()
  testthat::expect_identical(df$databaseId, c("cowner1", "cowner2"))
  testthat::expect_identical(df$ownerId, c("5148353961132032", NA_character_))

  dbList <- getDatabases(asDataFrame = FALSE)
  testthat::expect_identical(dbList[[1]]$ownerId, "5148353961132032")
  testthat::expect_identical(dbList[[2]]$ownerId, NA_character_)
})

testthat::test_that("getDatabases() works when no database has an owner", {
  mockDatabases(sub('"ownerId":"5148353961132032"', '"ownerId":null', databasesJson))

  df <- getDatabases()
  testthat::expect_identical(nrow(df), 2L)
  testthat::expect_identical(df$ownerId, c(NA_character_, NA_character_))
})

testthat::test_that("getBillingAccountDatabases() works with and without database owners", {
  mockDatabases(billingDatabasesJson)

  df <- getBillingAccountDatabases("5308023665328128")
  testthat::expect_identical(df$databaseId, c("cowner1", "cowner2"))
  testthat::expect_identical(df$ownerId, c("5148353961132032", NA_character_))
  testthat::expect_identical(df$ownerName, c("Bob", NA_character_))
  testthat::expect_identical(df$ownerEmail, c("bob@example.com", NA_character_))
  testthat::expect_identical(df$description, c(NA_character_, NA_character_))
  testthat::expect_identical(df$lastRecordUpdate, c("2026-01-01", NA_character_))
})

testthat::test_that("getBillingAccountDatabases() columns keep their type when all values are null", {
  mockDatabases(gsub('"lastRecordUpdate":"2026-01-01"', '"lastRecordUpdate":null', billingDatabasesJson))
  
  df <- getBillingAccountDatabases("5308023665328128")
  testthat::expect_identical(df$lastRecordUpdate, c(NA_character_, NA_character_))
})

auditLogJson <- '{
  "events": [
    {"id":"e1","time":1790376900768,"formId":"cform1","description":"No resource types","type":"FORM","resourceTypes":[],"resourceId":"","user":{"id":"1","name":"Bob","email":"bob@example.com"}},
    {"id":"e2","time":1790376900769,"formId":"cform1","description":"One resource type","type":"FORM","resourceTypes":["FORM"],"resourceId":"cform1","user":{"id":"1","name":"Bob","email":"bob@example.com"}},
    {"id":"e3","time":1790376900770,"formId":"cform1","description":"Two resource types","type":"FORM","resourceTypes":["FORM","ROLE"],"resourceId":"cform1","user":null}
  ],
  "moreEvents": false,
  "startTime": 1790376900000,
  "endTime": 1790376901000
}'

testthat::test_that("queryAuditLog() works with events with none or several resource types", {
  mockResponse("postResource", auditLogJson)
  
  events <- queryAuditLog("cdb1", after = as.POSIXct(1790376800, origin = "1970-01-01"))
  testthat::expect_identical(nrow(events), 3L)
  testthat::expect_identical(events$resourceTypes, c(NA, "FORM", "FORM,ROLE"))
  testthat::expect_identical(events$user.name, c("Bob", "Bob", NA))
})
