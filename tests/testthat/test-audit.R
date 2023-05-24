testthat::test_that("queryAuditLog() works", {

  results <- queryAuditLog(database$databaseId, limit = 1000)

  testthat::expect_gte(nrow(results), 15)
  testthat::expect_true(all(c("id", "time", "recordRef", "version", "databaseUserId", "description", "type", "deleted", "reverted", "user.id", "user.name", "user.email") %in% names(results)))

})

testthat::test_that("naForNull() works", {

})
