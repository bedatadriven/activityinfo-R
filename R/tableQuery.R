
#' Queries a form as a flat, two-dimensional table
#'
#' @param form form to query. This can be an object of type "tree", "class", or the id of the
#' form as a character.
#' @param columns select columns, see Details
#' @param truncateStrings TRUE if longer strings should be truncated to 128 characters
#' @param truncate.strings Deprecated: please use truncateStrings. TRUE if longer strings should be truncated to 128 characters
#' @param asTibble default is FALSE to return a data.frame; TRUE if a tibble should be returned
#' @param makeNames default is TRUE; FALSE if column names should not be checked and left as-is
#' @param filter an ActivityInfo formula string that limits the records returned
#' @param window an integer vector in the format c(offset, limit) for the number of records to return.
#' @param sort an ActivityInfo sort object that sorts the records returned
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
#' @examples
#' \dontrun{
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
queryTable <- function(form, columns, ..., truncateStrings = TRUE, asTibble = FALSE, makeNames = TRUE, truncate.strings = truncateStrings, filter, window, sort) {
  if (!missing(truncate.strings)) {
    warning("The parameter truncate.strings in queryTable is deprecated. Please switch to from truncate.strings to truncateStrings.", call. = FALSE, noBreaks. = TRUE)
    if (missing(truncateStrings)) {
      truncateStrings <- truncate.strings
    } else if (truncateStrings != truncate.strings) {
      stop("Inconsistent parameters given to queryTable: truncate.strings and truncateStrings should be the same but are not. truncate.strings is now deprecated and should no longer be used.")
    }
  }

  if (inherits(form, "activityInfoFormTree")) {
    # query the root form of a tree
    formId <- form$root
  } else if (inherits(form, "activityInfoFormSchema")) {
    formId <- form$id
  } else if (is.character(form)) {
    formId <- form
  } else {
    stop("Unrecognized form provided to queryTable. Provide an id, form schema or form tree.")
  }

  if (missing(columns)) {
    columns <- list(...)
  }

  if (length(columns) == 0) {
    if ((missing(window)||is.null(window))&&(missing(filter)||is.null(filter))&&(missing(sort)||is.null(sort))) {
      columnSet <- getResource(sprintf("form/%s/query/columns", formId), queryParams=list("_truncate" = truncateStrings), task = sprintf("Getting form %s data.", formId))
      df <- parseColumnSet(columnSet, asTibble, makeNames)
      if (makeNames&&asTibble) {
        names(df) <- make.names(names(df), unique = TRUE)
      }
      attr(df, "offSet") <- columnSet$offset
      attr(df, "rows") <- columnSet$rows
      attr(df, "totalRows") <- columnSet$totalRows
      return(df)
    } else {
      columns = c(list("@id" = "_id", "@lastEditTime" = "_lastEditTime"), prettyColumns(getFormTree(formId)))
    }
  }

  stopifnot(length(columns) > 0)

  if (makeNames) names(columns) <- make.names(names(columns), unique = TRUE)

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

  if (!missing(filter)&&!is.null(filter)) {
    stopifnot(is.character(filter))
    query$filter <- filter
  }

  if (!missing(sort)&&!is.null(sort)) {
    checkSortList(sort)
    query$sort <- sort
  }
  
  if (!missing(window)&&!is.null(window)) {
    stopifnot(is.integer(window)&&length(window)==2&&min(window)>=0)
    query$window <- window
  }
  
  jsonPayload <- toActivityInfoJson(query)
  
  columnSet <- postResource(
    path = "query/columns", 
    body = jsonPayload, 
    task = sprintf("Getting form %s data for specified columns.", formId), 
    requireStatus = NULL, 
    encode = "raw", 
    httr::content_type_json()
    )
  
  df <- parseColumnSet(columnSet, asTibble, makeNames)

  # make sure we have a column for each name
  for (cn in names(columns)) {
    if (!(cn %in% names(df))) {
      df[[cn]] <- rep(NA, times = nrow(df))
    }
  }

  # order columns in the same order specified in the query
  df <- subset(df, subset = TRUE, select = names(columns))
  
  attr(df, "offSet") <- columnSet$offset
  attr(df, "rows") <- columnSet$rows
  attr(df, "totalRows") <- columnSet$totalRows
  
  stopifnot(is.data.frame(df))
  return(df)
}

na.if.null <- function(x) if (is.null(x)) NA else x

parseColumnSet <- function(columnSet, asTibble = TRUE, makeNames = TRUE) {
  if (asTibble) {
    asDf <- dplyr::as_tibble
  } else {
    asDf <- function(x) {
      as.data.frame(x, stringsAsFactors = FALSE, check.names = makeNames)
    }
  }

  asDf(
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
    })
  )
}

checkSortList <- function(sort) {
  force(sort)
  stopifnot(is.list(sort))
  invisible(lapply(sort, function(x) {
    stopifnot(all(names(x) %in% c("dir", "field")))
    stopifnot(x[["dir"]]%in%c("ASC", "DESC"))
    stopifnot(is.character(x[["field"]]))
    stopifnot(is.character(x[["dir"]]))
  }))
}

legacy <- function(domain, id) {
  stopifnot(nchar(domain) == 1)
  stopifnot(is.numeric(id))

  sprintf("%s%010d", domain, id)
}
