

#' Extract all quantities from a database in \dQuote{long} format
#'
#' @param databaseId the CUID of the database (e.g., "ck2yrizmo2" or "d00000006583")
#' @param folderId (optional) the id of the folder or form to include. If omitted, the whole database will be included in the export.
#' @param includeBlanks if TRUE, the export will include a row for quantity fields with blank values. Default is FALSE.
#' @return a single data.frame with quantity values in rows, and dimensions in columns.
#' @importFrom httr GET write_disk modify_url
#' @importFrom utils read.table
#' @export
getQuantityTable <- function(databaseId = NA, folderId, includeBlanks = FALSE) {

  stopifnot(is.character(databaseId))
  
  if(missing(folderId)) {
    parentId <- databaseId
  } else {
    parentId <- folderId
  }
  
  status <- executeJob( "exportDatabaseForms", list(
    databaseId = databaseId,
    folderId = parentId,
    format = "LONG",
    includeBlanks = includeBlanks,
    fileFormat = "TEXT"
  ))
  
  tempFile <- tempfile()
  downloadUrl <- modify_url(activityInfoRootUrl(), path=status$result$downloadUrl)
  
  GET(downloadUrl, write_disk(tempFile, overwrite=TRUE), activityInfoAuthentication())
  
  read.table(tempFile, 
             sep = "\u001F", 
             quote = "", 
             comment.char = "", 
             na.strings = "", 
             stringsAsFactors = FALSE, 
             encoding = "UTF-8", 
             header = TRUE)
}

executeJob <- function(type, descriptor, progress = FALSE) {
  
  request <- list(type = type,
                  locale = "en",
                  descriptor = descriptor)
  
  job <- postResource("jobs", request)
  
  while(TRUE) {
    status <- getResource(sprintf("jobs/%s", job$id))
    pct <- as.integer(status$percentComplete)
    if(is.na(pct) || length(pct) != 1) {
      pct <- 0L
    }
    if(progress) {
      message(sprintf("Waiting for %s job to complete: %d%%", type, pct))
    }
    if(identical(status$state, "completed")) {
      break
    }
    if(!identical(status$state, "started")) {
      stop(sprintf("Job %s failed. Code: %s, Message: %s", 
                   job$id,
                   status$error$code, 
                   status$error$message))
    }
    Sys.sleep(2)
  }
  invisible(status)
}
