

#' Get a resource by path
#'
#' Retrieves a single resource from the given path.
#' Remaining arguments are treated as query parameters
#' and must be named
#'
#' @importFrom httr GET accept_json content http_status modify_url message_for_status
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
#' @importFrom httr POST accept_json content stop_for_status message_for_status modify_url
#' @importFrom rjson fromJSON
#' @noRd
postResource <- function(path, body, task = NULL) {

  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))

  result <- POST(url, body = body, encode = "json",  activityInfoAuthentication(), accept_json())

  if (is.null(task)) task <- sprintf("perform POST request to %s", url)
  stop_for_status(result, task = task)

  # also display (short) success message:
  message_for_status(result)

  json <- content(result, as = "text", encoding = "UTF-8")
  if(length(json) > 0) {
    invisible()
  } else {
    fromJSON(json)
  }
}

#' putResource
#'
#' @param path path to API endpoint (excluding the base URL and '/resources')
#' @param body body
#' @param task A string to explain what task is being performed. Will be shown if an error occurs.
#'
#' @importFrom httr PUT accept_json content stop_for_status message_for_status modify_url
#' @importFrom rjson fromJSON
#' @noRd
putResource <- function(path, body, task = NULL) {

  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))

  result <- PUT(url, body = body, encode = "json",  activityInfoAuthentication(), accept_json())

  if (is.null(task)) task <- sprintf("perform PUT request to %s", url)
  stop_for_status(result, task = task)

  # also display (short) success message:
  message_for_status(result)

  json <- content(result, as = "text", encoding = "UTF-8")
  if(length(json) > 0) {
    invisible()
  } else {
    fromJSON(json)
  }
}

