
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
#' @param style a column style object that defines how table columns should be created from a form; use columnStyle() to create a new style; default column styles can be set with an option or setDefaultColumnStyle()
#' @export
getRecords <- function(form, style) {
  UseMethod("getRecords")
}
#' @export
getRecords.activityInfoFormTree <- function(form, style = defaultColumnStyle()) {
  src <- src_activityInfo(form)
  dplyr::tbl(src, form, style)
}

#' @export
getRecords.activityInfo_tbl_df <- function(form, style) {
  x <- attr(form, "remoteRecords")
  if (missing(style)) {
    return(x)
  } else {
    getRecords(x$formTree, style)
  }
}  

#' @export
getRecords.character <- function(form, style = defaultColumnStyle()) {
  fmTree <- getFormTree(form)
  getRecords(form = fmTree, style = style)
}
#' @export
getRecords.activityInfoFormSchema <- getRecords.character
getRecords.default <- getRecords.character

# ---- Column styles ----

columnStyle <- function(
    referencedId = TRUE,
    referencedKey = TRUE,
    allReferenceFields = FALSE,
    columnNames = c("code", "label"),
    recordId = TRUE,
    lastEditedTime = TRUE, 
    style) {
  stopifnot(is.logical(referencedId))
  stopifnot(is.logical(referencedKey))
  stopifnot(is.character(columnNames))
  stopifnot(is.logical(recordId))
  stopifnot(is.logical(lastEditedTime))
  if(!missing(style)) {
    stopifnot(is.list(style))
    stopifnot("activityInfoColumnStyle" %in% class(style))
    args <- as.list(match.call())[-1]
    invisible(lapply(names(args), function(y) {
      if (y!="style") {
        style[y] <<- args[[y]]
      }
      NULL
    }))
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
  
  style
}

#' @export
prettyColumnStyle <- function(referencedId = TRUE, allReferenceFields = FALSE, recordId = TRUE, lastEditedTime = TRUE) {
  columnStyle(referencedId = referencedId,
              referencedKey = TRUE,
              allReferenceFields = allReferenceFields,
              columnNames = "pretty",
              recordId = recordId,
              lastEditedTime = lastEditedTime)
}

#' @export
allColumnStyle <- function(columnNames = c("code", "label")) {
  columnStyle(referencedId = TRUE,
              referencedKey = TRUE,
              allReferenceFields = TRUE,
              columnNames = columnNames,
              recordId = TRUE,
              lastEditedTime = TRUE)
}

#' @export
idColumnStyle <- function() {
  allColumnStyle(columnNames = "id")
}

defaultColumnStyle <- function(style) {
  if(missing(style)) {
    getOption("activityInfoColumnStyle", default = columnStyle())
  } else {
    stopifnot("Style object must be of class activityInfoColumnStyle" = "activityInfoColumnStyle" %in% class(style))
    options(activityInfoColumnStyle = style)
  }
}

# ---- Query table column helpers ----

#' @export
prettyColumns <- function(x, select, ...) {
  styleUI <- prettyColumnStyle(...)
  
  styleId <- styleUI
  styleId$columnNames <- "id"
  
  columns <- varNames(x, styleId)
  names(columns) <- varNames(x, styleUI)
  
  selectColumns(columns, select)
}

#' @export
styledColumns <- function(x, select, style = defaultColumnStyle(), forceId = FALSE) {
  stopifnot("activityInfoColumnStyle" %in% class(style))
  
  styleVars <- style
  if (styleVars$columnNames[[1]]=="pretty"||forceId) {
    styleVars$columnNames <- "id"
  }
  
  columns <- varNames(x, styleVars)
  names(columns) <- varNames(x, style)
  
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


# ---- (Dim)names ----

#' @export
dimnames.activityInfoFormTree <- function(x) {
  list(
    NULL,
    varNames(x)
  )
}

#' @export
dim.activityInfoFormTree <- function(x) {
  c(
    NA,
    length(varNames(x))
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


#' @export
names.tbl_activityInfoRemoteRecords <- function(x) {
  colnames(x)
}

#' @export
dimnames.activityInfoFormSchema <- dimnames.activityInfoFormTree
dimnames.activityInfoRemoteRecords <- dimnames.activityInfoFormSchema


# ---- Tidy select and tbl_vars extensions ---- 

#' @importFrom dplyr tbl_vars
#' @export
tbl_vars.tbl_activityInfoRemoteRecords <- function(x) {
  tblNames(x)
}

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

# ---- Form schema to column variables ----

#' @export
varNames <- function(x, style, addNames) {
  UseMethod("varNames")
}
#' @export
varNames.activityInfoFormTree <- function(x, style = defaultColumnStyle(), addNames = FALSE) {
  fmSchema <- x$forms[[x$root]]

  vrNames <- character()

  if (style$recordId) vrNames[length(vrNames)+1] <- "_id"
  if (style$lastEditedTime) vrNames[length(vrNames)+1] <- "_lastEditTime"

  vrNames <- c(vrNames, unlist(lapply(fmSchema$elements, function(y) {
    elementVars(element = y, formTree = x, style = style, namedElement = FALSE)
  })))
  
  if(addNames) {
    names(vrNames) <- vrNames
  }
  
  vrNames
}

#' @export
varNames.activityInfoFormSchema <- function(x, style = defaultColumnStyle(), addNames = FALSE) {
  varNames(getFormTree(x$id), style)
}

#' @export
varNames.tbl_activityInfoRemoteRecords <- function(x, addNames = TRUE) {
  y <- x$step$vars
  if (!addNames) {
    unname(y)
  }
  y
}

#' @export
namedElementVarList <- function(formTree, style = defaultColumnStyle()) {
  fmSchema <- formTree$forms[[formTree$root]]
  
  unlist(lapply(fmSchema$elements, function(x) {
    elementVars(element = x, formTree = formTree, style = style, namedElement = TRUE)
  }), recursive = FALSE)
}

elementVars <- function(element, formTree, style = defaultColumnStyle(), namedElement = FALSE) {
  
  elementList <- list()
  
  if (inherits(element,"activityInfoReferenceFieldSchema")) {
    
    refFieldName <- elementVarName(element, style)
    
    if (style$referencedId) {
      elementList <- c(elementList, list(element))
      names(elementList) <- refFieldName
    }
    
    if (style$referencedKey||style$allReferenceFields){
      refId <- element$typeParameters$range[[1]]$formId
      refFormSchema <- formTree$forms[[refId]]
      refFormSchemaElements <- lapply(refFormSchema$elements, function(z) {
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
      
      refFormSchemaElements <- refFormSchemaElements[lengths(refFormSchemaElements)!=0]
      
      names(refFormSchemaElements) <- unlist(lapply(refFormSchemaElements, function(z) {
        if (style$columnNames[[1]] == "pretty") {
          paste0(refFieldName, " ", elementVarName(z, style))
        } else {
          paste0(refFieldName, ".", elementVarName(z, style))
        }
      }))
      
      elementList <- c(elementList, refFormSchemaElements)
    }
    
  } else {
    elementList <- c(elementList, list(element))
    names(elementList) <- elementVarName(element, style)
  }
  
  if (namedElement) {
    return(elementList)
  } else {
    return(names(elementList))
  }
}

elementVarName <- function(y, style) {
  stopifnot(style$columnNames %in% c("pretty", "label", "code", "id"))
  
  colNameStyle <- style$columnNames[[1]]
  
  colName = NULL
  
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
  
  if (colNameStyle == "pretty") {
    colName <- trimws(y[["label"]])
  } else {
    # need to add escaping of labels
    if(colNameStyle == "label") {
      if(nchar(y[["label"]])>255) {
        colNameStyle <- "id"
      } else {
        colName <- trimws(y[["label"]])
        
        if (!grepl(pattern = "^[A-Za-z_][A-Za-z0-9_]*$", colName)) {
        # check with Alex on non ASCII letters:
        #if (!grepl("^[\\p{L}\\p{M}]+$", colName, perl = TRUE)) {
          colName <- sprintf("[%s]", colName)
        }
      }
    }
    
    if (colNameStyle == "id") {
      colName <- y[["id"]]
    }
  }
  
  if(is.null(colName)) {
    stop("No column name found. Check with package maintainer.")
  }
  
  colName
}



# ---- Lazy remote table ----


#' @export
tbl.src_activityInfo <- function(src, formTree, style = defaultColumnStyle(),...) {
  stopifnot(formTree$root %in% dplyr::src_tbls(src))

  totalRecords = getTotalRecords(formTree)
  step = firstStep(formTree, style, totalRecords)
  idStyle <- style
  idStyle$columnNames <- "id"
  
  elements = namedElementVarList(formTree = formTree, style = idStyle)
  
  dplyr::make_tbl(
    c("activityInfoRemoteRecords", "lazy"),
    "src" = src,
    "formTree" = formTree,
    "style" = style,
    "columns" = step$columns,
    "step" = step,
    "elements" = elements,
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
addFilter <- function(x, formulaFilter) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  stopifnot("ActivityInfo formula filter must be a character vector" = is.character(formulaFilter))
  
  x$step <- newStep(x$step, filter = formulaFilter)
  
  x
}

#' @export
addSort <- function(x, sort) {
  checkSortList(sort)
  if (!is.null(x$step$sort)) {
    newSort <- x$step$sort
    invisible(lapply(sort, function(y) {
      newSort[[length(newSort)+1]] <<- y
    }))
    x$step <- newStep(x$step, sort = newSort)
  } else {
    x$step <- newStep(x$step, sort = sort)
  }
  x
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
  columns <- x$step$columns
  columns[x$step$vars]
}

tblNames <- function(x) {
  x$step$vars
}

tblFieldTypes <- function(x) {
  columns <- tblColumns(x)
  types <- unlist(lapply(columns, function(y) {
    type <- class(x$elements[[y]])[1]
    type <- sub("^activityInfo([a-zA-Z0-9]+)FieldSchema$", "\\1", type)
    type
  }))
  types[types!="NULL"]
}

#' @export
tblSort <- function(x) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  x$step$sort
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

#' @export
tblWindow <- function(x, limit) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  window <- x$step$window
  if (!missing(limit)) {
    window[2] <- min(window[2], limit)
  }
  window
}

#' @export
copySchema <- function(x, databaseId, label, ...) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(x))
  fmSchema <- formSchema(databaseId, label, ...)
  lapply(x$elements, function(y) {
    y$id <- cuid()
    fmSchema <<- addFormField(fmSchema, y)
  })
  fmSchema
}

# ---- Lazy steps ----

firstStep <- function(
    formTree, 
    style, 
    totalRecords = 256, 
    vars = varNames(formTree, style = style, addNames = TRUE), 
    columns = styledColumns(
      formTree, 
      style = style, 
      forceId = TRUE)
    ) {
  step <- list(
    "vars" = vars, 
    "columns" = columns, 
    "filter" = NULL, 
    "sort" = NULL,
    "window" = c(0L, as.integer(totalRecords)))
  class(step) <- c("activityInfoStep")
  step
}

newStep <- function(parent, vars = parent$vars, columns = parent$columns, filter = parent$filter, sort = parent$sort, window = parent$window) {
  stopifnot(inherits(parent, "activityInfoStep"))
  step <- list(
    "parent" = parent,
    "vars" = vars, 
    "columns" = columns, 
    "filter" = filter,
    "sort" = sort,
    "window" = window)
  class(step) <- c("activityInfoStep")
  step
}

# ---- Table formatting ----

tblLabel <- function(x) {
  x$formTree$forms[[x$formTree$root]]$label
}

#' @importFrom pillar tbl_format_header style_subtle align
#' @export
tbl_format_header.tbl_activityInfoRemoteRecords <- function(x, setup, ...) {
  # The setup object may know the total number of rows
  
  window <- tblWindow(x)
  columns <- tblColumns(x)
  
  named_header <- list(
    "Form (id)" = sprintf("%s (%s)", tblLabel(x), x$formTree$root),
    "Total form records" = x$totalRecords,
    "Table fields types" = tblFieldTypes(x),
    "Table filter" = tblFilter(x),
    "Table sort" = "",
    "Table Window" = sprintf("offSet: %d; Limit: %d", window[1], window[2])
  )
  
  # Adapted from pillar
  header <- paste0(
    align(paste0(names(named_header), ":")),
    " ",
    named_header
  )
  
  style_subtle(paste0("# ", header))
}

#' @importFrom tibble tbl_sum
#' @export
tbl_sum.tbl_activityInfoRemoteRecords <- function(x, ...) {
  c("ActivityInfo Remote Records" = tblLabel(x), NextMethod())
}


#' @export
tbl_sum.activityInfo_tbl_df <- function(x, ...) {
  c("ActivityInfo tibble" = sprintf("Remote form: %s (%s)",tblLabel(attr(x, "remoteRecords")), attr(x, "remoteRecords")$formTree$root), NextMethod())
}

# select.tbl_activityInfoRemoteRecords <- function(x) {
#   
# }

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

# ---- Dplyr Verbs ----

warn_collect <- function(fn, warningMessage = sprintf("Collecting data for function %s()", fn)) {
  warning(warningMessage)
}

#' @export
#' @importFrom dplyr mutate
mutate.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("mutate")
  .data <- collect(.data)
  mutate(.data, ...)
}

#' @export
#' @importFrom dplyr filter
filter.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("filter")
  .data <- collect(.data)
  filter(.data, ...)
}

#' @export
#' @importFrom dplyr collect
collect.tbl_activityInfoRemoteRecords <- function(x, ...) {
  newTbl <- queryTable(
    x$formTree, 
    columns = tblColumns(x), 
    asTibble = TRUE, 
    makeNames = FALSE, 
    filter = tblFilter(x),
    sort = tblSort(x),
    window = tblWindow(x)
  )
  class(newTbl) <- c("activityInfo_tbl_df", class(newTbl))
  attr(x = newTbl, which = "remoteRecords") <- x
  newTbl
}

# can implement predicate function and create a function factory for the field types
# need to change this to use the columns and adjust the var names
#' @importFrom dplyr select
#' @importFrom tidyselect eval_select
#' @importFrom rlang set_names
#' @export
select.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  loc <- tidyselect::eval_select(expr(c(...)), .data)
  
  new_vars <- set_names(colnames(.data)[loc], names(loc))
  
  .data$step <- addSelect(.data, new_vars)
  .data
}

#' @importFrom dplyr rename
#' @export
rename.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  loc <- tidyselect::eval_select(expr(c(...)), .data)

  new_vars <- set_names(colnames(.data), colnames(.data))
  names(new_vars)[loc] <- names(loc)

  .data$step <- addSelect(.data, new_vars)
  .data
}

