

#' Query a pivot table report
#'
#' @param reportId The report idenitifier
#'
#' @return A data frame with the pivot table data.
#' @export
queryReportResults <- function(reportId) {

  rows <- getResource(path = sprintf("reports/%s/rows", reportId))

  columnNames <- unique(unlist(lapply(rows, names)))
  columns <- lapply(columnNames, function(cn) sapply(rows, function(r) {
    if(is.null(r[[cn]])) {
      NA
    } else {
      r[[cn]]
    }
  }))
  names(columns) <- columnNames
  as.data.frame(columns)
}
