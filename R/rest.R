

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
  schema <- getResource(paste("database", databaseId, "schema", sep="/"))
  schema$id <- databaseId
  schema
}


#' Returns TRUE if the given object is an activity
#' object included from getDatabaseSchema
#' 
is.activity <- function(activity) {
  is.list(activity) &&
    all(c("name",
          "id",
          "attributeGroups",
          "reportingFrequency",
          "indicators") %in% names(activity))
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

#' Get location types within a country
#' @param country the country's numeric id or an ISO-3166 alpha-2 code (like
#'   'US' or 'SS' or 'RW')
#' @export
getLocationTypes <- function(country) {
  countryId <- lookupCountryId(country)
  getResource(paste("country", countryId, "locationTypes", sep="/"))
}

#' Get administrative levels within a country
#' @param country the country's numeric id or an ISO-3166 alpha-2 code (like
#'   'US' or 'SS' or 'RW')
#' @export
getAdminLevels <- function(country) {
  countryId <- lookupCountryId(country)
  getResource(paste("country", countryId, "adminLevels", sep="/"))
}

#' Gets the locations belonging to a location type
#' @param locationTypeId 
#' @export
getLocations <- function(locationTypeId) {
   getResource("locations", type = locationTypeId)
}

