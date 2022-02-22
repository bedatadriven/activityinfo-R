

#' Local version of httr::message_for_status
#'
#' Equivalent to httr::message_for_status except that we add a newline to the message.
#'
#' @param x a response object
#' @param task text for message
#'
#' @importFrom httr message_for_status
#' @return If request was successful, the response (invisibly)
#' @noRd
message_for_status <- function(x, task = NULL) {
  response <- httr::message_for_status(x, task = task)
  # add a newline which 'httr::message_for_status' annoyingly doesn't include:
  cat("\n")

  invisible(response)
}

checkForError <- function(result, task = "<unset>") {
  if(status_code(result) >= 400) {
    e <- content(result)
    if(is.list(e) && !is.null(e$code) && !is.null(e$message)) {
      stop(sprintf("Request %s failed with code %s: %s", task, e$code, e$message)) 
    } else {
      stop(sprintf("Request %s failed with status %d: %s", task, status_code(result), deparse(e)))
    }
  }
}


#' Get a resource by path
#'
#' Retrieves a single resource from the given path.
#' Remaining arguments are treated as query parameters
#' and must be named
#'
#' @importFrom httr GET accept_json content http_status modify_url
#' @importFrom rjson fromJSON
#' @noRd
getResource <- function(path, queryParams = list(...), ...) {

  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))
  url <- if (length(queryParams) == 0) {
    url
  } else {
    modify_url(url, query = queryParams)
  }

  message("Sending GET request to ", url)

  result <- GET(url, activityInfoAuthentication(), accept_json())

  checkForError(result)
  
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
#' @importFrom httr POST accept_json content stop_for_status status_code modify_url
#' @importFrom rjson fromJSON
#' @noRd
postResource <- function(path, body, task = NULL) {

  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))
  
  if (is.null(task)) task <- sprintf("perform POST request to %s", url)
  
  message("Sending POST request to ", url)

  result <- POST(url, body = body, encode = "json",  activityInfoAuthentication(), accept_json())

  checkForError(result, task)
  
  # also display (short) success message:
  message_for_status(result)

  json <- content(result, as = "text", encoding = "UTF-8")
  if(!nzchar(json))  {
    return(invisible())
  }
  fromJSON(json)
}

#' putResource
#'
#' @param path path to API endpoint (excluding the base URL and '/resources')
#' @param body body
#' @param task A string to explain what task is being performed. Will be shown if an error occurs.
#'
#' @importFrom httr PUT accept_json content stop_for_status modify_url
#' @importFrom rjson fromJSON
#' @noRd
putResource <- function(path, body, task = NULL) {

  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))

  message("Sending PUT request to ", url)

  result <- PUT(url, body = body, encode = "json",  activityInfoAuthentication(), accept_json())

  if (is.null(task)) task <- sprintf("perform PUT request to %s", url)
  
  checkForError(result, task)
  
  # also display (short) success message:
  message_for_status(result)

  json <- content(result, as = "text", encoding = "UTF-8")
  if(nzchar(json)) return(fromJSON(json))

  invisible()
}

