testthat::test_that("Snapshots work with data frames", {
  expectActivityInfoSnapshotCompare(data.frame(x = 1:26), snapshotName = "setup-dataframe-snapshot", allowed_new_fields = TRUE)
  
  suppressMessages({
    testthat::expect_message({
      expectActivityInfoSnapshotCompare(data.frame(x = 1:26, y = letters), snapshotName = "setup-dataframe-snapshot", allowed_new_fields = TRUE)
    }, "Additional fields")
    testthat::expect_failure({
      expectActivityInfoSnapshotCompare(data.frame(y = letters), snapshotName = "setup-dataframe-snapshot", allowed_new_fields = TRUE)
    })    
  })

})
