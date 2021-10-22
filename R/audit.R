

#' Query the audit log of a database
#'
#' @param databaseId the database identifier.
#' @param before a (UNIX) timestamp (in milliseconds) to filter result before a given time; defaults to the time of the
#' query.
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
queryAuditLog <- function(databaseId, before = as.numeric(Sys.time())*1000, resourceId = NULL, typeFilter = NULL) {

  stopifnot(is.numeric(before))

  if (!is.null(typeFilter)) {
    typeFilter <- intersect(typeFilter, c("RECORD", "FORM", "FOLDER", "DATABASE", "LOCK", "USER_PERMISSION", "ROLE"))
    typeFilter <- if (length(typeFilter) == 0L) NULL else typeFilter
  }

  payload <- list(resourceFilter = resourceId,
                  typeFilter = as.list(typeFilter),
                  startTime = before)

  result <- postResource(sprintf("databases/%s/audit", databaseId), body = payload, task = "query audit log")

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

  attr(events, "databaseId") <- databaseId
  attr(events, "moreEvents") <- as.logical(result$moreEvents)
  attr(events, "startTime") <- as.numeric(result$startTime)
  attr(events, "endTime") <- as.numeric(result$endTime)

  events
}


#' Replace NULL with NA
#'
#' @param x an R object
#'
#' @noRd
na_for_null <- function(x) {
  if (is.null(x)) NA else x
}
