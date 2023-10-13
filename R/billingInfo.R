#' @title getBillingAccount
#' @description Get billing account information
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @param billingId Billing ID
#' @return Billing account information in list or data.frame output
#' @rdname getBillingAccount
#' @export 
#' @importFrom tibble as_tibble

getBillingAccount <- function(asDataFrame = TRUE, billingId) {
  billingInfo <- getResource(paste0("/billingAccounts/", billingId), task = "Getting billing account info")
  if (asDataFrame == TRUE) {
    billingInfo <- tibble::as_tibble(billingInfo)
    return(billingInfo)
  } else {
    return(billingInfo)
  }
}


#' @title getBillingAccountDatabases
#' @description Data for all databases under billing account
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @param billingId Billing ID
#' @return Information on databases under billing account in list or data.frame output
#' @rdname getBillingAccountDatabases
#' @export 
#' @importFrom tibble tibble

getBillingAccountDatabases <- function(asDataFrame = TRUE, billingId) {
  billingDatabases <- getResource(paste0("/billingAccounts/", billingId, "/databases"), 
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


#' @title getBillingAccountDomains
#' @description Billing account email domain info
#' @param billingId Billing ID
#' @return Information on billing account email domain in list output
#' @rdname getBillingAccountDomains
#' @export 

getBillingAccountDomains <- function(billingId) {
  billingDomains <- getResource(paste0("/billingAccounts/", billingId, "/domains"), task = "Getting billing account domains")
  return(billingDomains)
}


#' @title getBillingAccountUsers
#' @description Billing account users
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @param billingId Billing ID
#' @return Billing account user(s) in list or data.frame output
#' @rdname getBillingAccountUsers
#' @export 
#' @importFrom tibble tibble

getBillingAccountUsers <- function(asDataFrame = TRUE, billingId) {
  billingUsers <- getResource(paste0("/billingAccounts/", billingId, "/users"), task = "Getting billing account users")
  if (asDataFrame == TRUE) {
    billingUsers <- tibble::tibble(
      billingId = unlist(lapply(billingUsers, function(x) {x$billingId})),
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


#' @title getDatabaseBillingAccount
#' @description Get database owner for a given database. This gives the owning organization rather than the user who created the database.
#' @param asDataFrame Data.frame output, Default: TRUE
#' @param databaseId Database ID
#' @return Database owner in list output
#' @rdname getDatabaseBillingAccount
#' @export 

getDatabaseBillingAccount <- function(asDataFrame = TRUE, databaseId) {
  databaseOwner <- getResource(paste0("/databases/", databaseId, "/billingAccount"), task = "Getting database owner")
  return(databaseOwner)
}


#' @title getBillingAccountDatabaseUsers
#' @description Get data for users from a specific database. Can be more useful than `getDatabaseUsers()` as you also retrieve the database owner's info as well.
#' @param asDataFrame Data.frame output, Default: TRUE
#' @param billingId Billing ID
#' @param databaseId Database ID
#' @return User information from the specified database in list or data.frame output
#' @rdname getBillingAccountDatabaseUsers
#' @export 
#' @importFrom tibble tibble

getBillingAccountDatabaseUsers <- function(asDataFrame = TRUE, billingId, databaseId) {
  databaseUsers <- getResource(paste0("billingAccounts/", billingId, "/users?databaseId=", databaseId), task = "Getting database data")
  if (asDataFrame == TRUE) {
    databaseUsers <- tibble::tibble(
      billingId = unlist(lapply(databaseUsers, function(x) {x$billingId})),
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


