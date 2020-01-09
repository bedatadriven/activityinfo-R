


#' getDatabaseSchema
#'
#' Retrieves the schema (partners, activities, indicators and attributes) from
#' for the given database.
#'
#' @param databaseId database identifier
#' @examples \dontrun{
#' getDatabaseSchema("ck2k93muu2")
#' }
#' @export
#' @noRd
getDatabaseSchema <- function(databaseId) {
  getDatabaseTree(databaseId)
}

#' getDatabaseTree
#'
#' Retrieves the database's tree of resources that are visible to the authenticated
#' user. 
#'
#' @param databaseId database identifier
#' @examples \dontrun{
#' getDatabaseSchema("ck2k93muu2")
#' }
#' @export
getDatabaseTree <- function(databaseId) {
  tree <- getResource(paste("databases", databaseId, sep="/"))
  class(tree$resources) <- "databaseResources"
  class(tree) <- "databaseTree"
  tree
}
