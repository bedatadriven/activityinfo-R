

#' get_ai_resource
#' 
#' Retrieves a single resource from the given path.
#' Remaining arguments are treated as query parameters
#' and must be named
#' 
#' @importFrom httr GET accept_json verbose 
#' @importFrom rjson fromJSON 
getResource <- function(path, ...) {
  
  queryParams <- list(...)
  queryString <- if(length(queryParams) == 0) 
                    NULL
                  else 
                    paste(names(queryParams), queryParams, collapse="&", sep="=")
  
  url <- paste(activityInfoRootUrl(), "resources", path, sep = "/")
  url <- paste(url, queryString, sep="?")
  
  result <- GET(url,
      authenticate(), 
      accept_json(), ...) 
  
  if(result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d: %s",
                 url, result$status_code, result$headers$statusmessage))
  }
  
  json <- content(result, as = "text", encoding = "UTF-8")
  
  fromJSON(json)
}

#' getSites
#' 
#' Fetches a list of sites for the given activity. 
#' 
#' @export
getSites <- function(activityId, ...)
  getResource("sites", activity = activityId, ...)

#' GetDatabaseSchema
#' 
#' Retrieves the schema (activities, indicators, and attributes) from
#' for the given database
#' @export
getDatabaseSchema <- function(databaseId) { 
  schema <- getResource(paste("database", databaseId, "schema", sep="/"))
  schema$id <- databaseId
  schema
}

#' GetCountries
#' 
#' @export
getCountries <- local({
  
  # this can be cached, no need to request
  # multiple times per session
  countries <- NULL
  
  function() {
    if(is.null(countries)) {
      countries <<- getResource("countries")
    }
    data.frame( id = extractField(countries, "id"),
                code = extractField(countries, "code"),
                name = extractField(countries, "name"))
  }
})
