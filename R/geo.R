

#' Get an admin level by ID
#' 
#' Retrieves all entities belonging to an administrative level with the given
#' identifier.
#' 
#' @importFrom httr GET accept_json verbose content
#' @importFrom rjson fromJSON
#' @export
getAdminLevel <- function(id) {
  
  warning("the getAdminLevel() function is deprecated, ",
          "please use getAdminLevelEntities() instead")
  
  url <- paste(activityInfoRootUrl(), "resources", "adminLevel", id, "entities", sep = "/")
  
  result <- GET(url, activityInfoAuthentication(), accept_json())
  
  if(result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d: %s",
                 url, result$status_code, result$headers$statusmessage))
  }
  
  json <- content(result, as = "text", encoding = "UTF-8")
  
  fromJSON(json)
}

#' Get all entities belonging to an administrative level by ID
#' 
#' Retrieves all entities belonging to an administrative level with the given
#' identifier.
#' 
#' @export
getAdminLevelEntities <- function(id) {
    getResource(paste("adminLevel", id, "entities", sep="/"))
}
