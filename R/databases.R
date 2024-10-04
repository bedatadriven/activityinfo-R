#' getDatabases()
#'
#' Retrieves a list of databases the authenticated user owns, or has been shared
#'  with the authenticated user as a tibble. You can retrieve it as a list
#'  if you set the argument `asDataFrame` to `FALSE`.
#'
#' @param asDataFrame Retrieve database list as a data.frame, otherwise returns as list. Default: TRUE
#'
#' @export
getDatabases <- function(asDataFrame = TRUE) {
  databases <- getResource("databases", task = "Getting all databases")
  if (asDataFrame == TRUE) {
    return(databasesListToTibble(databases))
  } else if (asDataFrame == FALSE) {
    return(lapply(databases, function(x) {
      x$ownerId <- as.character(x$ownerId)
      x$billingAccountId <- as.character(x$billingAccountId)
      x
    }))
  }
}

databasesListToTibble <- function(databases) {
  dbDF <- dplyr::tibble(
    databaseId = unlist(lapply(databases, function(x) {x$databaseId})),
    label = unlist(lapply(databases, function(x) {x$label})),
    description = unlist(lapply(databases, function(x) { if(nzchar(x$description)) x$description else NA_character_ })),
    ownerId = as.character(unlist(lapply(databases, function(x) {x$ownerId}))),
    billingAccountId = as.character(unlist(lapply(databases, function(x) {x$billingAccountId}))),
    suspended = unlist(lapply(databases, function(x) {x$suspended}))
  )
  return(dbDF)
}

databaseUpdates <- function() {
  list(
    resourceUpdates = list(),
    resourceDeletions = list(),
    lockUpdates = list(),
    lockDeletions = list(),
    roleUpdates = list(),
    roleDeletions = list(),
    languageUpdates = list(),
    languageDeletions = list(),
    originalLanguage = NULL,
    continousTranslation = NULL,
    translationFromDbMemory = NULL,
    thirdPartyTranslation = NULL,
    publishedTemplate = NULL
  )
}


#' getDatabaseSchema
#'
#' This function is deprecated in favor of getDatabaseTree(). Please use \link{getDatabaseTree}.
#'
#' @param databaseId database identifier
#' @examples
#' \dontrun{
#' getDatabaseSchema("ck2k93muu2")
#' }
#' @export
getDatabaseSchema <- function(databaseId) {
  .Deprecated("getDatabaseTree")
  getDatabaseTree(databaseId)
}

#' getDatabaseTree
#'
#' Retrieves the database's tree of resources that are visible to the authenticated
#' user.
#'
#' @param databaseId database identifier
#' @examples
#' \dontrun{
#' getDatabaseTree("ck2k93muu2")
#' }
#' @export
getDatabaseTree <- function(databaseId) {
  tree <- getResource(
    paste("databases", databaseId, sep = "/"),
    task = sprintf("Getting database tree for database %s", databaseId)
  )
  class(tree$resources) <- "databaseResources"
  class(tree) <- "databaseTree"
  tree$billingAccountId <- as.character(tree$billingAccountId)
  tree
}

#' getDatabaseResources
#'
#' Creates a data.frame of database resources, types, parentIds and ids.
#' This can be used to access a list of folders, forms, and sub-forms.
#'
#' @param database Database tree or a database id
#'
#' @examples
#' \dontrun{
#' dbTree <- getDatabaseTree("c9mudk52")
#' dbResources <- getDatabaseResources(dbTree)
#' folders <- dbResources[dbResources$type == "FOLDER",]
#' forms <- dbResources[dbResources$type == "FORM",]
#' subForms <- dbResources[dbResources$type == "SUB_FORM",]
#' }
#'
#' @export
getDatabaseResources <- function(database) {
  if(is.character(database)) {
    databaseTree <- getDatabaseTree(database)  
  } else if(is.list(database)) {
    databaseTree <- database
  } else {
    stop("The `database` argument must be a database id or a databaseTree")
  }
  dplyr::tibble(
    id = unlist(lapply(databaseTree$resources, function(x) {x$id})),
    label = unlist(lapply(databaseTree$resources, function(x) {x$label})),
    type = unlist(lapply(databaseTree$resources, function(x) {x$type})),
    parentId = unlist(lapply(databaseTree$resources, function(x) {x$parentId})),
    visibility = unlist(lapply(databaseTree$resources, function(x) {x$visibility}))
  )
}


