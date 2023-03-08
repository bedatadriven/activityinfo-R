
#' Updates a single record
#'
#' @param formId a form id
#' @param recordId a record id
#' @param fieldValues a named list of fields to change
#' @export
updateRecord <- function(formId, recordId, fieldValues) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))
  stopifnot(is.list(fieldValues))

  changes <- list(
    list(
      formId = formId,
      recordId = recordId,
      fields = fieldValues
    )
  )

  postResource(
    path = "update",
    body = list(changes = changes),
    task = sprintf("Updating record %s in form %s", recordId, formId)
  )
}

#' Adds a new record
#'
#' @param formId the id of the form to which the record should be added
#' @param parentRecordId the id of this record's parent record, if the form is a subform
#' @param fieldValues a named list of fields to change
#' @export
addRecord <- function(formId, parentRecordId = NA_character_, fieldValues) {
  stopifnot(is.character(formId))
  stopifnot(is.character(parentRecordId))
  stopifnot(is.list(fieldValues))

  changes <- list(
    list(
      formId = formId,
      recordId = cuid(),
      parentRecordId = parentRecordId,
      fields = fieldValues
    )
  )

  task <- sprintf("Adding record %s to form %s",
                  changes[[1]]$recordId,
                  ifelse(is.na(parentRecordId),
                         formId,
                         sprintf("%s with parentRecordId %s", formId, parentRecordId)
                  )
  )

  postResource(
    path = "update",
    body = list(changes = changes),
    task = task
    )
}

#' Delete a record
#'
#' @description
#' This call deletes a single record for the given \code{formId} and
#' \code{recordId}.
#'
#' @param formId a form id
#' @param recordId a record id
#'
#' @export
deleteRecord <- function(formId, recordId) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))

  changes <- list(
    list(
      formId = formId,
      recordId = recordId,
      deleted = TRUE
    )
  )

  postResource(
    path = "update",
    body = list(changes = changes),
    task = sprintf("Delete record %s in form %s", recordId, formId)
    )
}

#' Gets the list of changes to a record
#'
#' @description
#' This calls retrieves a list of all changes to the record, and the users
#' who are
#'
#' @param formId a form id
#' @param recordId a record id
#' @export
getRecordHistory <- function(formId, recordId) {
  getResource(
    paste("form", formId, "record", recordId, "history", sep = "/"),
    task = sprintf("Get record %s history from form %s", recordId, formId)
    )
}

#' Gets a single record
#'
#' @param formId a form id
#' @param recordId the record Id
#' @export
#'
getRecord <- function(formId, recordId) {
  getResource(
    sprintf("form/%s/record/%s", formId, recordId),
    task = sprintf("Get record %s from form %s", recordId, formId)
    )
}

#' Gets an attachment
#'
#' Retrieve an attachment and store it to a temporary file. The name
#' of the temporary file is returned.
#'
#' @param formId a form id
#' @param recordId the record Id
#' @param fieldId the attachment field id
#' @param blobId the attachment blob id
#' @export
#'
getAttachment <- function(formId, recordId, fieldId, blobId) {
  url <- modify_url(activityInfoRootUrl(), path = sprintf("resources/form/%s/record/%s/field/%s/blob/%s/signature.png",
                                                          formId,
                                                          recordId,
                                                          fieldId,
                                                          blobId))
  message("Sending GET request to ", url)

  tmp <- tempfile()

  result <- GET(url, activityInfoAuthentication(), accept_json(), write_disk(tmp))

  checkForError(result)

  if (result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  } else {
    message_for_status(result)
  }

  tmp
}


#' Create a reference field value
#'
#' @description
#' This call creates a 'reference' field value for the given \code{formId} and
#' \code{recordId}.
#'
#' @param formId the id of the form
#' @param recordId the id of the record
#' @export
reference <- function(formId, recordId) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))

  sprintf("%s:%s", formId, recordId)
}

#' Recover a deleted record
#'
#' @description
#' This call recovers a single deleted record for the given \code{formId} and
#' \code{recordId}.
#'
#' @param formId a form id
#' @param recordId a record id
#'
#' @export
recoverRecord <- function(formId, recordId) {
  stopifnot(is.character(formId))
  stopifnot(is.character(recordId))

  path<-sprintf("form/%s/record/%s/recover",formId,recordId)
  postResource(path = path, NULL, task = sprintf("Recover record %s from form %s", recordId, formId))
}

# ---- Get records ----