#' @importFrom dplyr rename_with
#' @importFrom tidyselect everything
#' @inheritParams dplyr::rename_with
#' @export
rename_with.tbl_lazy <- function(.data, .fn, .cols = everything(), ...) {
  .fn <- as_function(.fn)
  cols <- tidyselect::eval_select(enquo(.cols), .data)
  
  new_vars <- set_names(op_vars(.data))
  names(new_vars)[cols] <- .fn(new_vars[cols], ...)
  
  .data$step <- addSelect(.data, new_vars)
  .data
}

addSelect <- function(.data, new_vars) {
  new_columns <- .data$step$columns[new_vars]
  names(new_columns) <- names(new_vars)
  new_vars[names(new_vars)] <- names(new_vars)
  
  newStep(.data$step, vars = new_vars, columns = new_columns)
}

# this can be implemented by allowing the recordIds to be downloaded on demand
#' @importFrom dplyr slice
#' @export
slice.tbl_activityInfoRemoteRecords <- function(...) {
  warn_collect("slice")
  .data <- collect(.data)
  slice(.data, ...)
}

#' @importFrom dplyr slice_min
#' @export
slice_min.tbl_activityInfoRemoteRecords <- function(...) {
  warn_collect("slice_min")
  .data <- collect(.data)
  slice_min(.data, ...)
}

