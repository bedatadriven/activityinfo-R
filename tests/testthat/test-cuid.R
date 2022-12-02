testthat::test_that("base36() produces expected output", {
  testthat::expect_equal(activityinfo:::base36(3234234), "1xbju")
  testthat::expect_equal(activityinfo:::base36(1571690647614), "k20w154u")
})

testthat::test_that("Seed-dependent part of cuid() generated as expected", {
  testthat::expect_equal(withr::with_seed(100, {substr(activityinfo::cuid(),0,7)}), "caxhv7m")
})