#' Get a table of records
#'
#' @description
#' This function will create a reference to records on the server. You can use this like a data.frame or to download the table use the collect() function.
#'
#' @param form a form id, form schema or form tree
#' @param recordId a record id
#' @export
getRecords <- function(form, ...) {
  UseMethod("getRecords")
}
#' @export
getRecords.character <- function(form, style = defaultStyle()) {
  fmTree <- setStyle(getFormTree(form), style = style)
  getRecords(fmTree)
}
#' @export
getRecords.activityInfoFormSchema <- function(form, style){
  fmTree <- getFormTree(form$id)
  if (missing(style)) {
    fmTree <- setStyle(fmTree, style = defaultStyle())
  } else {
    fmTree <- setStyle(fmTree, style = style)
  }
  getRecords(fmTree)
}
#' @export
getRecords.activityInfoFormTree <- function(form, ...) {
  src <- src_activityInfo(form)
  dplyr::tbl(src, form)
}

getRecords.default <- getRecords.character


# ---- Functions to get correct column references ----

# naming can be "id", "label", c("code", "label") or c("code", "id") or "ui"
#' @export
getStyle <- function(x) {
  if (!missing(x)) {
    style <- attr(x, "style")
    if (!is.null(style)) return(style)
  }
  getOption("activityInfoColumnStyle", default = defaultStyle())
}


#' @export
dimnames.activityInfoFormTree <- function(x) {
  style <- getStyle(x)

  list(
    NULL,
    varNames(x, style)
  )
}

#' @export
dim.activityInfoFormTree <- function(x) {
  style <- getStyle(x)
  
  c(
    NA,
    length(varNames(x, style))
  )
}

#' @export
dimnames.tbl_activityInfoRemoteRecords <- function(x) {
  if(x$step$window[2]>0) {
    list(
      as.character(1:x$step$window[2]),
      tblNames(x)
    )
  } else {
    list(
      NULL,
      tblNames(x)
    )
  }
}

#' @export
dim.tbl_activityInfoRemoteRecords <- function(x) {
  c(
    x$step$window[2],
    length(tblNames(x))
  )
}

#' @importFrom dplyr tbl_vars
#' @export
tbl_vars.tbl_activityInfoRemoteRecords <- function(x) {
  tblNames(x)
}

# could some remove dependencies
#' @importFrom rlang rep_named
#' @importFrom dplyr as_tibble
#' @importFrom tidyselect tidyselect_data_proxy tidyselect_data_has_predicates
#' @export
tidyselect_data_proxy.tbl_activityInfoRemoteRecords <- function(x) {
  as_tibble(rep_named(tblNames(x), list(logical())), .name_repair = "minimal")
}

#' @export
tidyselect_data_has_predicates.tbl_activityInfoRemoteRecords <- function(x) {
  FALSE
}

#' @export
names.tbl_activityInfoRemoteRecords <- function(x) {
  colnames(x)
}

#' @export
dimnames.activityInfoFormSchema <- dimnames.activityInfoFormTree
dimnames.activityInfoRemoteRecords <- dimnames.activityInfoFormSchema

elementVarName <- function(y, style) {
  colNameStyle <- style$columnNames[[1]]

  if(colNameStyle == "code") {
    colName <- y[["code"]]
    if(is.null(colName)) {
      if (length(style$columnNames)>1&&style$columnNames[[2]] %in% c("label", "id")) {
        colNameStyle <- style$columnNames[[2]]
      } else {
        colNameStyle <- "id"
      }
    }
  }


  if (colNameStyle == "ui") {
    colName <- trimws(y[["label"]])
  } else {
    # need to add escaping of labels
    if(colNameStyle == "label") {
      if(nchar(y[["label"]])>255) {
        colNameStyle <- "id"
      } else {
        colName <- trimws(y[["label"]])
        if (!grepl("^[\\p{L}\\p{M}]+$", colName, perl = TRUE)) {
          colName <- sprintf("[%s]", colName)
        }
      }
    }

    if (colNameStyle == "id") {
      colName <- y[["id"]]
    }
  }


  colName
}

#' @export
prettyColumns <- function(x, select) {
  styleId <- getStyle()
  styleId$columnNames <- "id"
  styleId$allReferenceFields = FALSE
  styleId$referencedKey = TRUE


  styleUI <- styleId
  styleUI$columnNames <- "ui"
  styleId$allReferenceFields = FALSE
  styleId$referencedKey = TRUE

  columns <- varNames(x, styleId)
  names(columns) <- varNames(x, styleUI)

  selectColumns(columns, select)
}

#' @export
styleColumns <- function(x, select) {
  styleTbl <- getStyle(x)

  styleVars <- styleTbl
  if (styleVars$columnNames[[1]]=="ui") {
    styleVars$columnNames <- "id"
  }

  columns <- varNames(x, styleVars)
  names(columns) <- varNames(x, styleTbl)

  selectColumns(columns, select)
}

selectColumns <- function(columns, select) {
  if(!missing(select)) {
    stopifnot("select must be a character vector of column names." = is.character(select))
    columns <- columns[select]
    columns[sapply(columns, is.null)] <- NULL
  }
  columns
}

