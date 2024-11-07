testthat::test_that("Snapshots work with data frames", {
  expectActivityInfoSnapshotCompare(data.frame(x = 1:26), snapshotName = "setup-dataframe-snapshot", allowed_new_fields = TRUE)
  expectActivityInfoSnapshotCompare(data.frame(x = 1:26, y = letters), snapshotName = "setup-dataframe-snapshot", allowed_new_fields = TRUE)
})
