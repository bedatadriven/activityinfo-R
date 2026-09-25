# Databases may or may not have an individual owner, depending on the server
# version and when the database was created. These tests use fixed server
# responses so that both cases are always tested, whatever the test server.

databasesJson <- '[
  {"databaseId":"cowner1","label":"With owner","description":"","ownerId":"5148353961132032","billingAccountId":5308023665328128,"suspended":false,"publishedTemplate":false,"languages":[]},
  {"databaseId":"cowner2","label":"Without owner","description":"","ownerId":null,"billingAccountId":5308023665328128,"suspended":false,"publishedTemplate":false,"languages":[]}
]'

billingDatabasesJson <- '[
  {"databaseId":"cowner1","label":"With owner","description":"","owner":{"id":"5148353961132032","name":"Bob","email":"bob@example.com"},"formCount":1,"userCount":2,"basicUserCount":0,"recordCount":3,"lastRecordUpdate":"2026-01-01","billingAccountId":5308023665328128,"suspended":false,"publishedTemplate":false},
  {"databaseId":"cowner2","label":"Without owner","description":"","owner":null,"formCount":0,"userCount":0,"basicUserCount":0,"recordCount":0,"lastRecordUpdate":"1970-01-01","billingAccountId":5308023665328128,"suspended":false,"publishedTemplate":false}
]'

mockDatabases <- function(json, env = parent.frame()) {
  databases <- activityinfo:::fromActivityInfoJson(json)
  testthat::local_mocked_bindings(getResource = function(...) databases, .env = env)
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
})
