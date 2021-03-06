
#' Queries a form as a flat, two-dimensional table
#'
#' @param the form to query. This can be an object of type "tree", "class", or the id of the
#' form as a character.
#' @param columns select columns
#' @param truncate.strings TRUE if longer strings should be truncated to 128 characters
#' @examples \dontrun{
#' queryTable("a2145507918", columns = c(
#' id="_id",
#' name="Name",
#' campId="camp",
#' camp="Camp.Name",
#' governorate="Camp.Governorate.Name",
#' teachers="teachers",
#' students="students",
#' type="[Type of School]"
#' ))
#' }
#' @references
#' \href{ActivityInfo Formulas Manual}{http://help.activityinfo.org/m/77022}
#' @export
queryTable <- function(form, columns,  ..., truncate.strings = TRUE) {

  formId <- if (inherits(form, "formtree")) {
    # query the root form of a tree contained in a formtree result
    attr(form, "tree")$root
  } else if (is.character(form)) {
    form
  } else if (is.numeric(form)) {
    # accept an activityId
    site.form.id(form)
  } else {
    # query the root of a form tree
    form$root
  }

  if(missing(columns)) {
    columns = list(...)
  }

  if(length(columns) == 0) {
    return(parseColumnSet(getResource(sprintf("form/%s/query/columns", formId))))
  }

  stopifnot(length(columns) > 0)
  
  names(columns) <- make.names(names(columns), unique = TRUE)

  query <- list(
    rowSources = list(
      list(rootFormId = formId)
    ),
    columns = lapply(seq_along(columns), function(i) {
      list(id = names(columns)[i],
           expression = as.character(columns[[i]]))
    }),
    truncateStrings = truncate.strings
  )

  columnSet <- postResource("query/columns", query)
  df <- parseColumnSet(columnSet)
  
  # make sure we have a column for each name
  for(cn in names(columns)) {
    if(!(cn %in% names(df))) {
      df[[cn]] <- NA
    }
  }

  # order columns in the same order specified in the query
  df <- subset(df, subset = TRUE, select = names(columns))

  stopifnot(is.data.frame(df))
  return(df)
}

na.if.null <- function(x) if(is.null(x)) NA else x

parseColumnSet <- function(columnSet) {
  as.data.frame(
    lapply(columnSet$columns, function(column) {
      cv <- switch(column$storage,
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
                 as.vector(sapply(column$values, na.if.null), mode = mode)
               } else {
                 column$values
               }
             },
             empty = {
               rep(switch(column$type,
                          STRING = NA_character_,
                          NUMBER = NA_real_,
                          NA),
                   columnSet$rows)
             },
             stop("unknown storage mode '", column$storage, "'")
      )
      if(length(cv) != columnSet$rows) {
        str(column)
        stop("Internal error: Column length is inconsistent. Contact support@activityinfo.org")
      }
      cv
    }),
    stringsAsFactors = FALSE
  )
}
