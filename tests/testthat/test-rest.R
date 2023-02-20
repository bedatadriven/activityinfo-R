testthat::test_that("checkForError() send stop condition on http errors", {
  testthat::expect_error(checkForError(GET("http://httpbin.org/status/404"), task = "Test 404"), class = "http_404")
  testthat::expect_error(checkForError(GET("http://httpbin.org/status/505"), task = "Test 505"), class = "activityinfo_api")
  testthat::expect_error(checkForError(GET("http://httpbin.org/status/204"), task = "Test 204", requireStatus = c(200, 206)), class = "activityinfo_api")
  testthat::expect_no_error(checkForError(GET("http://httpbin.org/status/206"), task = "Test 206 no error", requireStatus = c(200, 206)), class = "activityinfo_api")
})

testthat::test_that("activityInfoAPICondition() returns correct conditions", {
  condition1 <- activityInfoAPICondition(result = GET("http://httpbin.org/status/200"), task = "GET 200")
  testthat::expect_true(all(c("activityinfo_api", "http_200", "message", "condition") %in% class(condition1)))
  testthat::expect_vector(condition1$message, ptype = character(0))

  # Force an error condition
  condition2 <- activityInfoAPICondition(result = GET("http://httpbin.org/status/204"), type = "error", task = "GET 204 No Content")
  testthat::expect_true(all(c("activityinfo_api", "http_204", "error", "condition") %in% class(condition2)))

  # Force a warning condition
  condition3 <- activityInfoAPICondition(result = GET("http://httpbin.org/status/206"), type = "warning", task = "GET 206 Partial Content")
  testthat::expect_true(all(c("activityinfo_api", "http_206", "warning", "condition") %in% class(condition3)))

  # Check task includes URL
  condition4 <- activityInfoAPICondition(result = GET("http://httpbin.org/status/206"), type = "warning")
  testthat::expect_true(grepl("http://httpbin.org/status/206", condition4$message, fixed = TRUE))

  # Check return value
  condition5 <- activityInfoAPICondition(result = GET("http://httpbin.org/status/206"))
  testthat::expect_true(grepl("http://httpbin.org/status/206", condition5$message, fixed = TRUE))
  testthat::expect_true(grepl("GET", condition5$message, fixed = TRUE, ignore.case = FALSE))

  condition6 <- activityInfoAPICondition(result = GET("http://httpbin.org/status/200"), task = "Getting some resource")
  testthat::expect_true(grepl("Getting some resource", condition6$message, fixed = TRUE))
  testthat::expect_false(grepl("http://httpbin.org/status/206", condition6$message, fixed = TRUE))
})

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
