#' @title getBillingAccount
#' @description Get billing account information
#' @param billingAccountId Billing ID
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @return Billing account information in list or data.frame output
#' @rdname getBillingAccount
#' @export 
#' @importFrom tibble as_tibble

getBillingAccount <- function(billingAccountId, asDataFrame = TRUE) {
  if(missing(billingAccountId)) stop("A billingAccountId must be provided")
  stopifnot("A single billingAccountId must be provided" = (length(billingAccountId)==1))
  
  billingInfo <- getResource(paste0("/billingAccounts/", billingAccountId), task = "Getting billing account info")
  billingInfo$id <- as.character(billingInfo$id)
  if (asDataFrame == TRUE) {
    billingInfo <- tibble::as_tibble(billingInfo)
    return(billingInfo)
  } else {
    return(billingInfo)
  }
}


#' @title getBillingAccountDatabases
#' @description Data for all databases under billing account
#' @param billingAccountId Billing ID
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @return Information on databases under billing account in list or data.frame output
#' @rdname getBillingAccountDatabases
#' @export 
#' @importFrom tibble tibble

getBillingAccountDatabases <- function(billingAccountId, asDataFrame = TRUE) {
  if(missing(billingAccountId)) stop("A billingAccountId must be provided")
  stopifnot("A single billingAccountId must be provided" = (length(billingAccountId)==1))
  
  billingDatabases <- getResource(paste0("/billingAccounts/", billingAccountId, "/databases"), 
                                  task = "Getting billing account databases")
  
  billingDatabases <- lapply(billingDatabases, function(x) {
    x$billingAccountId <- as.character(x$billingAccountId)
    x
  })
  
  if (asDataFrame == TRUE) {
    billingDatabases <- tibble::tibble(
      databaseId = unlist(lapply(billingDatabases, function(x) {x$databaseId})),
      label = unlist(lapply(billingDatabases, function(x) {x$label})),
      description = unlist(lapply(billingDatabases, function(x) { if(nzchar(x$description)) x$description else NA_character_ })),
      ownerId = unlist(lapply(billingDatabases, function(x) {x$owner[["id"]]})),
      ownerName = unlist(lapply(billingDatabases, function(x) {x$owner[["name"]]})),
      ownerEmail = unlist(lapply(billingDatabases, function(x) {x$owner[["email"]]})),
      formCount = unlist(lapply(billingDatabases, function(x) {x$formCount})),
      userCount = unlist(lapply(billingDatabases, function(x) {x$userCount})),
      basicUserCount = unlist(lapply(billingDatabases, function(x) {x$basicUserCount})),
      recordCount = unlist(lapply(billingDatabases, function(x) {x$recordCount})),
      lastRecordUpdate = unlist(lapply(billingDatabases, function(x) {
        if(is.null(x$lastRecordUpdate)) 
        {NA} else 
        {x$lastRecordUpdate}
      })),
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
#' @param billingAccountId Billing ID
#' @return Information on billing account email domain in list output
#' @rdname getBillingAccountDomains
#' @export 

getBillingAccountDomains <- function(billingAccountId) {
  if(missing(billingAccountId)) stop("A billingAccountId must be provided")
  stopifnot("A single billingAccountId must be provided" = (length(billingAccountId)==1))
  
  billingDomains <- getResource(paste0("/billingAccounts/", billingAccountId, "/domains"), task = "Getting billing account domains")
  return(billingDomains)
}


#' @title getBillingAccountUsers
#' @description Billing account users
#' @param billingAccountId Billing ID
#' @param asDataFrame Output as data.frame, Default: TRUE
#' @return Billing account user(s) in list or data.frame output
#' @rdname getBillingAccountUsers
#' @export 
#' @importFrom tibble tibble

getBillingAccountUsers <- function(billingAccountId, asDataFrame = TRUE) {
  if(missing(billingAccountId)) stop("A billingAccountId must be provided")
  stopifnot("A single billingAccountId must be provided" = (length(billingAccountId)==1))
  
  billingUsers <- getResource(paste0("/billingAccounts/", billingAccountId, "/users"), task = "Getting billing account users")
  if (asDataFrame == TRUE) {
    billingUsers <- tibble::tibble(
      userId = unlist(lapply(billingUsers, function(x) {x$userId})),
      billingAccountId = unlist(lapply(billingUsers, function(x) {x$billingAccountId})),
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
#' @param databaseId Database ID
#' @param asDataFrame Data.frame output, Default: TRUE
#' @return Database owner in list output
#' @rdname getDatabaseBillingAccount
#' @export 

getDatabaseBillingAccount <- function(databaseId, asDataFrame = TRUE) {
  if(missing(databaseId)) stop("A databaseId must be provided")
  stopifnot("A single databaseId must be provided" = (length(databaseId)==1))
  
  databaseOwner <- getResource(paste0("/databases/", databaseId, "/billingAccount"), task = "Getting database owner")
  databaseOwner$id <- as.character(databaseOwner$id)
  
  if (asDataFrame) {
    databaseOwner <- as_tibble(databaseOwner)
  }
  return(databaseOwner)
}


#' @title getBillingAccountDatabaseUsers
#' @description Get data for users from a specific database. Can be more useful than `getDatabaseUsers()` as you also retrieve the database owner's info as well.
#' @param billingAccountId Billing ID
#' @param asDataFrame Data.frame output, Default: TRUE
#' @param databaseId Database ID
#' @return User information from the specified database in list or data.frame output
#' @rdname getBillingAccountDatabaseUsers
#' @export 
#' @importFrom tibble tibble

getBillingAccountDatabaseUsers <- function(billingAccountId, databaseId, asDataFrame = TRUE) {
  if(missing(billingAccountId)||missing(databaseId)) stop("A billingAccountId and a databaseId must be provided")
  stopifnot("A single billingAccountId must be provided" = (length(billingAccountId)==1))
  stopifnot("A single databaseId must be provided" = (length(databaseId)==1))
  
  databaseUsers <- getResource(paste0("billingAccounts/", billingAccountId, "/users?databaseId=", databaseId), task = "Getting database data")
  if (asDataFrame == TRUE) {
    databaseUsers <- tibble::tibble(
      userId = unlist(lapply(databaseUsers, function(x) {x$userId})),
      billingAccountId = unlist(lapply(databaseUsers, function(x) {x$billingAccountId})),
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


