AUDIT_LOG_EVENT_TYPES <- c("RECORD", "FORM", "FOLDER", "DATABASE", "LOCK", "USER_PERMISSION", "ROLE")


#' Query the audit log of a database
#'
#' @param databaseId the database identifier.
#' @param before a \emph{Date}, \emph{POSIX}, or (UNIX) timestamp (in milliseconds) to filter result before a given
#' time; defaults to the time of the query.
#' @param after an optional \emph{Date}, \emph{POSIX} or numeric value representing a UNIX timestamp (in milliseconds).
#' @param resoureId a resource (i.e. form or folder) identifier to filter on.
#' @param typeFilter a character string with the event type to filter on; default is none.
#'
#' @details A database audit log contains details on a wide variety of events in the database. These events include the
#' deletion of records or adding a user. This function queries the audit log and returns the event details as a data
#' frame. Note that each query returns a maximum of 100 events, therefore the data frame has three attributes to help
#' you query older log entries:
#' \itemize{
#' \item \emph{databaseId}: the database identifier;
#' \item \emph{moreEvents}: if \code{TRUE} then there are more (older) entries to be queried;
#' \item \emph{startTime}: the (UNIX) timestamp which is essentially the same as the time provided in the \code{before}
#' argument of the query;
#' \item \emph{endTime} the earliest timestamp of the range, which can be used to query the next set of entries.
#' }
#'
#' @examples \dontrun{
#' # keep querying the audit log until no more events are found:
#' events <- queryAuditLog("asjdhewhasd", typeFilter = "RECORD")
#' r <- events
#' while (isTRUE(attr(r, "moreEvents"))) {
#'   r <- queryAuditLog("asjdhewhasd", before = attr(r, "endTime"), typeFilter = "RECORD")
#'   events <- rbind(events, r)
#' }
#' }
#' @return A data frame with the results of the query and with three attributes as described in the \emph{Details}
#' section.
#' @export
queryAuditLog <- function(databaseId, before = Sys.time(), after = NULL, resourceId = NULL, typeFilter = NULL) {

  before <- datetime_to_epoch(before, milliseconds = TRUE)
  stopifnot(is.numeric(before))

  if (!is.null(typeFilter)) {
    typeFilter <- intersect(typeFilter, AUDIT_LOG_EVENT_TYPES)
    typeFilter <- if (length(typeFilter) == 0L) NULL else typeFilter
  }

  path <- sprintf("databases/%s/audit", databaseId)

  # internal function to repeate queries if necessary:
  query_audit_log <- function(before) {
    payload <- list(resourceFilter = resourceId,
                    typeFilter = as.list(typeFilter),
                    startTime = before)

    result <- postResource(path = path, body = payload, task = "query audit log")

    # exit gracefully if there are no events in the audit log:
    if (length(result$events) == 0L) return()

    events <- do.call(rbind, lapply(result$events, function(event) {
      event <- lapply(event, na_for_null)
      if ("user" %in% names(event)) {
        event$user.id <- event$user$id
        event$user.name <- event$user$name
        event$user.email <- event$user$email
        event$user <- NULL
      }
      as.data.frame(event, stringsAsFactors = FALSE)
    }))

    # attach query metadata to the result:
    attr(events, "databaseId") <- databaseId
    attr(events, "moreEvents") <- as.logical(result$moreEvents)
    attr(events, "startTime") <- as.numeric(result$startTime)
    attr(events, "endTime") <- as.numeric(result$endTime)

    events
  }

  events <- query_audit_log(before)
  if (is.null(events)) {
    warning("no events found in the audit log")
    return()
  }

  if (!is.null(after)) {
    after <- datetime_to_epoch(after, milliseconds = TRUE)
    stopifnot(is.numeric(after))

    if (after > before) stop("the 'after' argument cannot be greater than 'before'")

    r <- events
    while (isTRUE(attr(r, "moreEvents")) && min(r$time) > after) {
      r <- query_audit_log(before = attr(r, "endTime"))
      events <- rbind(events, r)
    }

    # there are more events if there are queried events before 'after' OR if the last query has the moreEvents attribute
    # set to TRUE:
    attr(events, "moreEvents") <- events$time < after || attr(r, "moreEvents")

    attr(events, "startTime") <- before
    attr(events, "endTime") <- after

    # remove events which come before the 'after' timestamp:
    events <- events[events$time >= after,]
  }

  events$time <- epoch_to_datetime(events$time, milliseconds = TRUE)

  events
}


#' Replace NULL with NA
#'
#' @param x an R object
#'
#' @return Logical NA if \code{x} is \code{NULL}, otherwise \code{x}.
#' @noRd
na_for_null <- function(x) {
  if (is.null(x)) NA else x
}


#' Convert a date or POSIX object to a UNIX epoch
#'
#' @param x an R object
#' @param milliseconds a logical value to indicate if the timestamp should be in milliseconds; default is \code{TRUE}.
#'
#' @return Either \code{x} itself or a UNIX timestamp if \code{x} has either the \emph{Date} or the \emph{POSIX} class.
#' @noRd
datetime_to_epoch <- function(x, milliseconds = TRUE) {
  if (isTRUE(milliseconds)) c <- 1000 else c <- 1

  # Date or POSIX* class:
  if (inherits(x, "Date") || inherits(x, "POSIXct")) {
    x <- as.POSIXlt(x)
    return(as.double(x) * c)
  }

  # any other class:
  x
}


#' Convert a UNIX epoch to a POSIXlt object
#'
#' @param x A numeric value which represents a UNIX epoch
#' @param milliseconds A logical to indicate if \code{x} is in milliseconds, or not.
#'
#' @return An object of class \emph{POSIXlt}.
#' @noRd
epoch_to_datetime <- function(x, milliseconds = TRUE) {
  stopifnot(is.numeric(x))

  if (isTRUE(milliseconds)) c <- 1000 else c <- 1

  as.POSIXlt(x / c, origin = "1970-01-01")
}