#' addDatabase
#'
#' Adds a new database.
#'
#' Note that only billing account owners are permitted to add new databases.
#'
#' @export
#' @param label The new database label
#' @param databaseId The new database identifier; a cuid will be generated if missing
#' @examples
#' \dontrun{
#' newDb <- addDatabase("Programme information system")
#' }
addDatabase <- function(label, databaseId = cuid()) {
  x <- postResource(
    "databases",
    body = list(
      id = databaseId,
      label = label,
      templateId = "blank"
      ),
    task = sprintf("Creating new database '%s' with id %s", label, databaseId)
  )
  x$billingAccountId <- as.character(x$billingAccountId)
  x
}

#' deleteDatabase
#'
#' Deletes a database.
#'
#' @export
#'
#' @param databaseId database identifier
#'
#' @examples
#' \dontrun{
#' deleteDatabase(databaseId = "c10011c3x5pnoldk0ua1qr")
#' }
deleteDatabase <- function(databaseId) {
  result <- deleteResource(
    paste("databases", databaseId, sep = "/"),
    task = sprintf("Requesting deletion of database %s", databaseId)
  )
  if (is.list(result)&&!is.null(result$code)&&result$code=="DELETED") {
    # "Deletion of database confirmed
    return(invisible(result))
  }
  stop(sprintf("Error while deleting database %s: %s", databaseId, deparse(result)))
}

#' @export
print.databaseTree <- function(x, ...) {
  tree <- x
  cat("Database Tree Object\n")
  cat(sprintf("  label:        %s\n", tree$label))
  cat(sprintf("  databaseId:   %s\n", tree$databaseId))
  cat(sprintf("  resources: %d\n", length(tree$resources)))

  for (resource in tree$resources) {
    cat(sprintf("    %s: %s\n", resource$id, resource$label))
    cat(sprintf("      type: %s\n", resource$type))
    cat(sprintf("      visibility: %s\n", resource$visibility))
  }

  invisible()
}

#' getDatabaseUsers
#'
#' Retrieves the list of users with access to the database in a data.frame format.
#'
#' @param databaseId The database ID
#' @param asDataFrame Retrieve user list as a data.frame, otherwise returns as list. Default: TRUE
#'
#' @export
getDatabaseUsers <- function(databaseId, asDataFrame = TRUE) {
  users <- getResource(
    paste("databases", databaseId, "users", sep = "/"),
    task = sprintf("Getting list of database %s users", databaseId)
  )

  if (asDataFrame == TRUE) {

    usersDF <- data.frame(
      databaseId = unlist(lapply(users, function(x) {x$databaseId})),
      userId = unlist(lapply(users, function(x) {x$userId})),
      name = unlist(lapply(users, function(x) {x$name})),
      email = unlist(lapply(users, function(x) {x$email})),
      version = unlist(lapply(users, function(x) {x$version})),
      inviteDate = as.Date(unlist(lapply(users, function(x) {x$inviteDate}))),
      deliveryStatus = unlist(lapply(users, function(x) {x$deliveryStatus})),
      inviteAccepted = unlist(lapply(users, function(x) {x$inviteAccepted})) # ,
      # role = lapply(users, function(x) {x$role})
    )
    
    usersDF$role <- lapply(users, function(x) {x$role})

    return(usersDF)
  } else if (asDataFrame == FALSE) {
    return(users)
  }
}

#' getDatabaseUser
#'
#' Retrieves a user's role and permissions. Returns a NULL value if there is no user with the corresponding IDs.
#'
#' @param databaseId The database ID
#' @param userId The user ID
#'
#' @export
getDatabaseUser <- function(databaseId, userId) {
  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", userId, "grants", sep = "/")
  result <- GET(url, activityInfoAuthentication(), accept_json())

  if (result$status_code == 200) {
    userRes <- fromActivityInfoJson(result)
    userDF <- data.frame(
      databaseId = userRes$databaseId,
      userId = userRes$userId,
      name = userRes$name,
      email = userRes$email,
      version = userRes$version,
      inviteTime = format(as.POSIXct(userRes$inviteTime, origin = "1970-01-01", tz = "UTC"), "%H:%M:%S"),
      deliveryStatus = userRes$deliveryStatus,
      activationStatus = userRes$activationStatus,
      lastLoginTime = format(as.POSIXct(userRes$lastLoginTime, origin = "1970-01-01", tz = "UTC"), "%H:%M:%S")
    )
    
    userDF$role <- list(userRes$role)
    
    return(userDF)
  } else if (result$status_code == 404) {
    return(NULL)
  } else {
    stop(sprintf(
      "Request for %s failed with status code %d %s: %s",
      url, result$status_code, http_status(result$status_code)$message,
      content(result, as = "text", encoding = "UTF-8")
    ))
  }
}

# Compare with these in a test to see if return values differ
#' getDatabaseUser2
#'
#' Retrieves a user's role and permissions. This will throw an error if no user is found instead of returning a NULL value.
#'
#' @param databaseId The database ID
#' @param userId The user ID
#'

