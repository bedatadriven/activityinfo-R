testthat::test_that("getDatabases() works", {

})

testthat::test_that("getDatabaseSchema() works", {
  
})


testthat::test_that("getDatabaseTree() works", {
  
})

testthat::test_that("getDatabaseUsers() works", {
  
})

testthat::test_that("getDatabaseUsers() works", {
  
})

testthat::test_that("getDatabaseUser() works", {
  
})

# strangely different pattern here -- returns on failure instead of signalling an error -- no other functions do this and I think it will produce some bad practice - we should deprecate this
testthat::test_that("addDatabaseUser() works", {
  
})

# this one should return like all other functions
testthat::test_that("getDatabaseUser2() returns same as old getDatabaseUser()", {
  # need new parameters
  # newDatabaseUser <- addDatabaseUser(databaseId = database$databaseId, email = "test@example.com", name = "Test database user", locale = "en", roleId = "readonly")
  # responseOld <- getDatabaseUser(databaseId = database$databaseId)
  # response <- getDatabaseUser2(databaseId = database$databaseId)
  # 
  # testthat::expect_identical(responseOld, response)
})


testthat::test_that("deleteDatabaseUser() works", {
  
})


testthat::test_that("updateUserRole() works", {
  
})

testthat::test_that("roleAssignment() works", {
  
})

testthat::test_that("permissions() helper works", {
  
})

testthat::test_that("updateGrant() works", {
  
})

testthat::test_that("updateRole() works", {
  
})

