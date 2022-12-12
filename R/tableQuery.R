
#' Queries a form as a flat, two-dimensional table
#'
#' @param form form to query. This can be an object of type "tree", "class", or the id of the
#' form as a character.
#' @param columns select columns, see Details
#' @param truncateStrings TRUE if longer strings should be truncated to 128 characters
#' @param truncate.strings Deprecated: please use truncateStrings. TRUE if longer strings should be truncated to 128 characters
#' @param filter an ActivityInfo formula string that limits the records returned
#' @param ... If columns parameter is empty, the additional arguments are used as columns.
#' @details To select columns, you can use
#' \itemize{
#'   \item \code{_id} to get the record identifier,
#'   \item \code{_lastEditTime} to get the (Unix) timestamp (in seconds),
#'   \item the identifier of the form field (e.g. \code{ck849fbaw4}),
#'   \item the field code (e.g. \code{TOT_BNF}),
#'   \item the field label, enclosed in brackets if it contains spaces (e.g. \code{[Type of school]})
#' }
#' If you want to select a column in a reference form or in a parent form, use a period to create a path to the desired
#' column. For example:
#' \itemize{
#'   \item \code{parent._id} will select the identifier of the parent record and
#'   \item \code{Camp.Name} will select the \sQuote{Name} field in the \sQuote{Camp} form.
#' }
#' @references
#' Unix time, Wikipedia \url{https://en.wikipedia.org/wiki/Unix_time}
#' @examples \dontrun{
#' queryTable("a2145507918", columns = c(
#'   id = "_id",
#'   name = "Name",
#'   campId = "camp",
#'   camp = "Camp.Name",
#'   governorate = "Camp.Governorate.Name",
#'   teachers = "teachers",
#'   students = "students",
#'   type = "[Type of School]"
#' ))
#' }
#' @export
queryTable <- function(form, columns, ..., truncateStrings = TRUE, truncate.strings = truncateStrings, filter) {
  if (!missing(truncate.strings)) {
    warning("The parameter truncate.strings in queryTable is deprecated. Please switch to from truncate.strings to truncateStrings.", call. = FALSE, noBreaks. = TRUE)
    if (missing(truncateStrings)) {
      truncateStrings <- truncate.strings
    } else if (truncateStrings != truncate.strings) {
      stop("Inconsistent parameters given to queryTable: truncate.strings and truncateStrings should be the same but are not. truncate.strings is now deprecated and should no longer be used.")
    }
  }

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

  if (missing(columns)) {
    columns <- list(...)
  }

  if (length(columns) == 0) {
    return(parseColumnSet(getResource(sprintf("form/%s/query/columns", formId), task = sprintf("Getting form %s data.", formId))))
  }

  stopifnot(length(columns) > 0)

  names(columns) <- make.names(names(columns), unique = TRUE)

  query <- list(
    rowSources = list(
      list(rootFormId = formId)
    ),
    columns = lapply(seq_along(columns), function(i) {
      list(
        id = names(columns)[i],
        expression = as.character(columns[[i]])
      )
    }),
    truncateStrings = truncateStrings
  )

  if (!missing(filter)) {
    stopifnot(is.character(filter))
    query$filter <- filter
  }

  columnSet <- postResource("query/columns", query, task = sprintf("Getting form %s data for specified columns.", formId))
  df <- parseColumnSet(columnSet)

  # make sure we have a column for each name
  for (cn in names(columns)) {
    if (!(cn %in% names(df))) {
      df[[cn]] <- rep(NA, times = nrow(df))
    }
  }

  # order columns in the same order specified in the query
  df <- subset(df, subset = TRUE, select = names(columns))

  stopifnot(is.data.frame(df))
  return(df)
}

na.if.null <- function(x) if (is.null(x)) NA else x

parseColumnSet <- function(columnSet) {
  as.data.frame(
    lapply(columnSet$columns, function(column) {
      cv <- switch(column$storage,
        constant = {
          if (is.null(column$value)) {
            rep(
              switch(column$type,
                STRING = NA_character_,
                NUMBER = NA_real_
              ),
              columnSet$rows
            )
          } else if (column$type == "BOOLEAN" && !identical(column$value, TRUE) && !identical(column$value, FALSE)) {
            rep(NA, columnSet$rows)
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
              BOOLEAN = "logical"
            )
            as.vector(sapply(column$values, na.if.null), mode = mode)
          } else {
            column$values
          }
        },
        empty = {
          rep(
            switch(column$type,
              STRING = NA_character_,
              NUMBER = NA_real_,
              NA
            ),
            columnSet$rows
          )
        },
        stop("unknown storage mode '", column$storage, "'")
      )
      if (length(cv) != columnSet$rows) {
        # TODO: replace usage of 'str' with something that prints a summary of the column to the console
        # str(column)
        stop("Internal error: Column length is inconsistent. Contact support@activityinfo.org")
      }
      cv
    }),
    stringsAsFactors = FALSE
  )
}
