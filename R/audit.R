AUDIT_LOG_EVENT_TYPES <- c("RECORD", "FORM", "FOLDER", "DATABASE", "LOCK", "USER_PERMISSION", "ROLE")


#' Query the audit log of a database
#'
#' @param databaseId the database identifier.
#' @param before a \emph{Date} or \emph{POSIX} to filter result before a given
#' time; defaults to the time of the query.
#' @param after an optional \emph{Date} or \emph{POSIX} 
#' @param resourceId a resource (i.e. form or folder) identifier to filter on.
#' @param typeFilter a character string with the event type to filter on; default is none.
#' @param limit the maximum number of events to return. Default is 1,000 events.
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
#' The following event type filters are supported:
#' \itemize{
#' \item \emph{RECORD}: changes to records
#' \item \emph{FORM}: changes to form schemas
#' \item \emph{FOLDER}: changes to folders
#' \item \emph{DATABASE}: changes to the database itself (renaming, creation)
#' \item \emph{LOCK}: changes to the database locks
#' \item \emph{USER_PERMISSION}: changes to user permissions
#' \item \emph{ROLE}: changes to roles
#' }
#' @examples 
#' \dontrun{
#' 
#' # Query up to 10,000 records
#' events <- queryAuditLog("cax132253", limit = 10000)
#' 
#' # Query events after the beginning of 2022
#' events <- queryAuditLog("cax132253", after = as.Date("2022-01-01"))
#' 
#' # Query only changes to user permissions
#' events <- queryAuditLog("cax132253", typeFilter = "USER_PERMISSION")

#' }
#' @return A data frame with the results of the query and with three attributes as described in the \emph{Details}
#' section.
#' @export
queryAuditLog <- function(databaseId, before = Sys.time(), after, resourceId = NULL, typeFilter = NULL, limit = 1000) {

  stopifnot(limit >= 1)
  
  as.POSIXct.millis <- function(x) as.POSIXct(x / 1000, origin="1970-01-01")
  as.millis <- function(x) as.numeric(as.POSIXct(x)) * 1000
  
  before <- as.millis(before)
  after <- if(missing(after) || is.null(after)) 0L else as.millis(after)
  afterCt <- as.POSIXct.millis(after)
  
  if (!is.null(typeFilter)) {
    typeFilter <- intersect(typeFilter, AUDIT_LOG_EVENT_TYPES)
    typeFilter <- if (length(typeFilter) == 0L) NULL else typeFilter
  }

  path <- sprintf("databases/%s/audit", databaseId)
  request <- list(resourceFilter = resourceId,
                  typeFilter = as.list(typeFilter),
                  startTime = before)
  events <- NULL
  
  while(TRUE) {
  
    result <- postResource(path = path, body = request, task = "Query audit log")
    
    page <- do.call(rbind, lapply(result$events, function(event) {
      event <- lapply(event, naForNull)
      event$time <- as.POSIXct.millis(event$time)
      if (is.list(event$user)) {
        event$user.id <- event$user$id
        event$user.name <- event$user$name
        event$user.email <- event$user$email
      } else {
        event$user.id <- NA
        event$user.name <- NA
        event$user.email <- NA
      }
      event$user <- NULL
      as.data.frame(event, stringsAsFactors = FALSE)
    }))
    
    message(sprintf("Received %d events...", nrow(page)))
    
    events <- rbind(events, page)
  
    # attach query metadata to the result:
    attr(events, "databaseId") <- databaseId
    attr(events, "moreEvents") <- as.logical(result$moreEvents)
    if(is.null(attr(events, "startTime"))) {
      attr(events, "startTime") <- as.POSIXct.millis(result$startTime)
    }
    attr(events, "endTime") <- as.POSIXct.millis(result$endTime)
    
    # next request should pick up after the end time
    request$startTime <- result$endTime
  
    # exit gracefully if there are no events in the audit log:
    if (!result$moreEvents || result$endTime < after ||  nrow(events) > limit) {
      break
    }
  }
  
  # Apply filters client side
  time <- NULL # ensure package checks do not complain about non-existing global variable
  events <- subset(events, time > afterCt)
  attr(events, "endTime") <- afterCt
  
  if(nrow(events) > limit) {
    events <- events[1:limit, ]
  }
  
  return(events)
}


#' Replace NULL with NA
#'
#' @param x an R object
#'
#' @return Logical NA if \code{x} is \code{NULL}, otherwise \code{x}.
#' @noRd
naForNull <- function(x) {
  if (is.null(x)) NA else x
}