getDatabaseUser2 <- function(databaseId, userId) {
  url <- paste("databases", databaseId, "users", userId, "grants", sep = "/")
  getResource(url, task = sprintf("Request for database/user %s/%s", databaseId, userId))
}

checkUserRole <- function(databaseId, newUser, roleId, roleParameters, roleResources) {
  userRoleResources <- c(newUser$role$resources, databaseId) 
  userRoleParameters <- newUser$role$parameters
  
  if (roleId != newUser$role$id) {
    warning(sprintf(
      "User roleId '%s' does not match provided '%s'. The role may not have been assigned correctly.",
      newUser$role$id,
      roleId
      ))
  }
  # remove databaseId during legacy role removal
  missingResources <- userRoleResources[!(roleResources %in% userRoleResources)]
  if (length(missingResources)>0) {
    warning(sprintf(
      "User role resource ids (%s) do not included the following provided resource ids (%s)",
      paste(userRoleResources, collapse=", "),
      paste(missingResources, collapse=", ")
    ))
  }
  for (param in names(roleParameters)) {
    if (!(param %in% names(userRoleParameters))) {
      warning(sprintf("Provided parameter '%s' not found applied to user.", param))
    } else if (!grepl(roleParameters[[param]],userRoleParameters[[param]])) {
      warning(sprintf("Provided '%s' parameter value '%s' for user does not match parameter value returned by server: '%s'",
                      param,
                      roleParameters[[param]],
                      userRoleParameters[[param]]
      ))
    }
  }
}



#' addDatabaseUser
#'
#' Invites a user to a database.
#'
#' @param databaseId the id of the database to which they should be added
#' @param email the user's email
#' @param name the user's name (only used if they do not already have an ActivityInfo account)
#' @param locale the locale ("en', "fr", "ar", etc) to use inviting the user (only used if they do not already have an ActivityInfo account)
#' @param roleId the id of the role to assign to the user.
#' @param roleParameters a named list containing the role parameter values
#' @param roleResources a list of folders in which this role should be assigned (or the databaseId if they should have this role in the whole database)
#'
#' @details
#'
#' This function adds a new user to a database and assigns them a role.
#'
#' If there is no user account with the given email address, an email
#' is sent in the given locale to the email address inviting the user to
#' activate their account.
#'
#' If there is an ActivityInfo account with the given email address, an email is sent
#' notifying the user of their new role.
#'
#' In ActivityInfo, permissions are managed through _roles_. Roles include a set of
#' permissions. When a user is assigned a role, they inherit those permissions from the
#' role.
#'
#' Some roles are _parameterized_. For example, the "Reporting Partner" role included
#' in many database templates has a `partner` parameter that is used to filter which
#' records are visible to the user. The value of this parameter is the record id of the
#' user's partner in the related Partner form.
#'
#' @examples
#' \dontrun{
#' # Invite a user in the French locale, in the admin role.
#' # The invitation email will be in French.
#' addDatabaseUser(databaseId = "ck3pqrp9a1z",
#'    email = "alice@example.fr",
#'    name = "Alice Otieno",
#'    locale = "fr",
#'    roleId = "admin")
#'
#' # Add a user with a "Reporting Partner" role (rp)
#' redcrossPartnerRecordId <- "ck5m79b9c2"
#' addDatabaseUser(databaseId = "ck3pqrp9a1z",
#'    email = "bob@example.org",
#'    name = "Bob",
#'    roleId = "rp",
#'    roleParameters = list(partner = redcrossPartnerRecordId))
#' }
#'
#' @importFrom stringr str_replace
#'
#' @export
addDatabaseUser <- function(databaseId, email, name, locale = NA_character_, roleId,
                            roleParameters = list(),
                            roleResources = c(databaseId)) {

  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", sep = "/")

  request <- list(
    email = email,
    name = name,
    locale = locale,
    role = list(
      id = roleId,
      parameters = roleParameterList(roleParameters),
      resources = roleResources
    ),
    grants = list()
  )
  
  # fix conversion to empty json array by changing it to an empty json object
  jsonPayload <- stringr::str_replace(string = jsonlite::toJSON(request, auto_unbox = TRUE), pattern = '"parameters":\\[\\]', replacement = '"parameters":{}')

  response <- POST(url, body = jsonPayload, encode = "raw", activityInfoAuthentication(), accept_json(), httr::content_type_json())

  if (response$status_code == 200) {
    newUser <- fromActivityInfoJson(response)
    checkUserRole(databaseId, newUser, roleId, roleParameters, roleResources)
    
    return(list(
      added = TRUE,
      user = newUser
    ))
  } else if (response$status_code == 400) {
    return(list(
      added = FALSE,
      error = fromActivityInfoJson(response)
    ))
  } else {
    stop(sprintf(
      "Request for %s failed with status code %d %s: %s",
      url, response$status_code, http_status(response$status_code)$message,
      content(response, as = "text", encoding = "UTF-8")
    ))
  }
}

