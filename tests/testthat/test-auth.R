
testthat::test_that("Package options are set correctly", {
  testthat::expect_false(getOption("activityinfo.verbose.requests"))
  testthat::expect_false(getOption("activityinfo.verbose.tasks"))
})
