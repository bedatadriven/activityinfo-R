
testthat::test_that("addDatabase() and deleteDatabase() works", {
  testthat::expect_no_error({
    dbTest <- addDatabase("Another test database on the fly!")
    dbTestTree <- getDatabaseTree(databaseId = dbTest$databaseId)
  })
  testthat::expect_identical(dbTest$databaseId, dbTestTree$databaseId)
  
  testthat::expect_no_error({
    result <- deleteDatabase(databaseId = dbTest$databaseId)
  })
  
  testthat::expect_identical(result$code, "DELETED")
})

testthat::test_that("getDatabases() works", {
  
  # update snapshot; works for now
  databases <- getDatabases() %>% 
    select("billingAccountId", "databaseId", "description", "label", "ownerId", "suspended")
  databases <- canonicalizeActivityInfoObject(databases)
  
  
  testthat::expect_snapshot(databases)
})

testthat::test_that("getDatabaseSchema() and getDatabaseTree() return same value and getDatabaseSchema() provides deprecation warning", {
  testthat::expect_warning(
    testthat::expect_identical(getDatabaseSchema(databaseId = database$databaseId), getDatabaseTree(databaseId = database$databaseId)),
    regexp = "Deprec"
  )
})


testthat::test_that("getDatabaseTree() works", {
  tree <- getDatabaseTree(databaseId = database$databaseId)
  testthat::expect_s3_class(tree, "databaseTree")
  testthat::expect_named(tree, c("databaseId", "userId", "version", "label", "description", "ownerRef", "billingAccountId", "language", "originalLanguage", "continuousTranslation", "translationFromDbMemory", "thirdPartyTranslation", "languages", "role", "suspended", "storage", "publishedTemplate", "resources", "grants", "locks", "roles", "securityCategories"))
  testthat::expect_identical(tree$databaseId, database$databaseId)
  expectActivityInfoSnapshotCompare(tree, snapshotName = "databases-databaseTree", allowed_new_fields = TRUE)
})

testthat::test_that("getDatabaseResources() works", {
  testthat::expect_no_error({
    dbTree <- getDatabaseTree(databaseId = database$databaseId)
    dbResources <- getDatabaseResources(dbTree)
    folders <- dbResources[dbResources$type == "FOLDER",]
    forms <- dbResources[dbResources$type == "FORM",]
    subForms <- dbResources[dbResources$type == "SUB_FORM",]
  })
  
  dbResources <- dbResources[order(dbResources$id, dbResources$parentId, dbResources$label, dbResources$visibility),] %>% 
    select(id, label, parentId, type, visibility)
  dbResources$id <- substr(dbResources$id,1,9)
  dbResources$parentId <- substr(dbResources$parentId,1,9)
  row.names(dbResources) <- NULL
  dbResources <- canonicalizeActivityInfoObject(dbResources, replaceId = FALSE)
    
  
  
  testthat::expect_snapshot(dbResources)
})

addTestUsers <- function(database, tree, nUsers = 1) {
  lapply(1:nUsers, function(x) {
    newUserEmail <- sprintf("test%s@example.com", cuid())
    newDatabaseUser <- addDatabaseUser(databaseId = database$databaseId, email = newUserEmail, name = "Test database user", locale = "en", roleId = tree$roles[[2]]$id, roleResources = list(database$databaseId))

    testthat::expect_true(newDatabaseUser$added)

    testthat::expect_identical(newDatabaseUser$user$email, newUserEmail)
    testthat::expect_identical(newDatabaseUser$user$role$id, tree$roles[[2]]$id)
    testthat::expect_identical(newDatabaseUser$user$role$resources[[1]], database$databaseId)

    newDatabaseUser
  })
}

deleteTestUsers <- function(database, returnedUsers) {
  lapply(returnedUsers, function(newDatabaseUser) {
    if (newDatabaseUser$added) {
      testthat::expect_no_error({
        deleteDatabaseUser(databaseId = database$databaseId, userId = newDatabaseUser$user$userId)
      })
      testthat::expect_null(getDatabaseUser(databaseId = database$databaseId, userId = newDatabaseUser$user$userId))
    } else {
      message(newDatabaseUser$error$request)
    }
  })
}

