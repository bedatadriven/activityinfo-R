

#' Queries a form collection as a flat, two-dimensional table.
#' 
#' @param the form to query. This can be an object of type "tree", "class", or the id of the 
#' form as a character. 
#' @param
#' @export
queryTable <- function(form, ...) {
  
  formId <- if (inherits(form, "formtree")) {
    # query the root form of a tree contained in a formtree result
    attr(form, "tree")$root
  } else if (is.character(form)) {
    form
  } else if (is.numeric(form)) {
    # accept an activityId
    paste("a", form, sep="")
  } else {
    # query the root of a form tree
    form$root
  }
  
  columnSet <- getResource(sprintf("form/%s/query/columns", formId), ...)
                      
  df <- lapply(columnSet$columns, function(column) {
    if(identical(column$storage, "array")) {
      column$values
      
    } else if(identical(column$storage, "constant")) {
      if(is.null(column$value)) {
        NA
      } else {
        rep(column$value, length = columnSet$rows)
      }
    } else {
      stop("unknown storage type: ", column$storage)
    }
  })
  class(df) <- "data.frame"
  row.names(df) <- seq.int(1, length.out = columnSet$rows)
  df
}