#' getDatabaseRole
#'
#' Helper method to fetch a role based on its id using the database tree or database id.
#'
#' @param database database tree using \link{getDatabaseTree} or the databaseId
#' @param roleId the id of the role.
#'
#' @examples
#' \dontrun{
#' # Get the reporting partner role
#' dbTree <- getDatabaseTree(databaseId = "ck3pqrp9a1z") # fetch the database tree
#' role <- getDatabaseRole(dbTree, roleId = "rp") # extract the reporting partner role
#' }
#' 
#' @export
#'
getDatabaseRole <- function(database, roleId) {
  UseMethod("getDatabaseRole")
}

#' @export
getDatabaseRole.character <- function(database, roleId) {
  tree <- getDatabaseTree(databaseId = database)
  getDatabaseRole(tree, roleId)
}

#' @export
getDatabaseRole.databaseTree <- function(database, roleId) {
  for (role in database$roles) {
    if (role$id == roleId) {
      return(role)
    }
  }
  return(NULL)
}

roleParameterList <- function(list) {
  if(length(list) == 0) {
    return(structure(list(), names = character(0)))
  }
  x <- as.list(list)
  if(is.null(names(x))) {
    stop("roleParameters must be a named list.")
  }
  x
}

#' deleteDatabaseUser
#'
#' Deletes a user from a database.
#'
#' The user will receive a notification that their permission to access
#' the database has been revoked.
#'
#' @param databaseId the id of the database
#' @param userId the (numeric) id of the user to remove from the database.
#'
#' @importFrom httr DELETE
#'
#' @export
#' @examples
#' \dontrun{
#'
#' # Get the list of users in the database
#' databaseId <- "cxy12345gh"
#' users <- getDatabaseUsers(databaseId)
#'
#' # Find the user with the email "bob@example.com"
#' matching <- sapply(users, function(u) u$email == "bob@example.com")
#' bob <- users[[which(matching)]]
#'
#' # Remove the user from the database
#' deleteDatabaseUser(databaseId = databaseId, userId = bob$userId)
#'
#' # You could also remove all users
#' for(user in users) {
#'   deleteDatabaseUser(databaseId = databaseId, userId = user$userId)
#' }
#' }
#'
deleteDatabaseUser <- function(databaseId, userId) {
  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", userId, sep = "/")

  response <- DELETE(url, activityInfoAuthentication())

  if (response$status_code != 200) {
    stop(sprintf(
      "Request for %s failed with status code %d %s: %s",
      url, response$status_code, http_status(response$status_code)$message,
      content(response, as = "text", encoding = "UTF-8")
    ))
  }
}

#' updateUserRole
#'
#' Updates a user's role in the database
#'
#' @param databaseId the id of the database
#' @param userId the (numeric) id of the user to update
#' @param assignment the role assignment, \code{\link[activityinfo]{roleAssignment}}
#' 
#' @examples 
#' \dontrun{
#'
#' databaseId <- "caxadcasdf"
#' updateUserRole(databaseId,
#'   userId = 165,
#'   roleAssignment(
#'     roleId = "admin",
#'     roleResources = databaseId
#'   )
#' )
#' }
#'
#' @importFrom httr POST
#' @export
updateUserRole <- function(databaseId, userId, assignment) {
  stopifnot("userId must be provided to updateUserRole()" = is.character(userId)&&length(userId)==1)
  stopifnot("databaseId must be provided to updateUserRole()" = is.character(databaseId)&&length(databaseId)==1)
  stopifnot("assignment must be created with roleAssignment()" = ("activityInfoRoleAssignment" %in% class(assignment)))
  
  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", userId, "role", sep = "/")
  request <- list(assignments = list(assignment))

  response <- POST(url, body = request, encode = "json", activityInfoAuthentication(), accept_json())
  if (response$status_code != 200) {
    stop(sprintf(
      "Request for %s failed with status code %d %s: %s",
      url, response$status_code, http_status(response$status_code)$message,
      content(response, as = "text", encoding = "UTF-8")
    ))
  } else {
    updatedUser <- fromActivityInfoJson(response)
    checkUserRole(databaseId, updatedUser, assignment$id, assignment$parameters, assignment$resources)
  }
  
  invisible(NULL)
}


