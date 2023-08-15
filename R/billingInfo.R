#' @title getBillingInfo
#' @description Get billing account information
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @param userId User ID
#' @return Billing account information in list or data.frame output
#' @rdname getBillingInfo
#' @export 
#' @importFrom tibble as_tibble

getBillingInfo <- function(asDataFrame = TRUE, userId) {
  billingInfo <- getResource(paste0("/billingAccounts/", userId), task = "Getting billing account info")
  if (asDataFrame == TRUE) {
    billingInfo <- tibble::as_tibble(billingInfo)
    return(billingInfo)
  } else {
    return(billingInfo)
  }
}


#' @title getBillingDatabases
#' @description Data for all databases under billing account
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @param userId User ID
#' @return Information on databases under billing account in list or data.frame output
#' @rdname getBillingDatabases
#' @export 
#' @importFrom tibble tibble

getBillingDatabases <- function(asDataFrame = TRUE, userId) {
  billingDatabases <- getResource(paste0("/billingAccounts/", userId, "/databases"), 
                                  task = "Getting billing account databases")
  if (asDataFrame == TRUE) {
    billingDatabases <- tibble::tibble(
      databaseId = unlist(lapply(billingDatabases, function(x) {x$databaseId})),
      label = unlist(lapply(billingDatabases, function(x) {x$label})),
      description = unlist(lapply(billingDatabases, function(x) { if(nzchar(x$description)) x$description else NA_character_ })),
      owner = lapply(billingDatabases, function(x) {x$owner}),
      formCount = unlist(lapply(billingDatabases, function(x) {x$formCount})),
      userCount = unlist(lapply(billingDatabases, function(x) {x$userCount})),
      basicUserCount = unlist(lapply(billingDatabases, function(x) {x$basicUserCount})),
      recordCount = unlist(lapply(billingDatabases, function(x) {x$recordCount})),
      lastRecordUpdate = unlist(lapply(billingDatabases, function(x) {x$lastRecordUpdate})),
      billingAccountId = unlist(lapply(billingDatabases, function(x) {x$billingAccountId})),
      suspended = unlist(lapply(billingDatabases, function(x) {x$suspended})),
      publishedTemplate = unlist(lapply(billingDatabases, function(x) {x$publishedTemplate}))
    )
    return(billingDatabases)
  } else {
    return(billingDatabases)
  }
}


#' @title getBillingDomains
#' @description Billing account email domain info
#' @param userId User ID
#' @return Information on billing account email domain in list output
#' @rdname getBillingDomains
#' @export 

getBillingDomains <- function(userId) {
  billingDomains <- getResource(paste0("/billingAccounts/", userId, "/domains"), task = "Getting billing account domains")
  return(billingDomains)
}


#' @title getBillingUsers
#' @description Billing account users
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @param userId User ID
#' @return Billing account user(s) in list or data.frame output
#' @rdname getBillingUsers
#' @export 
#' @importFrom tibble tibble

getBillingUsers <- function(asDataFrame = TRUE, userId) {
  billingUsers <- getResource(paste0("/billingAccounts/", userId, "/users"), task = "Getting billing account users")
  if (asDataFrame == TRUE) {
    billingUsers <- tibble::tibble(
      userId = unlist(lapply(billingUsers, function(x) {x$userId})),
      email = unlist(lapply(billingUsers, function(x) {x$email})),
      name = unlist(lapply(billingUsers, function(x) {x$name})),
      billingAccountRole = unlist(lapply(billingUsers, function(x) {x$billingAccountRole})),
      userLicenseType = unlist(lapply(billingUsers, function(x) {x$userLicenseType})),
      lastLoginTime = unlist(lapply(billingUsers, function (x) {format(as.POSIXct(x$lastLoginTime, origin = "1970-01-01", tz = "UTC"), "%H:%M:%S")}))
    )
    return(billingUsers)
  } else {
    return(billingUsers)
  }
  return(billingUsers)
}


#' @title getDatabaseOwner
#' @description Get database owner for a given database. This gives the owning organization rather than the user who created the database.
#' @param asDataFrame Data.frame output, Default: TRUE
#' @param databaseId Database ID
#' @return Database owner in list output
#' @rdname getDatabaseOwner
#' @export 

getDatabaseOwner <- function(asDataFrame = TRUE, databaseId) {
  databaseOwner <- getResource(paste0("/databases/", databaseId, "/billingAccount"), task = "Getting database owner")
  return(databaseOwner)
}


#' @title getBillingDatabaseUsers
#' @description Get data for users from a specific database. Can be more useful than `getDatabaseUsers()` as you also retrieve the database owner's info as well.
#' @param asDataFrame Data.frame output, Default: TRUE
#' @param userId User ID
#' @param databaseId Database ID
#' @return User information from the specified database in list or data.frame output
#' @rdname getBillingDatabaseUsers
#' @export 
#' @importFrom tibble tibble

getBillingDatabaseUsers <- function(asDataFrame = TRUE, userId, databaseId) {
  databaseUsers <- getResource(paste0("billingAccounts/", userId, "/users?databaseId=", databaseId), task = "Getting database data")
  if (asDataFrame == TRUE) {
    databaseUsers <- tibble::tibble(
      userId = unlist(lapply(databaseUsers, function(x) {x$userId})),
      email = unlist(lapply(databaseUsers, function(x) {x$email})),
      name = unlist(lapply(databaseUsers, function(x) {x$name})),
      billingAccountRole = unlist(lapply(databaseUsers, function(x) {x$billingAccountRole})),
      userLicenseType = unlist(lapply(databaseUsers, function(x) {x$userLicenseType})),
      lastLoginTime = unlist(lapply(databaseUsers, function (x) {format(as.POSIXct(x$lastLoginTime, origin = "1970-01-01", tz = "UTC"), "%H:%M:%S")}))
    )
    return(databaseUsers)
  } else {
    return(databaseUsers)
  }
}


