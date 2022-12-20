testthat::test_that("Rmd outputs as expected", {
  testthat::expect_no_warning(
    testthat::expect_no_error(
      rmarkdown::render(testthat::test_path("ext/TestMessages.Rmd"))
    )
  )
  testthat::expect_snapshot_file(testthat::test_path("ext/TestMessages.html"))
})
