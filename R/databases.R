


#' getDatabases()
#'
#' Retrieves a list of databases the authenticated user owns, or has been shared with
#'
#' @export
getDatabases <- function() {
  getResource("databases")
}


#' getDatabaseSchema
#'
#' Retrieves the schema (partners, activities, indicators and attributes) from
#' for the given database.
#'
#' @param databaseId database identifier
#' @examples \dontrun{
#' getDatabaseSchema("ck2k93muu2")
#' }
#' @export
#' @noRd
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
#' @examples \dontrun{
#' getDatabaseTree("ck2k93muu2")
#' }
#' @export
getDatabaseTree <- function(databaseId) {
  tree <- getResource(paste("databases", databaseId, sep="/"))
  class(tree$resources) <- "databaseResources"
  class(tree) <- "databaseTree"
  tree
}


#' @export
print.databaseTree <- function(tree) {
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
#' @export
getDatabaseUsers <- function(databaseId) {
  users <- getResource(paste("databases", databaseId, "users", sep="/"))
  users
}

#' getDatabaseUser
#'
#' Retrieves a user's role and permissions
#'
#' @export
getDatabaseUser <- function(databaseId, userId) {
  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", userId, "grants",  sep="/")
  result <- GET(url, activityInfoAuthentication(), accept_json())

  if(result$status_code == 200) {
    return(fromJSON(content(result, as = "text", encoding = "UTF-8")))
  } else if(result$status_code == 404) {
    return(NULL)
  } else {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
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
#' @param roleId the id of the role to assign to the user
#' @param roleParameters a named list containing the role parameter values
#' @param roleResources a list of folders in which this role should be assigned (or the databaseId if they should have this role in the whole database)
#'
#'
#'
#' @export
addDatabaseUser <- function(databaseId, email, name, locale = NA_character_, roleId,
                            roleParameters = list(),
                            roleResources = list(databaseId)) {

  request <- list(email = email,
                  name = name,
                  locale = locale,
                  role = list(
                    id = roleId,
                    parameters = roleParameters,
                    resources = roleResources
                  ))

  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", sep = "/")

  response <- POST(url, body = request, encode = "json", activityInfoAuthentication(), accept_json())

  result <- list()
  if(response$status_code == 200) {
    return(list(added = TRUE,
                user = fromJSON(content(response, as = "text", encoding = "UTF-8"))))

  } else if(response$status_code == 400) {
    return(list(added = FALSE,
                error = fromJSON(content(response, as = "text", encoding = "UTF-8"))))
  } else {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, response$status_code, http_status(response$status_code)$message,
                 content(response, as = "text", encoding = "UTF-8")))

  }
}

#' deleteDatabaseUser
#'
#' Deletes a user from a database
#'
#' @param databaseId the id of the database
#' @param userId the (numeric) id of the user to remove from the database.
#'
#' @importFrom httr DELETE
#' @export
deleteDatabaseUser <- function(databaseId, userId) {

  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", userId, sep = "/")

  response <- DELETE(url, activityinfo:::activityInfoAuthentication())

  if(response$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, response$status_code, http_status(response$status_code)$message,
                 content(response, as = "text", encoding = "UTF-8")))
  }
}

#' updateUserRole
#'
#' Updates a user's role in the database
#'
#' @param databaseId the id of the database
#' @param userId the (numeric) id of the user to update
#' @param assignment the as
#'
#' @importFrom httr DELETE
#' @export
updateUserRole <- function(databaseId, userId, assignment) {

  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, "users", userId, "role", sep = "/")
  request <- list(assignments = list(assignment))

  response <- POST(url, body = request, encode = "json", activityInfoAuthentication(), accept_json())
  if(response$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, response$status_code, http_status(response$status_code)$message,
                 content(response, as = "text", encoding = "UTF-8")))
  }
  invisible(NULL)
}

#' Updates a role's definition in the database
#'
#' @param databaseId the id of the database
#' @param role the role definition,
#'
#'
#' @export
#' @examples \dontrun{
#' updateRole("cxy123", list(
#    id = "rp",
#    label = "Reporting partner",
#   permissions = list(
#   list(
#     operation = "VIEW",
#     filter = "ck5dxt1712 == @user.partner"),
#   list(
#     operation = "EDIT_RECORD",
#     filter = "ck5dxt1712 == @user.partner",
#     securityCategories = list()
#   ),
#   list(
#     operation = "EXPORT_RECORDS"
#   )
# ),
# parameters = list(
#   list(
#     parameterId = "partner",
#     label = "Partner",
#     range = "ck5dxt1712"
#   )
# ),
# filters = list(
#   list(id = "partner",
#        label = "partner is user's partner",
#        filter = "ck5dxt1712 == @user.partner")
# )
# ))
#'
#' }
#'
updateRole <- function(databaseId, role) {

  url <- paste(activityInfoRootUrl(), "resources", "databases", databaseId, sep = "/")

  request <- list(roleUpdates = list(role))
  response <- POST(url, body = request, encode = "json", activityInfoAuthentication(), accept_json())
  if(response$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, response$status_code, http_status(response$status_code)$message,
                 content(response, as = "text", encoding = "UTF-8")))
  }
  invisible(NULL)
}
