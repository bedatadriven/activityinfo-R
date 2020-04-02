


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
  getDatabaseTree(databaseId)
}

#' getDatabaseTree
#'
#' Retrieves the database's tree of resources that are visible to the authenticated
#' user. 
#'
#' @param databaseId database identifier
#' @examples \dontrun{
#' getDatabaseSchema("ck2k93muu2")
#' }
#' @export
getDatabaseTree <- function(databaseId) {
  tree <- getResource(paste("databases", databaseId, sep="/"))
  class(tree$resources) <- "databaseResources"
  class(tree) <- "databaseTree"
  tree
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

#' inviteUser
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
#' @export
addDatabaseUser <- function(databaseId, email, name, locale = NA_character_, roleId, roleParameters = list(), roleResources = list(databaseId)) {
  
  request <- list(email = email,
                  name = name,
                  locale = locale,
                  role = list(
                    id = roleId,
                    parameters = roleParameters,
                    resources = as.list(databaseId)
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