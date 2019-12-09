

#' Get a resource by path
#' 
#' Retrieves a single resource from the given path.
#' Remaining arguments are treated as query parameters
#' and must be named
#' 
#' @importFrom httr GET accept_json verbose content http_status
#' @importFrom rjson fromJSON
#' @export
getResource <- function(path, queryParams = list(...), ...) {
  
  queryString <- if(length(queryParams) == 0) 
                    NULL
                  else 
                    paste(names(queryParams), queryParams, collapse="&", sep="=")
  
  url <- paste(activityInfoRootUrl(), "resources", path, sep = "/")
  url <- paste(url, queryString, sep="?")
  
  result <- GET(url, activityInfoAuthentication(), accept_json())
  
  if (result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  }
  
  json <- content(result, as = "text", encoding = "UTF-8")
  
  fromJSON(json)
}

#' @importFrom httr POST accept_json verbose content http_status
#' @importFrom rjson fromJSON
#' @export
postResource <- function(path, body) {

  url <- paste(activityInfoRootUrl(), "resources", path, sep = "/")

  result <- POST(url, body = body, encode = "json",  activityInfoAuthentication(), accept_json())
  
  if (result$status_code < 200 || result$status_code >= 300) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  }
  
  json <- content(result, as = "text", encoding = "UTF-8")
  
  fromJSON(json)
}


#' @importFrom httr PUT accept_json verbose content http_status
#' @importFrom rjson fromJSON
#' @export
putResource <- function(path, body) {
  
  url <- paste(activityInfoRootUrl(), "resources", path, sep = "/")
  
  result <- PUT(url, body = body, encode = "json",  activityInfoAuthentication(), accept_json())
  
  if (result$status_code < 200 || result$status_code >= 300) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  }
  
  json <- content(result, as = "text", encoding = "UTF-8")
  if(length(json) > 0) {
    invisible(NULL)
  } else {
    fromJSON(json)
  }
}

#' getSites
#' 
#' Fetches a list of sites for the given activity. 
#' 
#' @export
getSites <- function(activityId, ...)
  getResource("sites", activity = activityId, ...)


#' getDatabaseSchema
#'
#' Retrieves the schema (partners, activities, indicators and attributes) from
#' for the given database
#'
#' @param databaseId database identifier
#' @export
getDatabaseSchema <- function(databaseId) {
  schema <- getResource(paste("databases", databaseId, sep="/"))
  schema
}

