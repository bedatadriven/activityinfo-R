testthat::test_that("checkForError() send stop condition on http errors", {
  testthat::expect_error(checkForError(GET("http://httpbin.org/status/404")), class = "http_404")
  testthat::expect_error(checkForError(GET("http://httpbin.org/status/505")), class = "activityinfo_api")
  testthat::expect_error(checkForError(GET("http://httpbin.org/status/204"), requireStatus = c(200, 206)), class = "activityinfo_api")
  testthat::expect_no_error(checkForError(GET("http://httpbin.org/status/206"), requireStatus = c(200, 206)), class = "activityinfo_api")
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
  testthat::expect_no_error(schema <- getResource(sprintf("form/%s/schema", personFormId)))
  testthat::expect_equal(schema$id, personFormId)
  testthat::expect_error(getResource("form/INVALID/schema"), class = "activityinfo_api")
})

testthat::test_that("postResource() is working", {

})

testthat::test_that("putResource() is working", {

})