#' roleAssignment
#'
#' Creates a role assignment object
#'
#' @param roleId the id of the role to assign to the user
#' @param roleParameters a named list of role parameters, optional
#' @param roleResources a list of resources (database id, folder id, form id, or report id)
#' to assign to this user. Using the database id assigns all resources to this user
#'
#' @examples {
#'   # Role assignment for a reporting role with a partner parameter
#'   roleAssignment(
#'     roleId = "rp",
#'     roleParameters = list(partner = reference(formId = "cxadsfs32", recordId = "c3423423")),
#'     roleResources = "cxa99335"
#'   )
#'
#'
#'   # Role assignment for an administrator role without any role parameters
#'   roleAssignment(
#'     roleId = "admin",
#'     roleResources = c("cxa99335", "c8234234")
#'   )
#' }
#'
#' @export
roleAssignment <- function(roleId, roleParameters = list(), roleResources) {
  stopifnot(is.list(roleParameters))
  if (any(is.na(names(roleParameters)))) {
    stop("roleParameters must be named with each parameter name.")
  }

  if (length(roleParameters) == 0) {
    roleParameters <- NULL
  }

  assignment <- list(id = roleId, parameters = roleParameters, resources = as.list(roleResources))
  class(assignment) <- c("activityInfoRoleAssignment", class(assignment))
  
  assignment
}


#'
#' resourcePermissions
#'
#' Helper method to create a list of permissions for a role or grant.
#'
#' Each argument represents an operation at the level of a resource and may either be TRUE or FALSE.
#'
#' The view, add_record, edit_record, and delete_record permissions may instead
#' be a formula that conditions the permission on the values of the record.
#'
#' @param view View the resource, whether a form, folder, or database.
#' @param add_record Add a record within a form contained by this folder or form.
#' @param edit_record Edit a record's values within a form contained by this folder or form.
#' @param delete_record Delete a record within this form.
#' @param bulk_delete Delete records in bulk
#' @param export_records Export Records from a form, folder or database.
#' @param manage_users Grant permissions to a user to this database, folder, or form.
#' @param lock_records Add, modify, or remove locks on records.
#' @param add_resource  Create a new Resource (Form or Folder).
#' @param edit_resource  Edit a Resource's schema, structure, attributes or data.
#' @param delete_resource Delete a Resource (Form or Folder).
#' @param manage_collection_links  Manage (open/close) collection links for the given form.
#' @param manage_translations add languages to a database, modify translations
#' @param audit Access the Audit logs for a database (or a subset).
#' @param share_reports Allow the user to share reports with other roles in the database.
#' @param publish_reports Allows the user to publish reports.
#' @param manage_roles Add, modify and delete roles.
#' @param manage_reference_data Manage reference data.
#' @param reviewer_only Grant add_record and edit_record permissions for fields in the "reviewer" security category
#' @param discover Discover and display forms 
#' @rdname resourcePermissions
#' @order 1
#' @export
#'
resourcePermissions <- function(view = TRUE,
                        add_record = FALSE,
                        edit_record = FALSE,
                        delete_record = FALSE,
                        export_records = FALSE,
                        lock_records = FALSE,
                        add_resource = FALSE,
                        edit_resource = FALSE,
                        delete_resource = FALSE,
                        bulk_delete = FALSE,
                        manage_collection_links = FALSE,
                        manage_users = FALSE,
                        manage_roles = FALSE,
                        manage_reference_data = FALSE,
                        manage_translations = FALSE,
                        audit = FALSE,
                        share_reports = FALSE,
                        publish_reports = FALSE,
                        reviewer_only = FALSE,
                        discover = FALSE) {
  operations <- setdiff(names(formals()), "reviewer_only")
  
  permissionList <- lapply(operations, function(operation) {
    v <- eval(as.name(operation))
    if (length(v) != 1 || is.na(v) || !(is.logical(v) || is.character(v))) {
      stop(sprintf("Invalid value for operation '%s': %s", operation, deparse(v)))
    }
    v
  })
  names(permissionList) <- operations
  granted <- sapply(permissionList, function(p) p == TRUE || is.character(p))
  
  result <- lapply(operations[granted], function(x) {operationList(x, permissionList, reviewerOnly = reviewer_only)})
  
  class(result) <- c("activityInfoResourcePermissions", class(result))
  
  result
}

#' @rdname resourcePermissions
#' @order 2
#' @export
permissions <- resourcePermissions

operationList = function(operation, permissionList, reviewerOnly = FALSE) {
  p <- list(operation = toupper(operation))
  v <- permissionList[[operation]]
  p$filter <- NULL
  p$securityCategories <- list()
  if (is.character(v)) {
    p$filter <- as.character(v)
  }
  if (toupper(operation) %in% c("EDIT_RECORD", "ADD_RECORD") && isTRUE(reviewerOnly)) {
    p$securityCategories <- list("reviewer")
  }
  p
}