#' @export
setStyle <- function(x = NULL,
    referencedId = TRUE,
    referencedKey = TRUE,
    allReferenceFields = FALSE,
    columnNames = c("code", "label"),
    recordId = FALSE,
    lastEditedTime = FALSE, 
    style) {

  if(!missing(style)) {
    args <- names(environment())
    stopifnot(is.list(style)&&identical(names(style), args[2:length(args)-1]))
    stopifnot("activityInfoColumnStyle" %in% class(style))
  } else {
    style <- list(
      "referencedId" = referencedId,
      "referencedKey" = referencedKey,
      "allReferenceFields" = allReferenceFields,
      "columnNames" = columnNames,
      "recordId" = recordId,
      "lastEditedTime" = lastEditedTime
    )
    class(style) <- c("activityInfoColumnStyle", class(style))
  }


  if (!is.null(x)) {
    attr(x, "style") <- style
    return(x)
  } else {
    return(style)
  }
}

defaultStyle <- function() setStyle()

allFieldsStyle <- function(columnNames = c("code", "label")) {
  setStyle(referencedId = TRUE,
           referencedKey = TRUE,
           allReferenceFields = TRUE,
           columnNames = columnNames,
           recordId = TRUE,
           lastEditedTime = TRUE)
}

#' @export
varNames <- function(x, style) {
  UseMethod("varNames")
}
#' @export
varNames.activityInfoFormTree <- function(x, style = getStyle(x)) {
  fmSchema <- x$forms[[x$root]]

  vrNames <- character()

  if (style$recordId) vrNames[length(vrNames)+1] <- "_id"
  if (style$lastEditedTime) vrNames[length(vrNames)+1] <- "_lastEditTime"

  c(vrNames, unlist(lapply(fmSchema$elements, function(y) {

    colName <- NULL

    if (inherits(y,"activityInfoReferenceFieldSchema")) {

      refFieldName <- elementVarName(y, style)

      if (style$referencedId) colName <- refFieldName

      if (style$referencedKey||style$allReferenceFields){
        refId <- y$typeParameters$range[[1]]$formId
        refFormSchema <- x$forms[[refId]]
        refFormSchemaKey <- lapply(refFormSchema$elements, function(z) {
          if (z$key) {
            z
          } else {
            if (style$allReferenceFields) {
              z
            } else {
              NULL
            }
          }
        })
        refFormSchemaKey <- refFormSchemaKey[lengths(refFormSchemaKey)!=0]
        colName <- c(colName, unlist(lapply(refFormSchemaKey, function(z) {
          if (style$columnNames[[1]] == "ui") {
            paste0(refFieldName, " ", elementVarName(z, style))
          } else {
            paste0(refFieldName, ".", elementVarName(z, style))
          }
        })))
      }

    } else {
      colName <- elementVarName(y, style)
    }

    colName

  })))
}
#' @export
varNames.activityInfoFormSchema <- function(x, style = getStyle(x)) {
  varNames(getFormTree(x$id), style)
}

varNames.tbl_activityInfoRemoteRecords <- function(x) {
  x$step$vars
}

#elementToVarName(style)



# ---- Lazy remote table ----


#' @export
tbl.src_activityInfo <- function(src, formTree, ...) {
  stopifnot(formTree$root %in% dplyr::src_tbls(src))

  totalRecords = getTotalRecords(formTree)

  dplyr::make_tbl(
    c("activityInfoRemoteRecords", "lazy"),
    "src" = src,
    "formTree" = formTree,
    "step" = firstStep(formTree, totalRecords),
    "totalRecords" = totalRecords
  )
}

#' @export
getTotalRecords <- function(formTree) {
  df <- queryTable(formTree$root, columns = list("id"="_id"), asTibble = TRUE, makeNames = FALSE, window = c(0L,1L))
  totalRecords <- attr(df, "totalRows")
  if (totalRecords==0) {
    # required to check the formTree as queryTable used in totalRecords does not error if there are no permissions but returns 0 rows
    formTree <- getFormTree(formTree$root)
    df <- queryTable(formTree$root, columns = list("id"="_id"), asTibble = TRUE, makeNames = FALSE, window = c(0L,1L))
    totalRecords <- attr(df, "totalRows")
  }
  totalRecords
}


#' @export
#' @importFrom dplyr collect
collect.tbl_activityInfoRemoteRecords <- function(x, ...) {
    queryTable(
      x$formTree, 
      columns = tblColumns(x), 
      asTibble = TRUE, 
      makeNames = FALSE, 
      filter = tblFilter(x),
      window = tblWindow(x)
    )
}

#' #' @export
#' format.tbl_activityInfoRemoteRecords <- function(x) {
#'   format(collect(adjustWindow(x, offSet = 0L, limit = 2L)))
#' }


