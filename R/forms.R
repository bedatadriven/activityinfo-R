



extractOldId <- function(s) {
  if (all(grepl("^[[:alpha:]]0*", s))) {
    as.integer(sub("^[[:alpha:]]0*", "", s))
  } else {
    s
  }
}


queryForm <- function(form, queryType = c("rows", "columns"), ...) {
  
  formId <- if (inherits(form, "formtree")) {
    # query the root form of a tree contained in a formtree result
    attr(form, "tree")$root
  } else if (is.character(form)) {
    # query using a form identifier
    form
  } else {
    # query the root of a form tree
    form$root
  }
  
  getResource(sprintf("form/%s/query/%s", formId, match.arg(queryType)), ...)
}

