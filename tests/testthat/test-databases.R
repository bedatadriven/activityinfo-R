
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
  #old#
})

testthat::test_that("updateGrant() works", {
  #old#
})

testthat::test_that("permissions() helper works", {
  defaultPermissions <- permissions()
  reviewerPermissions <- permissions(
    view = TRUE,
    add_record = TRUE,
    reviewer_only = TRUE,
    discover = TRUE
  )
  testthat::expect_snapshot(defaultPermissions)
  testthat::expect_snapshot(reviewerPermissions)
})

testthat::test_that("parameter() works", {
  param <- parameter(id = "partner", label = "Reporting partner", range = "ck5dxt1712")
  testthat::expect_snapshot(param)
})

testthat::test_that("adminPermissions() works", {
  defaultAdminPermissions <- adminPermissions()
  enhancedAdminPermissions <- adminPermissions(
    manage_automations = TRUE, 
    manage_users = TRUE, 
    manage_roles = TRUE
  )
  testthat::expect_snapshot(defaultAdminPermissions)
  testthat::expect_snapshot(enhancedAdminPermissions)
})


testthat::test_that("grant() works", {
  optionalGrant <- 
    grant(resourceId = "ck5dxt1552",
          permissions = permissions(
            view = TRUE,
            add_record = TRUE,
            edit_record = TRUE
          ),
          optional = TRUE
    )
  testthat::expect_snapshot(optionalGrant)
})


testthat::test_that("roleFilter() works", {
  roleLevelFilter <- 
    roleFilter(
      id = "partner", 
      label = "Partner is user's partner", 
      filter = "ck5dxt1712 == @user.partner"
    )
  testthat::expect_snapshot(roleLevelFilter)
})


testthat::test_that("role() works", {
  grantBasedRole <- 
    role(id = "rp",
         label = "Reporting Partner",
         parameters = list(
           parameter(id = "partner", label = "Partner", range = "ck5dxt1712")),
         grants = list(
           grant(resourceId = "cq9xyz1552",
                 permissions = permissions(
                   view = "ck5dxt1712 == @user.partner",
                   edit_record = "ck5dxt1712 == @user.partner",
                   discover = TRUE,
                   export_records = TRUE)),
           grant(resourceId = "cz55555555",
                 permissions = permissions(
                   view = TRUE,
                   discover = TRUE,
                   add_record = TRUE),
                 optional = TRUE)),
         filters = list(
           roleFilter(
             id = "partner", 
             label = "Partner is user's partner", 
             filter = "ck5dxt1712 == @user.partner"))
    )
  testthat::expect_snapshot(grantBasedRole)
})

testthat::test_that("updateRole() works", {
  roleId = "rp"
  roleLabel = "Reporting partner"

  # create a partner reference form
  partnerForm <- formSchema(
    databaseId = database$databaseId, 
    label = "Reporting Partners") |>
    addFormField(
      textFieldSchema(
        code = "name",
        label = "Partner name", 
        required = TRUE))

  addForm(partnerForm)
  
  # create a reference partner table
  partnerTbl <- tibble(id = paste0("partner",1:3), name = paste0("Partner ",1:3))
  
  # import partner records
  importRecords(partnerForm$id, data = partnerTbl, recordIdColumn = "id")
  
  # create a reporting table with a reporting partner field
  reportingForm <- formSchema(
    databaseId = database$databaseId, 
    label = "Reports") |>
    addFormField(
      referenceFieldSchema(
        referencedFormId = partnerForm$id, 
        code = "rp", 
        label = "Partner", 
        required = TRUE)) |>
    addFormField(
      textFieldSchema(
        label = "Report", 
        required = TRUE))
  
  addForm(reportingForm)

  # create a reports table
  reportingTbl <- tibble(Partner = rep(paste0("partner",1:3), 2), Report = rep(paste0("This is a report from Partner ",1:3),2))

  # import reports
  importRecords(reportingForm$id, data = reportingTbl)
  
  # create a role
  newRole <- 
    role(id = roleId,
         label = roleLabel,
         parameters = list(
           parameter(id = "partner", label = "Partner", range = partnerForm$id)),
         grants = list(
           grant(resourceId = reportingForm$id,
                 permissions = permissions(
                   view = sprintf("%s == @user.partner", partnerForm$id),
                   edit_record = sprintf("%s == @user.partner", partnerForm$id),
                   discover = TRUE,
                   export_records = TRUE)),
           grant(resourceId = partnerForm$id,
                 permissions = permissions(
                   view = TRUE,
                   discover = FALSE)))
         #,
         #filters = list(
         #  roleFilter(
         #    id = "partner", 
         #   label = "Partner is user's partner", 
         #   filter = sprintf("%s == @user.partner", partnerForm$id)))
    )
  
  # update the role
  updateRole(databaseId = database$databaseId, role = newRole)
  
  # fetch and check that the role matches
  tree <- getDatabaseTree(databaseId = database$databaseId)
  
  roleIdentical <- sapply(tree$roles, function(x) {
    if (x$id == roleId) {
      testthat::expect_identical(x$label, roleLabel)
      testthat::expect_length(object = x$parameters, n = 1)
      testthat::expect_identical(x$parameters[[1]]$parameterId,"partner")
      testthat::expect_identical(x$parameters[[1]]$range,partnerForm$id)
      
      testthat::expect_length(object = x$permissions, n = 0)
      
      testthat::expect_length(object = x$grants, n = 2)
      
      grant1 <- x$grants[[which(sapply(x$grants, function(g) g$resourceId == reportingForm$id))]]
      testthat::expect_identical(grant1$resourceId, reportingForm$id)
      testthat::expect_length(object = grant1$operations, n = 4)
      testthat::expect_identical(grant1$operations[[1]]$operation, "VIEW")
      testthat::expect_identical(grant1$operations[[1]]$filter, sprintf("%s == @user.partner", partnerForm$id))
      testthat::expect_identical(grant1$operations[[2]]$operation, "EDIT_RECORD")
      testthat::expect_identical(grant1$operations[[2]]$filter, sprintf("%s == @user.partner", partnerForm$id))
      testthat::expect_identical(grant1$operations[[3]]$operation, "EXPORT_RECORDS")
      testthat::expect_identical(grant1$operations[[4]]$operation, "DISCOVER")
      
      grant2 <- x$grants[[which(sapply(x$grants, function(g) g$resourceId == partnerForm$id))]]
      testthat::expect_identical(grant2$resourceId, partnerForm$id)
      testthat::expect_length(object = grant2$operations, n = 1)
      testthat::expect_identical(grant2$operations[[1]]$operation, "VIEW")
      
      #testthat::expect_length(object = x$filters, n = 1)
      #testthat::expect_identical(x$filters[[1]]$id, "partner")
      #testthat::expect_identical(x$filters[[1]]$label, "Partner is user's partner")
      #testthat::expect_identical(x$filters[[1]]$filter, "cwjcaculx3axxgxo == @user.partner")
      
      testthat::expect_true(x$grantBased)
      
      TRUE
    } else {
      FALSE
    }
  }) 
  testthat::expect_true(any(roleIdentical))
})

testthat::test_that("Grant-based role assignment works", {
  # create a test user
  # assign a role
  # check the user roles and verify they match
})



