

#' Get a resource by path
#'
#' Retrieves a single resource from the given path.
#' Remaining arguments are treated as query parameters
#' and must be named
#'
#' @importFrom httr GET accept_json verbose content http_status modify_url message_for_status
#' @importFrom rjson fromJSON
#' @noRd
getResource <- function(path, queryParams = list(...), ...) {

  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))
  url <- if (length(queryParams) == 0) {
    url
  } else {
    modify_url(url, query = queryParams)
  }

  result <- GET(url, activityInfoAuthentication(), accept_json())

  if (result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  } else {
    message_for_status(result)
  }

  json <- content(result, as = "text", encoding = "UTF-8")

  fromJSON(json)
}

#' postResource
#'
#' @param path path
#' @param body body
#'
#' @importFrom httr POST accept_json verbose content http_status
#' @importFrom rjson fromJSON
#' @noRd
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

#' putResource
#'
#' @param path path
#' @param body body
#'
#' @importFrom httr PUT accept_json verbose content http_status
#' @importFrom rjson fromJSON
#' @noRd
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

