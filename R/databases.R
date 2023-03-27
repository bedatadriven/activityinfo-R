#' getDatabases()
#'
#' Retrieves a list of databases the authenticated user owns, or has been shared
#'  with
#'
#' @param asDf Default is false but if TRUE will return the list of databases as a dataframe.
#'
#' @export
getDatabases <- function(asDf = FALSE) {
  x <- getResource("databases", task = "Getting all databases")
  if (asDf) {
    do.call(rbind, lapply(x, data.frame))
  } else {
    x
  }
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
#' This function is deprecated in favor of getDatabaseTree(). Please use getDatabaseTree().
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
  postResource(
    "databases",
    body = list(
      id = databaseId,
      label = label,
      templateId = "blank"
      ),
    task = sprintf("Creating new database '%s' with id %s", label, databaseId)
    )
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
    message(sprintf("Deletion of database %s confirmed.", databaseId))
    return(result)
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
#' Retrieves the list of users with access to the database.
#'
#' @param databaseId The database ID
#'
#' @export
getDatabaseUsers <- function(databaseId) {
  users <- getResource(
    paste("databases", databaseId, "users", sep = "/"),
    task = sprintf("Getting list of database %s users", databaseId)
  )

  users
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
    return(fromJSON(content(result, as = "text", encoding = "UTF-8")))
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
#' @export
getDatabaseUser2 <- function(databaseId, userId) {
  url <- paste("databases", databaseId, "users", userId, "grants", sep = "/")
  getResource(url, task = sprintf("Request for database/user %s/%s", databaseId, userId))
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
                            roleResources = list(databaseId)) {

  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", sep = "/")

  request <- list(
    email = email,
    name = name,
    locale = locale,
    role = list(
      id = roleId,
      parameters = roleParameters,
      resources = roleResources
    ),
    grants = list()
  )
  # fix conversion to empty json array by changing it to an empty json object
  jsonPayload <- stringr::str_replace(string = jsonlite::toJSON(request, auto_unbox = TRUE), pattern = '"parameters":\\[\\]', replacement = '"parameters":{}')

  response <- POST(url, body = jsonPayload, encode = "raw", activityInfoAuthentication(), accept_json(), httr::content_type_json())

  if (response$status_code == 200) {
    return(list(
      added = TRUE,
      user = fromJSON(content(response, as = "text", encoding = "UTF-8"))
    ))
  } else if (response$status_code == 400) {
    return(list(
      added = FALSE,
      error = fromJSON(content(response, as = "text", encoding = "UTF-8"))
    ))
  } else {
    stop(sprintf(
      "Request for %s failed with status code %d %s: %s",
      url, response$status_code, http_status(response$status_code)$message,
      content(response, as = "text", encoding = "UTF-8")
    ))
  }
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
  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", userId, "role", sep = "/")
  request <- list(assignments = list(assignment))

  response <- POST(url, body = request, encode = "json", activityInfoAuthentication(), accept_json())
  if (response$status_code != 200) {
    stop(sprintf(
      "Request for %s failed with status code %d %s: %s",
      url, response$status_code, http_status(response$status_code)$message,
      content(response, as = "text", encoding = "UTF-8")
    ))
  }
  invisible(NULL)
}


#' roleAssignment
#'
#' Creates a role assignment object
#'
#' @param roleId the id of the role to assign to the user
#' @param roleParameters a named list of parameters, if the role has any parameters
#' @param roleResources the list of resources (database, folder, form, or report)
#' to assign to this user. Using the databaseId assigns all resources to this user
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
    stop("roleParameters must be named.")
  }

  if (length(roleParameters) == 0) {
    roleParameters <- NULL
  }

  list(id = roleId, parameters = roleParameters, resources = as.list(roleResources))
}


#'
#' permissions
#'
#' Helper method to create a list of permissions for a role or grant.
#'
#' Each argument may either be TRUE or FALSE.
#'
#' The view, add_record, edit_record, and delete_record permissions may instead
#' be a formula that conditions the permission on the values of the record.
#'
#' @param view View the resource, whether a form, folder, or database.
#' @param add_record Add a record within a form contained by this folder or form
#' @param edit_record Edit a record's values within a form contained by this folder or form.
#' @param delete_record Delete a record within this form.
#' @param export_records Export Records from a form, folder or database.
#' @param manage_users Grant permissions to a user to this database, folder, or form.
#' @param lock_records Add, modify, or remove locks on records.
#' @param add_resource  Create a new Resource (Form or Folder)
#' @param edit_resource  Edit a Resource's schema, structure, attributes or data.
#' @param delete_resource Delete a Resource (Form or Folder)
#' @param manage_collection_links  Manage (open/close) collection links for the given form
#' @param audit Access the Audit logs for a database (or a subset)
#' @param share_reports Allow the user to share reports with other roles in the database.
#' @param publish_reports Allows the user to publish reports.
#' @param manage_roles Add, modify and delete roles
#' @param manage_reference_data Manage reference data
#'
#' @export
#'
permissions <- function(view = TRUE,
                        add_record = FALSE,
                        edit_record = FALSE,
                        delete_record = FALSE,
                        export_records = FALSE,
                        lock_records = FALSE,
                        add_resource = FALSE,
                        edit_resource = FALSE,
                        delete_resource = FALSE,
                        manage_collection_links = FALSE,
                        manage_users = FALSE,
                        manage_roles = FALSE,
                        manage_reference_data = FALSE,
                        audit = FALSE,
                        share_reports = FALSE,
                        publish_reports = FALSE) {
  operations <- names(formals())
  permissions <- lapply(operations, function(operation) {
    v <- eval(as.name(operation))
    if (length(v) != 1 || is.na(v) || !(is.logical(v) || is.character(v))) {
      stop(sprintf("Invalid value for operation '%s': %s", operation, deparse(v)))
    }
    v
  })
  names(permissions) <- operations
  granted <- sapply(permissions, function(p) p == TRUE || is.character(p))
  lapply(operations[granted], function(operation) {
    p <- list(operation = toupper(operation))
    v <- permissions[[operation]]
    message(deparse(v), "\n")
    if (is.character(v)) {
      p$filter <- as.character(v)
    }
    p
  })
}




#' updateUserGrant
#'
#' Adds or updates a grant for a user to a specific resource.
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
#'   permissions(
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

#' Updates a role's definition in the database
#'
#' @param databaseId the id of the database
#' @param role the role definition,
#'
#'
#' @export
#'
#' @examples
#' \dontrun{
#' updateRole("cxy123", list(
#'   id = "rp",
#'   label = "Reporting partner",
#'   permissions = permissions(
#'     view = "ck5dxt1712 == @user.partner",
#'     edit_record = "ck5dxt1712 == @user.partner",
#'     export_records = TRUE
#'   ),
#'   parameters = list(
#'     list(
#'       parameterId = "partner",
#'       label = "Partner",
#'       range = "ck5dxt1712"
#'     )
#'   ),
#'   filters = list(
#'     list(
#'       id = "partner",
#'       label = "partner is user's partner",
#'       filter = "ck5dxt1712 == @user.partner"
#'     )
#'   )
#' ))
#' }
#'
updateRole <- function(databaseId, role) {
  path <- paste("databases", databaseId, sep = "/")
  request <- list(roleUpdates = list(role))
  postResource(path, request, task = "updateRole")

  invisible()
}
