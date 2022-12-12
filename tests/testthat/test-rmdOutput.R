testthat::test_that("Rmd outputs as expected", {
  testthat::expect_no_warning(
    testthat::expect_no_error(
      rmarkdown::render(here::here("tests/testthat/ext/TestMessages.Rmd"))
    )
  )
  testthat::expect_snapshot_file(here::here("tests/testthat/ext/TestMessages.html"))
})