#'
#' databasePermissions
#'
#' Helper method to create a list of database permissions permitted in an administrative role.
#'
#' Each argument may either be TRUE or FALSE.
#'
#' @param manage_automations Manage automations.
#' @param manage_users Manage database users.
#' @param manage_roles Assign roles to users.
#' @export
#'
databasePermissions <- function(manage_automations = FALSE, manage_users = FALSE, manage_roles = FALSE) {
  if (manage_automations&&manage_users&&manage_roles==FALSE) {
    result = list()
    class(result) <- c("activityInfoDatabasePermissions", class(result))
    return(result)
  }
  
  operations <- names(formals())
  
  permissionList <- lapply(operations, function(operation) {
    v <- eval(as.name(operation))
    if (length(v) != 1 || is.na(v) || !(is.logical(v))) {
      stop(sprintf("Invalid value for operation '%s': %s", operation, deparse(v)))
    }
    v
  })
  names(permissionList) <- operations
  granted <- sapply(permissionList, function(p) p == TRUE)

  result <- lapply(operations[granted], function(x) {operationList(x, permissionList)})
  
  class(result) <- c("activityInfoDatabasePermissions", class(result))
  
  result
}


#' updateGrant
#'
#' Adds or updates a grant for a user to a specific resource. 
#' See \link{resourcePermissions} for how to set resource-level permissions for 
#' a grant.
#'
#' @param databaseId the id of the database
#' @param userId the (numeric) id of the user to update
#' @param resourceId the id of the form or folder
#' @param permissions the permissions to grant to the user for the given resource
#'
#' @export
#'
#' @examples
#' \dontrun{
#' updateGrant(
#'   databaseId = "cxy123", user = 165,
#'   resourcePermissions(
#'     add_record = TRUE,
#'     edit_record = TRUE,
#'     delete_record = TRUE
#'   )
#' )
#' }
#'
#' @importFrom httr POST
#' @export
updateGrant <- function(databaseId, userId, resourceId, permissions) {
  path <- paste("databases", databaseId, "users", userId, "grants", sep = "/")
  request <- list(grantUpdates = list(
    list(
      resourceId = resourceId,
      operations = permissions
    )
  ))

  postResource(path, body = request, task = "updateGrant")

  invisible(NULL)
}

#' Add, Update or Delete a role's definition in the database
#' 
#' updateRole() updates the role definition in the database. A role is defined 
#' with the \link{role} function, which implements the grant-based role system 
#' of ActivityInfo. updateRole() will also silently add a new role if the role 
#' id has not yet been used.
#' 
#' addRole() will add a new role definition and will stop the script if the role
#' already exists.
#' 
#' deleteRoles() can take a list of role ids and will delete those. It will 
#' provide a warning if any role id was not found but will continue and delete
#' any ids that do exist.
#' 
#' Older style non-grant roles are deprecated. See \link{resourcePermissions} 
#' for more details for old roles without grants. These will be phased out of 
#' use and should be avoided.
#'
#' @param databaseId the id of the database
#' @param role the role definition
#'
#' @rdname updateRole
#' @order 1
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # Use the current recommended grant-based roles 
#' grantBased = TRUE
#'
#' if (grantBased) {
#'   currentGrantBasedRole <- 
#'     role(id = "rp",
#'         label = "Reporting Partner",
#'         parameters = list(
#'          parameter(id = "partner", label = "Partner", range = "ck5dxt1712")),
#'         grants = list(
#'           grant(resourceId = "cq9xyz1552",
#'             permissions = resourcePermissions(
#'               view = "ck5dxt1712 == @user.partner",
#'              edit_record = "ck5dxt1712 == @user.partner",
#'               discover = TRUE,
#'               export_records = TRUE)),
#'           grant(resourceId = "cz55555555",
#'             permissions = resourcePermissions(
#'              view = TRUE,
#'               discover = TRUE,
#'               add_record = TRUE),
#'             optional = TRUE))
#'         )
#'   updateRole("cxy123", currentGrantBasedRole) 
#' } else {
#'   # These older-style roles will be phased out.
#'   deprecatedNonGrantRole <- list(
#'     id = "rp",
#'     label = "Reporting partner",
#'     permissions = resourcePermissions(
#'       view = "ck5dxt1712 == @user.partner",
#'       edit_record = "ck5dxt1712 == @user.partner",
#'       export_records = TRUE
#'     ),
#'     parameters = list(
#'       list(
#'         id = "partner",
#'         label = "Partner",
#'         range = "ck5dxt1712"
#'       )
#'     ),
#'     filters = list(
#'       roleFilter(
#'         id = "partner",
#'         label = "partner is user's partner",
#'         filter = "ck5dxt1712 == @user.partner"
#'        )
#'     )
#'   )
#'   updateRole("cxy123", deprecatedNonGrantRole)
#' }
#' }
updateRole <- function(databaseId, role) {
  stopifnot("databaseId must be a string" = is.character(databaseId)&&length(databaseId)==1)
  stopifnot("The role must be defined" = is.list(role))
  if (
    !("activityInfoRole" %in% class(role)) && 
    (is.null(role$grantBased)||!role$grantBased)
    ) {
    warning("Old style roles are deprecated. Please update your scripts to use the new grant-based roles.", call. = FALSE, noBreaks. = TRUE)
    path <- paste("databases", databaseId, sep = "/")
    request <- databaseUpdates()
    request$roleUpdates = list(role)
    x <- postResource(path, request, task = "updateRole")
    invisible()
  } else {
    path <- paste("databases", databaseId, sep = "/")
    request = list(roleUpdates = list(role))
    x <- postResource(path, request, task = "a")
    invisible()    
  }
}

