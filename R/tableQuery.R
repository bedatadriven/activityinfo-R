

#' Queries a form collection as a flat, two-dimensional table.
#' 
#' @param the form to query. This can be an object of type "tree", "class", or the id of the 
#' form as a character. 
#' @export
queryTable <- function(form, columns,  ...) {
  
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
    
  if(missing(columns)) {
    columns = list(...)
  }

  stopifnot(length(columns) > 0)
  
  query <- list(
    rowSources = list(
      list(rootFormId = formId)
    ),
    columns = lapply(seq_along(columns), function(i) {
      list(id = names(columns)[i],
           expression = as.character(columns[[i]]))
    })
  )
  
  columnSet <- postResource("query/columns", query)
  
  df <- as.data.frame(
    lapply(columnSet$columns, function(column) {
      switch(column$storage,
             constant = {
               if (is.null(column$value)) {
                 rep(switch(column$type,
                            STRING = NA_character_,
                            NUMBER = NA_real_),
                     columnSet$rows)
               } else {
                 rep(column$value, columnSet$rows)
               }
             },
             array = {
               if (is.list(column$values)) {
                 # one or more of the values is 'NULL'
                 mode <- switch(column$type,
                                STRING = "character",
                                NUMBER = "double",
                                BOOLEAN = "logical")
                 vapply(column$values, na.if.null, vector(mode, 1L), mode = mode)
               } else {
                 column$values
               }
             },
             empty = {
               rep(switch(column$type,
                          STRING = NA_character_,
                          NUMBER = NA_real_),
                   columnSet$rows)
             },
             stop("unknown storage mode '", column$storage, "'")
      )
    }),
    stringsAsFactors = FALSE
  )
  
  # order columns in the same order specified in the query
  df <- df[, names(columns)]
  
  return(df)
}