#' @importFrom pillar tbl_format_header style_subtle align
#' @export
tbl_format_header.tbl_activityInfoRemoteRecords <- function(x, setup, ...) {
  # The setup object may know the total number of rows
  
  window <- tblWindow(x)
  
  named_header <- list(
    src = class(x$src),
    label = x$formTree$forms[[x$formTree$root]]$label,
    totalRecords = x$totalRecords,
    Vars = x$step$vars,
    filter <- tblFilter(x),
    sort = "Not yet implemented",
    window = sprintf("offSet: %d; Limit: %d", window[1], window[2])
  )
  
  # Adapted from pillar
  header <- paste0(
    align(paste0(names(named_header), ":")),
    " ",
    named_header
  )
  
  style_subtle(paste0("# ", header))
}

# select.tbl_activityInfoRemoteRecords <- function(x) {
#   
# }

#' @export
addFilter <- function(x, formulaFilter) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  stopifnot("ActivityInfo formula filter must be a character vector", is.character(formulaFilter))
  
  x$step <- newStep(x$step, filter = x$filter)
  
  x
}

#' @importFrom utils head
#' @export
head.tbl_activityInfoRemoteRecords <- function(x, n = 6L, ...) {
  n <- as.integer(n)
  adjustWindow(x, offSet = 0L, limit = n)
}


#' @importFrom utils tail
#' @export
tail.tbl_activityInfoRemoteRecords <- function(x, n = 6L, ...) {
  n <- as.integer(n)
  adjustWindow(x, offSet = max(0L, x$step$window[2] - n), limit = n)
}

#' @export
as.data.frame.tbl_activityInfoRemoteRecords <- function(x, ...) {
  as.data.frame(collect(x))
}

#' @export
adjustWindow <- function(x, offSet = 0L, limit) {
  stopifnot(offSet>=0&&is.integer(offSet))
  if(missing(limit)) {
    window <- c(x$step$window[1] + offSet, x$step$window[2])
    x$step <- newStep(x$step, window = window)
  } else {
    stopifnot(limit>=0)
    stopifnot(is.integer(limit))
    window <- c(x$step$window[1] + offSet, min(x$step$window[2], limit))
    x$step <- newStep(x$step, window = window)
  }
  x
}

#' @export
tblColumns <- function(x) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  columns <- styleColumns(x$formTree)
  columns[x$step$vars]
}

tblNames <- function(x) {
  x$step$vars
}

#' @export
tblFilter <- function(x) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  step <- x$step
  combinedFilter <- character()
  
  repeat{
    combinedFilter <- c(step$filter, combinedFilter)
    if(!exists("parent", where = x)){
      break
    }
    step <- step$parent
  }

  if (length(combinedFilter)>0) {
    return(paste0("(", combinedFilter, ")", collapse = "&&"))
  } else {
    ""
  }
}

tblWindow <- function(x, limit) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  window <- x$step$window
  if (!missing(limit)) {
    window[2] <- min(window[2], limit)
  }
  window
}
# ---- Lazy steps ----

firstStep <- function(formTree, totalRecords = 256, vars = varNames(formTree), columns = styleColumns(formTree)) {
  step <- list(
    "vars" = vars, 
    "columns" = columns, 
    "filter" = NULL, 
    "window" = c(0L, as.integer(totalRecords)))
  class(step) <- c("activityInfoStep")
  step
}

newStep <- function(parent, vars = parent$vars, columns = parent$columns, filter = parent$filter, window = parent$window) {
  stopifnot(inherits(parent, "activityInfoStep"))
  step <- list(
    "parent" = parent,
    "vars" = vars, 
    "columns" = columns, 
    "filter" = filter, 
    "window" = window)
  class(step) <- c("activityInfoStep")
  step
}

# ---- Source ----

src_activityInfo <- function(x) {
  UseMethod("src_activityInfo")
}
src_activityInfo.formTree <- function(x) {
  dplyr::src(subclass = c("activityInfoFormTree", "activityInfo"), formTree = x, url <- activityInfoRootUrl())
}
src_activityInfo.databaseTree <- function(x) {
  dplyr::src(subclass = c("activityInfoDatabaseTree", "activityInfo"), databaseTree = x, url <- activityInfoRootUrl())
}

# #' @export
# dplyr::src_tbls

#' @export
src_tbls.src_activityInfoFormTree <- function(x, ...) {
  names(x$formTree$forms)
}
#' @export
src_tbls.src_activityInfoDatabaseTree <- function(x, ...) {
  getDatabaseResources(x)$id
}

# ---- Verbs ----

select.activityInfoRemoteRecords <- function() {
  stop("Please first use collect() to download the table. select() is not yet implemented for records on the server.")
}