#' @importFrom dplyr slice_max
#' @export
slice_max.tbl_activityInfoRemoteRecords <- function(...) {
  warn_collect("slice_max")
  .data <- collect(.data)
  slice_max(.data, ...)
}

#' @importFrom dplyr slice_sample
#' @export
slice_sample.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  warn_collect("slice_sample")
  .data <- collect(.data)
  slice_sample(.data, ...)
}

#' @importFrom dplyr slice_head
#' @export
slice_head.tbl_activityInfoRemoteRecords <- function(.data, n, prop) {
  if (missing(n)) {
    if (missing(prop)) stop("slice_head() must either be provide the number of rows n or prop.")
    stopifnot(prop>=0&&prop<=1)
    n <- prop * .data$totalRecords
  }
  head(x, n = n)
}

#' @importFrom dplyr slice_tail
#' @export
slice_tail.tbl_activityInfoRemoteRecords <- function(.data, n, prop) {
  if (missing(n)) {
    if (missing(prop)) stop("slice_tail() must either be provide the number of rows n or prop.")
    stopifnot(prop>=0&&prop<=1)
    n <- prop * .data$totalRecords
  }
  tail(x, n = n)
}

#' @export
#' @importFrom dplyr arrange
arrange.tbl_activityInfoRemoteRecords <- function(.data, ...) {
  dots <- partial_eval_dots(.data, ..., .named = FALSE)
  names(dots) <- NULL
  
  dots <- enquos(...)
  
}


# ---- Utils ----

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

# ---- Base ----

#' @export
as.data.frame.tbl_activityInfoRemoteRecords <- function(x, ...) {
  as.data.frame(collect(x))
}