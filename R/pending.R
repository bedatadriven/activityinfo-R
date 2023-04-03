
#' Imports a pending change set exported from an ActivityInfo offline database.
#' 
#' If a device is no longer able to connect to the internet, you can export
#' the changes queued for synchronization and manually transfer the pending.json
#' file to the database owner, who can use this to send the changes to the server
#' under their own account.
#' 
#' @param file.name The file name/path containing the pending changes
#' 
#' @export
submitPending <- function(file.name) {
  pending <- fromJSON(file = file.name)
  for(p in pending) {
    if(is.null(p$transaction)) next
    updateSet <- p$transaction
    # fix up object for RJSON :-(
    for(i in seq_along(updateSet$changes)) {
      if(is.null(updateSet$changes[[i]]$parentRecordId)) {
        # Remove the property, otherwise rjson turns it into {} rather than null
        updateSet$changes[[i]]$parentRecordId <- NULL
      }
    }
    postResource("update/offline", updateSet)
  }
}