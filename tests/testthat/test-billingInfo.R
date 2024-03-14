testthat::test_that("getDatabaseBillingAccount returns the same as getBillingAccount", {
  testthat::expect_identical(getDatabaseBillingAccount(database$databaseId), getBillingAccount(database$billingAccountId))
})

testthat::test_that("getBillingAccount without billingAccountId throws error", {
  testthat::expect_error(getBillingAccount(), regexp = "A billingAccountId must be provided")
  testthat::expect_error(getBillingAccount("invalid"), regexp = "404")
})

testthat::test_that("getDatabaseBillingAccount with valid input returns correct output", {
  returnedDatabaseBillingAccount <- getDatabaseBillingAccount(databaseId = database$databaseId)
  testthat::expect_true("tbl_df" %in% class(returnedDatabaseBillingAccount))
  testthat::expect_identical(database$billingAccountId, returnedDatabaseBillingAccount[["id"]])
  
  testthat::expect_true(nrow(returnedDatabaseBillingAccount)==1)
  
  logical_columns <- c("trial", "staleCounts", "automaticCollection")
  numeric_columns <- c("expirationTime", "userLimit", "userCount", "fullUserCount", "basicUserCount", "databaseCount", "expectedPaymentTime")
  character_columns <- c("id", "name", "status", "planName")
  
  invisible(sapply(logical_columns, function(x) {
    testthat::expect_identical(typeof(returnedDatabaseBillingAccount[[x]]), "logical")
  }))
  
  invisible(sapply(numeric_columns, function(x) {
    testthat::expect_true(is.numeric(returnedDatabaseBillingAccount[[x]]))
  }))
  
  invisible(sapply(character_columns, function(x) {
    testthat::expect_identical(typeof(returnedDatabaseBillingAccount[[x]]), "character")
  }))
  
  returnedDatabaseBillingAccount2 <- getDatabaseBillingAccount(databaseId = database$databaseId, asDataFrame = FALSE)
  testthat::expect_identical(class(returnedDatabaseBillingAccount2), "list")
  testthat::expect_identical(returnedDatabaseBillingAccount$id, returnedDatabaseBillingAccount2$id)
  
  additionalColumns <- names(returnedDatabaseBillingAccount2)[!(names(returnedDatabaseBillingAccount2) %in% c(logical_columns,numeric_columns,character_columns))]
  if (length(additionalColumns)>0) {
    message(sprintf("There are additional names in getDatabaseBillingAccount() to be added as columns: '%s'", paste(additionalColumns, collapse = "', '")))
  }
  
})

testthat::test_that("getDatabaseBillingAccount without databaseId throws error", {
  testthat::expect_error(getDatabaseBillingAccount(), regexp = "A databaseId must be provided")
  testthat::expect_error(getDatabaseBillingAccount("invalid"), regexp = "404")
})

testthat::test_that("getBillingAccountDatabases with valid input returns correct output", {
  billingAccountDatabases <- getBillingAccountDatabases(database$billingAccountId)
  testthat::expect_true(nrow(billingAccountDatabases) > 1)
  testthat::expect_true("tbl_df" %in% class(billingAccountDatabases))
  
  logical_columns <- c("suspended", "publishedTemplate")
  numeric_columns <- c("formCount", "userCount", "basicUserCount", "recordCount")
  character_columns <- c("databaseId", "label", "description", "ownerId", "ownerName", "ownerEmail", "lastRecordUpdate", "billingAccountId")
  
  invisible(sapply(logical_columns, function(x) {
    testthat::expect_identical(typeof(billingAccountDatabases[[x]]), "logical")
  }))
  
  invisible(sapply(numeric_columns, function(x) {
    testthat::expect_true(is.numeric(billingAccountDatabases[[x]]))
  }))
  
  invisible(sapply(character_columns, function(x) {
    testthat::expect_identical(typeof(billingAccountDatabases[[x]]), "character")
  }))
  
  billingAccountDatabases2 <- getBillingAccountDatabases(database$billingAccountId, asDataFrame = FALSE)
  
  testthat::expect_identical(class(billingAccountDatabases2), "list")
  testthat::expect_identical(
    billingAccountDatabases$databaseId, 
    sapply(billingAccountDatabases2, function(x) {
      x$databaseId
    }))
  
  withoutOwner <- billingAccountDatabases2[[1]]
  withoutOwner$owner <- NULL
  billingAccountDatabasesNames <- names(withoutOwner)

  additionalColumns <- billingAccountDatabasesNames[!(billingAccountDatabasesNames %in% c(logical_columns,numeric_columns,character_columns))]
  if (length(additionalColumns)>0) {
    message(sprintf("There are additional names in getBillingAccountDatabases() to be added as columns: '%s'", paste(additionalColumns, collapse = "', '")))
  }

})

