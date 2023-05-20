
testthat::test_that("getResource() is working", {
  testthat::expect_no_error(schema <- getResource(sprintf("form/%s/schema", personFormId), task = "Testing getResource with a form schema."))
  testthat::expect_equal(schema$id, personFormId)
  testthat::expect_error(getResource("form/INVALID/schema", task = "Testing getResource with an invalid form id."), class = "activityinfo_api")
})

testthat::test_that("Messages are being regulated by the package options during HTTP requests", {
  withr::with_options(list(activityinfo.verbose.requests = TRUE, activityinfo.verbose.tasks = TRUE), {
    testthat::expect_message({
      testthat::expect_message({
        getDatabaseTree(databaseId = database$databaseId)
      }, regexp = "Sending GET request")
    }, class = "activityinfo_api")
     # testthat::expect_message({
     #   testthat::expect_message({
     #   }, regexp = "Sending POST request")
     # }, class = "activityinfo_api")
     # testthat::expect_message({
     #   testthat::expect_message({
     #   }, regexp = "Sending PUT request")
     # }, class = "activityinfo_api")
  })
  
  withr::with_options(list(activityinfo.verbose.requests = TRUE, activityinfo.verbose.tasks = FALSE), {
    testthat::expect_message({
      getDatabaseTree(databaseId = database$databaseId)
    }, regexp = "Sending GET request")
  })
  
  withr::with_options(list(activityinfo.verbose.requests = FALSE, activityinfo.verbose.tasks = TRUE), {
    testthat::expect_message({
      getDatabaseTree(databaseId = database$databaseId)
    }, class = "activityinfo_api")
  })
  
  withr::with_options(list(activityinfo.verbose.requests = FALSE, activityinfo.verbose.tasks = FALSE), {
    testthat::expect_no_message({
      getDatabaseTree(databaseId = database$databaseId)
    })
  })
})

testthat::test_that("deleteResource() is working", {
  
})


testthat::test_that("postResource() is working", {

})

testthat::test_that("putResource() is working", {

})