#' @rdname updateRole
#' @order 2
#' @export
addRole <- function(databaseId, role) {
  tree <- getDatabaseTree(databaseId)
  if (!any(sapply(tree$roles, function(x) {x$id==role$id}))) {
    updateRole(databaseId, role)
  } else {
    stop(sprintf("The role '%s' already exists. Cannot add new role with the same id. Use updateRole() instead.", role$id))
  }
}

#' @rdname updateRole
#' @order 3
#' @export
deleteRoles <- function(databaseId, roleIds) {
  stopifnot("databaseId must be a string" = is.character(databaseId)&&length(databaseId)==1)
  stopifnot("The roleIds must be a character vector with at least one id" = is.character(roleIds)&&length(roleIds)>0)
  
  path <- paste("databases", databaseId, sep = "/")
  
  request <- databaseUpdates()
  request$roleDeletions = lapply(roleIds, function(x) x)
  
  x <- postResource(path, request, task = "updateRole")
  invisible()
}

#' Create a role parameter to add to a user role definition
#' 
#' Returns a role parameter. 
#' 
#' Parameters are used to set up conditions that can be defined per user when 
#' the role is given to a user or a user is created. A common use-case is to 
#' restrict the user to only edit records related to the reporting partner for 
#' which they work or only the region for which they are responsible. A
#' parameter enables the administrator to set their organization or region when
#' giving them a role.
#' 
#' See \link{role} for the creation of roles.
#'
#' @param id the id of the parameter, for example "partner", which can
#' be used in a formula as "@user.partner" 
#' @param label the label of the partner, for example, "Reporting partner"
#' @param range the id of a reference table, for example the list of partners, 
#' or a formula
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' parameter(id = "partner", label = "Reporting partner", range = "ck5dxt1712")
#' }
parameter <- function(id, label, range) {
  stopifnot("The id must be a character string" = is.null(id)||(is.character(id)&&length(id)==1&&nchar(id)>0))
  stopifnot("The id must start with a letter, must be made of letters and underscores _ and cannot be longer than 32 characters" = is.null(id)||grepl("^[A-Za-z][A-Za-z0-9_]{0,31}$", id))
  stopifnot("The label is required to be a character string" = (is.character(label)&&length(label)==1&&nchar(label)>0))
  stopifnot("The range is required and must be a character string" = !is.null(range)&&(is.character(range)&&length(range)==1&&nchar(range)>0))
  
  result <- list(
    parameterId = id,
    label = label,
    range = range
  )
  
  class(result) <- c("activityInfoParameter", class(result))
  result
}