testthat::test_that("getBillingAccountDatabases without billingAccountId throws error", {
  testthat::expect_error(getBillingAccountDatabases(), regexp = "A billingAccountId must be provided")
  testthat::expect_error(getBillingAccountDatabases("invalid"), regexp = "404")
})

testthat::test_that("getBillingAccountDomains with valid input returns correct output", {
  billingAccountDomains <- getBillingAccountDomains(database$billingAccountId)
  testthat::expect_identical(class(billingAccountDomains), "list")
})

testthat::test_that("getBillingAccountDomains without billingAccountId throws error", {
  testthat::expect_error(getBillingAccountDomains(), regexp = "A billingAccountId must be provided")
  testthat::expect_error(getBillingAccountDomains("invalid"), regexp = "404")
})

testthat::test_that("getBillingAccountUsers with valid input returns correct output", {
  billingAccountUsers <- getBillingAccountUsers(database$billingAccountId)
  testthat::expect_true("tbl_df" %in% class(billingAccountUsers))
  testthat::expect_true(nrow(billingAccountUsers)>0)
  
  invisible(sapply(names(billingAccountUsers), function(x) {
    testthat::expect_identical(typeof(billingAccountUsers[[x]]), "character")
  }))

  billingAccountUsers2 <- getBillingAccountUsers(database$billingAccountId, asDataFrame = FALSE)
  billingAccountUsersNames <- names(billingAccountUsers2[[1]])
  
  additionalColumns <- billingAccountUsersNames[!(billingAccountUsersNames %in% names(billingAccountUsers))]
  if (length(additionalColumns)>0) {
    message(sprintf("There are additional names in getBillingAccountUsers() to be added as columns: '%s'", paste(additionalColumns, collapse = "', '")))
  }
  
})

testthat::test_that("getBillingAccountUsers without billingAccountId throws error", {
  testthat::expect_error(getBillingAccountUsers(), regexp = "A billingAccountId must be provided")
  testthat::expect_error(getBillingAccountUsers("invalid"), regexp = "404")
})

testthat::test_that("getBillingAccountDatabaseUsers with valid inputs returns correct output", {
  testthat::expect_no_error(
    billingAccountDatabaseUsers <- getBillingAccountDatabaseUsers(database$billingAccountId, database$databaseId)
  )
  testthat::expect_true("tbl_df" %in% class(billingAccountDatabaseUsers))
  testthat::expect_true(nrow(billingAccountDatabaseUsers)>0)
  
  invisible(sapply(names(billingAccountUsers), function(x) {
    testthat::expect_identical(typeof(billingAccountUsers[[x]]), "character")
  }))
  
  billingAccountDatabaseUsers2 <- getBillingAccountDatabaseUsers(database$billingAccountId, database$databaseId, asDataFrame = FALSE)
  
  billingAccountDatabaseUsersNames <- names(billingAccountDatabaseUsers2[[1]])
  
  additionalColumns <- billingAccountDatabaseUsersNames[!(billingAccountDatabaseUsersNames %in% names(billingAccountDatabaseUsers))]
  if (length(additionalColumns)>0) {
    message(sprintf("There are additional names in getBillingAccountDatabaseUsers() to be added as columns: '%s'", paste(additionalColumns, collapse = "', '")))
  }
  
})

testthat::test_that("getBillingAccountDatabaseUsers missing or invalid billingAccountId or databaseId throws error", {
  testthat::expect_error(getBillingAccountDatabaseUsers(), regexp = "A billingAccountId and a databaseId must be provided")
  testthat::expect_error(getBillingAccountDatabaseUsers(databaseId = "invalid"), regexp = "A billingAccountId and a databaseId must be provided")
  testthat::expect_error(getBillingAccountDatabaseUsers(billingAccountId = "invalid"), regexp = "A billingAccountId and a databaseId must be provided")
  testthat::expect_error(getBillingAccountDatabaseUsers(databaseId = "invalid", billingAccountId = "invalid"), regexp = "404")
})