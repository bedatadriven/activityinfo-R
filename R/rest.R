

#' Local version of httr::message_for_status
#'
#' This function is deprecated and will be removed soon. It does not try to
#' add a newline anymore since this was causing problems in Rmd outputs.
#'
#' Old description: Equivalent to httr::message_for_status except that we add a
#' newline to the message.
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
  # cat("\n")

  invisible(response)
}

#' Create an ActivityInfo API condition
#'
#' Extends the httr conditions to be able to create specific condition messages for the API.
#'
#' @param result The result of the API call
#' @param type forced type for the condition
#' @param task The task of the request
#' @param call The call stack
#'
#' @importFrom httr http_condition http_error
#' @importFrom rjson fromJSON
activityInfoAPICondition <- function(result, type = NULL, task = NULL, call = sys.call(-1)) {
  if ((http_error(result) && is.null(type)) || (!is.null(type) && type == "error")) {
    condition <- http_condition(result, type = "error", task = task, call = call)
    type <- "error"
    taskMessage <- "%s failed"
  } else {
    if ((result$status_code >= 300 & is.null(type)) || (!is.null(type) && type == "warning")) {
      type <- "warning"
    } else {
      if (is.null(type)) type <- "message"
    }
    condition <- http_condition(result, type = type, task = task, call = call)
    taskMessage <- "%s returned"
  }
  condition$message <- activityInfoAPIConditionMessage(result, type, task, taskMessage)
  condition$result <- content(result)
  class(condition) <- c("activityinfo_api", class(condition))
  condition
}

#' @importFrom httr http_condition http_error status_code content
activityInfoAPIConditionMessage <- function(result, type = "message", task = NULL, taskMessage = "%s returned") {
  if (is.null(task)) task <- sprintf("%s request to %s", result$request$method, result$url)
  # if (!is.character(task)) task <- sprintf("Task object: %s", deparse(task))
  # resultContent <- content(result, as = "text", encoding = "UTF-8")
  resultContent <- content(result)
  if (is.list(resultContent) && !is.null(resultContent$code)) {
    messageString <- ifelse(is.null(resultContent$message), sprintf("See ActivityInfo %s code).", type), resultContent$message)
    return(sprintf(paste0(taskMessage, " with code %s and http status %s: %s\n"), task, status_code(result), resultContent$code, messageString))
  } else {
    return(sprintf(paste0(taskMessage, " with status %d: %s\n"), task, status_code(result), ifelse(type == "message", "success", deparse(resultContent))))
  }
}

#' @importFrom httr http_error status_code
checkForError <- function(result, task = NULL, requireStatus = NULL, call = sys.call(-1)) {
  if (is.null(task) || length(task) == 0 || nchar(task) == 0) {
    task <- "request"
  }
  if (!is.null(requireStatus)) {
    if (!is.numeric(requireStatus)) stop("Required status codes must be provided in a numeric vector.")
    stats::na.fail(requireStatus)
    status <- status_code(result)
    if (any(requireStatus == status)) {
      return(activityInfoAPICondition(result, task = task))
    }
  } else if (!httr::http_error(result)) {
    return(activityInfoAPICondition(result, task = task))
  }
  stop(activityInfoAPICondition(result, type = "error", task = task, call))
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
getResource <- function(path, queryParams = list(), task = NULL, requireStatus = 200, ...) {
  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))
  url <- if (length(queryParams) == 0) {
    url
  } else {
    modify_url(url, query = queryParams)
  }

  if (getOption("activityinfo.verbose.requests")) message("Sending GET request to ", url)

  result <- GET(url, activityInfoAuthentication(), accept_json(), ...)

  condition <- checkForError(result, task = task, requireStatus = requireStatus, call = sys.call(-1))

  if (getOption("activityinfo.verbose.tasks")) message(condition)

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
postResource <- function(path, body, task = NULL, requireStatus = NULL, encode = "json", ...) {
  
  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))

  if (getOption("activityinfo.verbose.requests")) message("Sending POST request to ", url)

  result <- POST(url, body = body, encode = encode, activityInfoAuthentication(), accept_json(), ...)

  condition <- checkForError(result, task = task, requireStatus = requireStatus, call = sys.call(-1))

  if (getOption("activityinfo.verbose.tasks")) message(condition)
  
  json <- content(result, as = "text", encoding = "UTF-8")
  if (!nzchar(json)) {
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
putResource <- function(path, body, task = NULL, requireStatus = NULL, silent = FALSE, encode = "json", ...) {
  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))

  if (getOption("activityinfo.verbose.requests")) message("Sending PUT request to ", url)

  result <- PUT(url, body = body, encode = encode, activityInfoAuthentication(), accept_json(), ...)

  condition <- checkForError(result, task = task, requireStatus = requireStatus, call = sys.call(-1))

  # also display (short) success message:
  if (getOption("activityinfo.verbose.tasks")) message(condition)

  json <- content(result, as = "text", encoding = "UTF-8")
  if (nzchar(json)) {
    return(fromJSON(json))
  }

  invisible()
}

#' deleteResource
#' 
#' @param path path to API endpoint (excluding the base URL and '/resources')
#' @param body body
#' @param task A string to explain what task is being performed. Will be shown if an error occurs.
#'
#' @importFrom httr DELETE accept_json content stop_for_status modify_url
#' @importFrom rjson fromJSON
#' @noRd
deleteResource <- function(path, body = NULL, task = NULL, requireStatus = NULL, silent = FALSE, encode = "json", ...) {
  url <- modify_url(activityInfoRootUrl(), path = c("resources", path))
  
  if (getOption("activityinfo.verbose.requests")) message("Sending DELETE request to ", url)
  
  result <- DELETE(url, body = body, encode = encode, activityInfoAuthentication(), accept_json(), ...)
  
  message(sprintf("DELETE resources task: %s", task))
  
  condition <- checkForError(result, task = task, requireStatus = requireStatus, call = sys.call(-1))
  
  # also display (short) success message:
  if (getOption("activityinfo.verbose.tasks")) message(condition)
  
  json <- content(result, as = "text", encoding = "UTF-8")
  if (nzchar(json)) {
    return(fromJSON(json))
  }
  
  invisible()
}