#' Create a grant to define resource-level permissions
#' 
#' Returns a grant that can be added to a \link{role}. 
#' 
#' Grants define access to resources such as databases, folders, or forms. The
#' permissions include operations such as view, read or edit and are defined per 
#' resource. See \link{resourcePermissions}.
#'  
#' Adding grants to a role enables the administrator to define 
#' permissions that vary per grant and, if desired, override grants inherited 
#' from parent resources, such as a folder. 
#' 
#' A grant can be set as optional, which means that you can choose whether to 
#' enable the grant for each user that you invite to your database.
#' 
#' See \link{role} for the creation of roles.
#'
#' @param resourceId the id of the resource, for example a database, folder or 
#' (sub-)form 
#' @param permissions a permission list; see \link{resourcePermissions}
#' @param optional whether the grant is optional, by default it is not optional 
#' (=FALSE)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' optionalGrant <- 
#'   grant(resourceId = "ck5dxt1552",
#'       permissions = resourcePermissions(
#'         view = TRUE,
#'         add_record = TRUE,
#'         edit_record = TRUE
#'         ),
#'       optional = TRUE
#' )
#' }
grant <- function(resourceId, permissions = resourcePermissions(), optional = FALSE) {
  stopifnot("resourceId must be a string" = is.character(resourceId)&&length(resourceId)==1)
  stopifnot("optional must be a logical/boolean of length 1" = is.logical(optional)&&length(optional)==1)
  stopifnot("activityInfoResourcePermissions" %in% class(permissions))
  
  result = list(
    resourceId = resourceId,
    operations = permissions,
    optional = optional
  )
  
  class(result) <- c("activityInfoGrant", class(result))
  result
}

#' Create a pre-defined legacy role filter
#' 
#' This should no longer be used. Please update your code to use grant-based 
#' roles. This function is deprecated.
#' 
#' Pre-defined filters. Role filters allow other users to choose filters for 
#' permissions without having to write formulas themselves. This is a feature of
#' legacy roles.
#' 
#' @param id the id of the pre-defined filter
#' @param label A human-readable label
#' @param filter A formula that can be used to filter a record-level permission.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' legacyRoleFilter <- 
#'   roleFilter(
#'           id = "partner", 
#'           label = "Partner is user's partner", 
#'           filter = "ck5dxt1712 == @user.partner"
#'           )
#' }
roleFilter <- function(id, label, filter) {
  result = list(
    id = id,
    label = label,
    filter = filter
  )
  class(result) <- c("activityInfoRoleFilter", class(result))
  result
}


#' Create a role
#' 
#' Returns a role that can be added to a database and assigned to users.  
#' 
#' A role contains one or more \link{grant} items that define access to 
#' resources (database, folder, forms).
#'  
#' Some administrative permissions are defined at the level of the role rather 
#' than within grants. See \link{databasePermissions}.
#'
#' @param id the id of the role
#' @param label the label or name of the role, e.g. "Viewer" or "Administrator" 
#' @param parameters a list of \link{parameter} items defining role parameters
#' @param grants a list of \link{grant} items for each resource and their 
#' respective permissions
#' @param permissions \link{databasePermissions} under this role
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Create a Reporting Partner role that may view, and edit their own records 
#' in the form with id "cq9xyz1552" and optional access to view and add records
#' to a form with id "cz55555555". They are also allowed to discover these 
#' forms.
#' 
#' grantBasedRole <- 
#'   role(id = "rp",
#'       label = "Reporting Partner",
#'       parameters = list(
#'         parameter(id = "partner", label = "Partner", range = "ck5dxt1712")),
#'       grants = list(
#'         grant(resourceId = "cq9xyz1552",
#'           permissions = resourcePermissions(
#'             view = "ck5dxt1712 == @user.partner",
#'             edit_record = "ck5dxt1712 == @user.partner",
#'             discover = TRUE,
#'             export_records = TRUE)),
#'         grant(resourceId = "cz55555555",
#'           permissions = resourcePermissions(
#'             view = TRUE,
#'             discover = TRUE,
#'             add_record = TRUE),
#'           optional = TRUE))
#'       )
#'       
#' }
role <- function(id, label, parameters = list(), grants, permissions = databasePermissions()) {
  stopifnot("The id must be a character string" = is.null(id)||(is.character(id)&&length(id)==1&&nchar(id)>0))
  stopifnot("The id must start with a letter, must be made of lowercase letters and underscores _ and cannot be longer than 32 characters" = is.null(id)||grepl("^[a-z][a-z0-9_]{0,31}$", id))
  
  stopifnot("The label is required to be a character string" = (is.character(label)&&length(label)==1&&nchar(label)>0))
  
  stopifnot("parameters must be a list" = is.list(parameters))
  stopifnot("grants must be a list of grants, for example, grants = list(grant(...))" = is.list(grants))
  
  stopifnot("Define management permissions using the databasePermissions() function" = "activityInfoDatabasePermissions" %in% class(permissions))
  
  for(grant in grants) {
    stopifnot("Define each grant using the grant() function" = "activityInfoGrant" %in% class(grant))
  }
  for(param in parameters) {
    stopifnot("Define each parameter using the parameter() function" = "activityInfoParameter" %in% class(param))
  }
  
  result <- list(
    id = id,
    label = label,
    parameters = parameters,
    permissions = permissions,
    grants = grants,
    grantBased = TRUE
  )
    
  class(result) <- c("activityInfoRole", class(result))
  invisible(result)
}