# Simplifies the user object for snapshots and warns when expected fields are missing and provides an informative message when there are new fields
simplifyUsers <- function(returnedUsers, additionalFields = list(), addedUsers = FALSE, expectAdded = TRUE) {
  expectedFields <- c(additionalFields, "databaseId","deliveryStatus","email", "name", "role", "userId")
  
  if (addedUsers) {
    expectedFields <- c("inviteTime",'version', 'activationStatus', 'lastLoginTime', 'grants', expectedFields)
    returnedUsers <- lapply(returnedUsers, function(x) {
      if (expectAdded) testthat::expect_true(x$added)
      x$user
    })
  } else {
    expectedFields <- c("inviteDate", "inviteAccepted", "version", "activationStatus",'userLicenseType', 'lastLoginDate', expectedFields) #, "lastLoginTime", "grants"
  }
  
  lapply(returnedUsers, function(x) {
    allExpectedNamesPresent <- all(expectedFields %in% names(x))
    if(!allExpectedNamesPresent) {
      warning("Expected fields/names missing in user: ", paste(expectedFields[!(expectedFields %in% names(x))], collapse = ", "))
    }
    testthat::expect_true(allExpectedNamesPresent)
    
    if (!all(names(x) %in% expectedFields)) {
      missingFields <- names(x)[!names(x) %in% expectedFields]
      if (addedUsers) {
        msg <- "The following additional names were found in after adding a user and inspecting returned user: '%s'"
      } else {
        msg <- "The following additional names were found in user: '%s'"
      }
      message(sprintf(msg, paste(missingFields, collapse="', '")))
    }
    x["version"] <- NULL
    x <- x[names(x) %in% expectedFields]
    x <- x[sapply(x, is.atomic)]
    x <- x[order(names(x))]
    
    x
  })
}

testthat::test_that("addDatabaseUser() and deleteDatabaseUser() and getDatabaseUsers() and getDatabaseUser() and getDatabaseUser2() work and expected fields are present", {
  databases <- getDatabases()
  database <- databases[1,]
  tree <- getDatabaseTree(databaseId = database$databaseId)

  returnedUsers <- addTestUsers(database, tree, nUsers = 2)
  
  # update snapshot; safe for now
  expectActivityInfoSnapshot(simplifyUsers(returnedUsers, addedUsers = TRUE))
  
  nUsers <- 2
  
  testthat::expect_no_error({
    users <- getDatabaseUsers(databaseId = database$databaseId, asDataFrame=FALSE)
  })
  
  testthat::expect_gte(length(users), expected = nUsers)

  if (length(users) == 0) stop("No users available to test.")

  lapply(1:nUsers, function(x) {
    testthat::expect_no_error({
      user <- getDatabaseUser(databaseId = database$databaseId, userId = users[[x]]$userId)
    })

    testthat::expect_identical(user$userId, users[[x]]$userId)
    testthat::expect_identical(user$databaseId, database$databaseId)
    testthat::expect_identical(user$name, users[[x]]$name)
    testthat::expect_identical(user$email, users[[x]]$email)
  })
  
  testthat::expect_no_error({
    users2 <- getDatabaseUsers(databaseId = database$databaseId, asDataFrame=TRUE)
  })
  
  testthat::expect_equal(class(users2), "data.frame")

  # update snapshot; safe for now
  expectActivityInfoSnapshot(simplifyUsers(users))

  deleteTestUsers(database, returnedUsers)
})


testthat::test_that("updateUserRole() works", {
  # databases <- getDatabases()
  # database <- databases[[1]]
  # tree <- getDatabaseTree(databaseId = database$databaseId)
  #
  # returnedUsers <- addTestUsers(database, tree, nUsers = 1)
  #
  # lapply(returnedUsers, function(newDatabaseUser) {
  #
  # })
  #
  # deleteTestUsers(database, tree, returnedUsers)
})




testthat::test_that("roleAssignment() works", {
})

testthat::test_that("permissions() helper works", {
})

testthat::test_that("updateGrant() works", {
})

testthat::test_that("updateRole() works", {
})
