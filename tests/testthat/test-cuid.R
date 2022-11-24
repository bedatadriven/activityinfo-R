test_that("cuid generated", {
  testthat::expect_equal(withr::with_seed(100, {substr(cuid(),0,7)}), "caxhv7m")
})