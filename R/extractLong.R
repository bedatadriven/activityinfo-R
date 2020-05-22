

#' Extract all quantities from a database in \dQuote{long} format
#'
#' @param database.id the CUID of the database (e.g., "ck2yrizmo2" or "d00000006583")
#' @param folder.id (optional) the id of the folder or form to include. If omitted, the whole database will be included in the export.
#' @return a single data.frame with quantity values in rows, and dimensions in columns.
#' @importFrom httr GET write_disk
#' @export
getQuantityTable <- function(databaseId = NA, folderId) {

  stopifnot(is.character(databaseId))
  
  if(missing(folderId)) {
    parentId <- databaseId
  } else {
    parentId <- folderId
  }
  
  request <- list(type = "exportDatabaseForms",
                  descriptor = list(
                    databaseId = databaseId,
                    folderId = parentId,
                    format = "LONG",
                    fileFormat = "TEXT"
                  ))
  
  job <- postResource("jobs", request)
  
  while(TRUE) {
    status <- activityinfo:::getResource(sprintf("jobs/%s", job$id))
    message("Generating export...")
    if(identical(status$state, "completed")) {
      break;
    }
    if(!identical(status$state, "started")) {
      stop("Error generating export.")
    }
    Sys.sleep(2)
  }
  
  tempFile <- tempfile()
  downloadUrl <- paste(activityInfoRootUrl(), status$result$downloadUrl, sep="/")
  
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

