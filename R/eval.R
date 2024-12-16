activityInfoFunctionNames <- c(
  "CONCAT",
  "IF",
  "ISNUMBER",
  "ISBLANK",
  "SEARCH",
  "VALUE",
  "LOWER",
  "TRIM",
  "CONCAT",
  "LEFT",
  "RIGHT",
  "MID",
  "REGEXMATCH",
  "REGEXEXTRACT",
  "REGEXREPLACE",
  "TEXT",
  "DATE",
  "YEAR",
  "MONTH",
  "DAY",
  "YEARFRAC",
  "TODAY",
  "NOW",
  "DATEVALUE",
  "MONTHVALUE",
  "WEEKVALUE",
  "FORTNIGHTVALUE",
  "ADDDATE",
  "DAYS",
  "SUM",
  "ANY",
  "AVERAGE",
  "MAX",
  "MIN",
  "COUNT",
  "COUNTDISTINCT",
  "FIRST",
  "LAST",
  "TEXTJOIN",
  "POWER",
  "CEIL",
  "FLOOR",
  "COALESCE",
  "GREAT_CIRCLE"
)



#' Convert an expression using columns in a remote records into an ActivityInfo 
#' style formula
#'
#' @description
#' This function attempts to convert an R expression in the context of a
#' [activityinfo::getRecords] object into an ActivityInfo formula (as a 
#' character string).
#' 
#' It also supports ActivityInfo variable expressions like `[Form Field Label]` 
#' written as a variable or derived from a getRecords object with $ syntax (see
#' example).
#' 
#' It will check if the field/variable/column is available and whether the 
#' functions used are in a list of supported functions but does no syntax 
#' checking during translation.
#'
#' This function is used to implement the mutate() and filter() dplyr verbs.
#'
#' @param .data the remote records object fetched with getRecords().
#' @param expr the expression to convert
#' @param rootEnvironment the original caller environment where the data remote
#' records object resides
#' 
#' @examples
#' \dontrun{
#'
#' x <- getRecords(formId)
#'
#' # Filter out records where the partner organization in BeDataDriven using $
#' x %>% 
#'   mutate(new_field = x$`[Partner organization]`$`[Name]`) %>% 
#'   filter(new_field == "BeDataDriven")
#' 
#' # Create a label for use in a report that prefixes the partner name using
#' # a variable name and the CONCAT() function.
#' x %>% 
#'   mutate(new_field = `[Partner organization].[Name]`) %>%
#'   mutate(report_label = CONCAT("Partner organization: ", new_field))
#'
#' # Get the text of an expression
#' aiFormula <- toActivityInfoFormula(x, IF(ISBLANK(x$`[Partner organization]`), 
#'   "No partner specified", x$`[Partner organization]`$`[Name]`))
#'
#' # returns "IF(ISBLANK((ce844hgm3x4xtgr5)), \"No partner specified\", 
#' #   (ce844hgm3x4xtgr5.c4cx7l663x4xtgr6))"
#' }
#' 
#' @export
toActivityInfoFormula <- function(.data, expr, rootEnvironment = parent.frame()) {
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(.data))

  columns <- tblColumns(.data)
  exprQuo <- rlang::enquo(expr)
  expr2 <- rlang::quo_get_expr(exprQuo)
  formTree <- .data[["formTree"]]
  
  # Symbols: handle variable names
  if(is.symbol(expr2)) {
    chexpr2 <- rlang::as_name(expr2)
    
    if (chexpr2 %in% names(columns)) {
      idVar <- rlang::eval_tidy(expr2, data = columns)
      if(grepl(x = idVar, pattern = "^[A-Za-z_][A-Za-z0-9_]*$")) {
        return(idVar)
      } else {
        return(sprintf("(%s)", idVar))
        #return(sprintf("%s", idVar))
      }
    } else if (exists(as.character(expr2), envir = rootEnvironment, inherits = TRUE)) {
      result <- rlang::eval_tidy(expr2, env = rootEnvironment)
      if (inherits(result, "activityInfoVariableExpression")&&result[["formTree"]]$root==.data[["formTree"]]$root) {
        return(sprintf("(%s)",paste(c(result[["formTree"]]$root, result[["pathIds"]]), collapse = ".")))
      } else if (inherits(result, "activityInfoFormulaExpression")&&attributes(result)$root==.data[["formTree"]]$root) {
        return(sprintf("%s", result))
      } else {
        expr2 <- deparse(rlang::eval_tidy(exprQuo))
      }
    } else {
      pathIds <- tryCatch({
        getPathIds(formTree, as.character(expr2))
      }, error = function(e) {
        NULL
      })
      if (is.null(pathIds)) {
        stop('Cannot evaluate: ', as.character(expr2))
      } else {
        return(paste(c(formTree$root, pathIds), collapse = "."))
      }
    }
  }
  
  # Function calls
  if(is.call(expr2)) {
    fn <- as.character(expr2[[1]])
    
    if (fn == "$") {
      result = rlang::eval_tidy(expr2, env = rootEnvironment)
      if (inherits(result, "activityInfoVariableExpression")&&result[["formTree"]]$root==.data[["formTree"]]$root) {
        return(sprintf("%s",paste(c(result[["formTree"]]$root, result[["pathIds"]]), collapse = ".")))
      } else if (inherits(result, "activityInfoFormulaExpression")&&attributes(result)$root==.data[["formTree"]]$root) {
        return(sprintf("%s", result))
      }
    } else if (fn %in% activityInfoFunctionNames) {
      args <- lapply(as.list(expr2)[-1], function(arg) toActivityInfoFormula(.data, !!arg, rootEnvironment = rootEnvironment))
      return(sprintf("%s(%s)", fn, paste(args, collapse = ", ")))
    } else if(fn %in% c("+", "-", "*", "/","==", "!=", ">", "<", ">=", "<=", "&&", "||")) {
      # These binary infix operators use the same semantic and syntax in ActivityInfo
      return(sprintf("(%s %s %s)", 
                     toActivityInfoFormula(.data, !!expr2[[2]], rootEnvironment = rootEnvironment), 
                     fn, 
                     toActivityInfoFormula(.data, !!expr2[[3]], rootEnvironment = rootEnvironment)))
    } else if(fn %in% c("&", "|")) {
      # These binary infix operators use a slightly modified semantic and syntax in ActivityInfo
      return(sprintf("(%s %s%s %s)", 
                     toActivityInfoFormula(.data, !!expr2[[2]], rootEnvironment = rootEnvironment), 
                     fn, 
                     fn, 
                     toActivityInfoFormula(.data, !!expr2[[3]], rootEnvironment = rootEnvironment)))
    } else if(fn == "!") {
      return(sprintf("%s(%s)", 
                     fn, 
                     toActivityInfoFormula(.data, !!expr2[[2]], rootEnvironment = rootEnvironment)))
    } else if(fn == "(") {
      return(sprintf("(%s)", 
                     toActivityInfoFormula(.data, !!expr2[[2]], rootEnvironment = rootEnvironment)))
    } else if(fn == "grepl") {
      # Translate a call to grepl to AI's REGEXMATCH()
      call <- match.call(definition = grepl, expr2)
      return(sprintf("REGEXMATCH(%s, %s)", 
                     toActivityInfoFormula(.data, !!call$x, rootEnvironment = rootEnvironment), 
                     toActivityInfoFormula(.data, !!call$pattern, rootEnvironment = rootEnvironment)))
    } else if(fn == "paste0") {
      args <- lapply(as.list(expr2)[-1], function(arg) toActivityInfoFormula(.data, !!arg, rootEnvironment = rootEnvironment))
      return(sprintf("%s(%s)", "CONCAT", paste(args, collapse = ", ")))
    } else {
      stop("This function is not yet supported: ", fn)
    }
  }
  
  # Literals: evaluate to be sure we've got the literal. Just deparse, R and ActivityInfo use the same literal syntax
  # Currently to do not support lists, better to do that in the context of the handling of functions like match or %in%.
  if(is.character(expr2) || is.numeric(expr2) || is.logical(expr2)) {
    expr2 <- rlang::eval_tidy(exprQuo)
    if(length(expr2) != 1) {
      stop(sprintf("The expression %s has a length of %d", deparse(expr2), length(expr2)))
    }
    return(deparse(expr2))
  }
  
  stop(sprintf("TODO: %s", deparse(expr2)))
}

parentSymbols = c("@parent", "@Parent", "Parent")

parseActivityInfoVariable <- function(path) {
  # Remove leading and trailing white spaces
  path <- trimws(path)
  
  # Match sequences within square brackets or sequences of non-dot characters
  pattern <- "\\[[^\\[\\]]*\\]|[^\\.]+"
  
  matches <- gregexpr(pattern, path, perl = TRUE)
  components <- regmatches(path, matches)[[1]]
  
  # Remove only the outer square brackets for each component
  components <- sapply(components, function(component) {
    if (startsWith(component, "[") && endsWith(component, "]")) {
      # Remove only the outermost square brackets
      substring(component, 2, nchar(component) - 1)
    } else {
      component
    }
  }, USE.NAMES = FALSE)
  
  # Trim white space from each component
  components <- trimws(components)
  
  components
}

findFieldIds <- function(formTree, currentFormId, pathComponents, collectedIds = list(), depth = 0) {
  if (length(pathComponents) == 0) {
    return(unlist(collectedIds))
  }
  
  # form schema
  currentForm <- formTree$forms[[currentFormId]]
  if (is.null(currentForm)) {
    stop(paste("Form with ID", currentFormId, "not found in form tree."))
  }
  
  # Get next component
  currentComponent <- pathComponents[1]
  names(currentComponent) <- currentFormId
  remainingComponents <- pathComponents[-1]
  
  if (depth == 0 && currentComponent == currentFormId) {
    collectedIds <- currentComponent
    return(findFieldIds(formTree, currentFormId, remainingComponents, collectedIds, depth + 1))
  }
  
  # Search form's elements
  elementFound <- FALSE
  for (element in currentForm$elements) {
    
    fieldMatch <- 
      element$id == currentComponent || 
      (!is.null(element$code) && !is.na(element$code) && element$code == currentComponent) || 
      trimws(element$label) == currentComponent
    
    if (fieldMatch) {
      elementFound <- TRUE
      collectedIds <- c(collectedIds, set_names(element$id, names(currentComponent)))
      
      # If there are no more components, return the collected IDs
      if (length(remainingComponents) == 0) {
        return(unlist(collectedIds))
      }
      
      # If the element is a reference or subform, move to the referenced form
      
      refFormId <- getFieldReferenceFormId(element)
      
      if (!is.null(refFormId)) {
        return(findFieldIds(formTree, refFormId, remainingComponents, collectedIds))
      } else {
        stop(paste("Cannot traverse non-reference field", element$label))
      }
      
      stop(paste("Cannot traverse non-reference field", element$label))
    }
  }
  
  if (currentComponent == '_id') {
    collectedIds <- c(collectedIds, currentComponent)
    if (length(remainingComponents) == 0) {
      return(unlist(collectedIds))
    } else {
      stop("Cannot traverse `_id` column.")
    }
  }
  
  if (currentComponent == '_lastEditTime') {
    collectedIds <- c(collectedIds, currentComponent)
    if (length(remainingComponents) == 0) {
      return(unlist(collectedIds))
    } else {
      stop("Cannot traverse `_lastEditTime` column.")
    }
  }
  
  if (!is.null(currentForm$parentFormId)&&currentComponent %in% parentSymbols) {
    collectedIds <- c(collectedIds, currentComponent)
    if (length(remainingComponents) == 0) {
      return(unlist(collectedIds))
    } else {
      return(findFieldIds(formTree, currentForm$parentFormId, remainingComponents, collectedIds))
    }
  }
  
  # Did not match any element or form, stop with an error
  stop(paste("Component", currentComponent, "not found in form", currentForm$label))
}

getPathIds <- function(formTree, path) {
  pathComponents <- parseActivityInfoVariable(path)
  rootFormId <- formTree$root
  ids <- findFieldIds(formTree, rootFormId, pathComponents, collectedIds = list())
  ids
}

pathValid <- function(formTree, path) {
  tryCatch({
    getPathIds(formTree, path)
    TRUE
  }, error = function(e) {
    FALSE
  })
}


#' Get next possible expansions from an ActivityInfo variable expression or form id
#'
#' @description
#' 
#' A simple helper function to get the variables/columns available from a form
#' or reference field.
#'
#' @param x An ActivityInfo get records object, form id, or form tree.
#' @param path A variable expression (path) or form ID.
#' 
#' @return A character vector of possible next expansions (field labels, IDs, or codes).
#' 
#' @examples
#' \dontrun{
#'
#' x <- getRecords(formId)
#'
#' # Get a list of fields available from the "Office administrator" reference 
#' # form, e.g. from the Staff form
#' available_fields <- getNextExpansions(x, "[Office administrator]")
#' 
#' }
#' 
#' @export
getNextExpansions <- function(x, path = NULL) {
  UseMethod("getNextExpansions")
}

#' @export
getNextExpansions.character <- function(x, path = NULL) {
  getNextExpansions(getFormTree(x), path)
}

#' @export
getNextExpansions.tbl_activityInfoRemoteRecords <- function(x, path = NULL) {
  getNextExpansions(x[["formTree"]], path)
}

#' @export
getNextExpansions.activityInfoFormTree <- function(x, path = NULL) {
  expr <- activityInfoVariableExpression(x, path)
  getNextExpansions(expr)
}

# do not use path argument
#' @export
getNextExpansions.activityInfoVariableExpression <- function(x, path = NULL) {
  expr <- x
  
  formTree <- expr[["formTree"]]
  
  fieldIds <- expr[["pathIds"]]
  formIds <- names(fieldIds)
  
  lastFieldId <- expr[["lastId"]]
  currentFormId <- tail(formIds, n = 1)
  
  currentFormSchema <- formTree$forms[[currentFormId]]
  
  field <- NULL
  for (el in currentFormSchema$elements) {
    if (el$id == lastFieldId) {
      field <- el
      break
    }
  }
  
  if (is.null(field)) {
    
    if (lastFieldId %in% c("_id", "_lastEditTime")) {
      return(character(0))
    } else if (!is.null(currentFormSchema$parentFormId)&&(lastFieldId %in% parentSymbols)) {
      return(getFormExpansions(formSchema = formTree$forms[[currentFormSchema$parentFormId]]))
    }
    
    stop("Cannot expand path (", expr[["currentPath"]], ") in form `", currentFormId,"`.")
  }
  
  nextFormId <- getFieldReferenceFormId(field)
  if (is.null(nextFormId)) return(character(0))
  
  getFormExpansions(formSchema = formTree$forms[[nextFormId]])
}

getFormExpansions <- function(formSchema) {
  stopifnot("Invalid form schema passed to getFormExpansions()." = "activityInfoFormSchema" %in% class(formSchema))
  
  expansions <- c("_id", "_lastEditTime")
  
  if (!is.null(formSchema$parentFormId)) {
    expansions <- c(expansions, "@parent")
  }
  
  for (el in formSchema$elements) {
    expansions <- c(expansions, el$id, sprintf("[%s]",el$label))
    if (!is.null(el$code)) {
      expansions <- c(expansions, el$code)
    }
  }
  
  names(expansions) <- rep(formSchema$id, length(expansions))
  
  expansions
}

getFieldReferenceFormId <- function(field) {
  stopifnot("getFieldReferenceFormId() requires an activityInfoFormFieldSchema" = "activityInfoFormFieldSchema" %in% class(field))
  if ((field$type == "multiselectreference"||field$type == "reference") && !is.null(field$typeParameters$range)) {
    return(field$typeParameters$range[[1]]$formId)
  } else if ((field$type == "subform"||field$type == "reversereference") && !is.null(field$typeParameters$formId)) {
    return(field$typeParameters$formId)
  }
  return(NULL)
}

#' An ActivityInfo variable expression
#'
#' @description
#' A helper object to get a reference to variables/columns available from a form
#' or reference field. These expressions support the $ syntax in R so that the
#' user can interactively expand reference and sub-form fields.
#' 
#' This is also returned when using $ in a getRecords() object.
#'
#' @param x An ActivityInfo form id, form tree, or another ActivityInfo variable expression.
#' @param path The next valid element/name in the variable expression or the root form ID (optional).
#' 
#' @export
activityInfoVariableExpression <- function(x, path = NULL) {
  UseMethod("activityInfoVariableExpression")
}

#' @export
activityInfoVariableExpression.character <- function(x, path = NULL) {
  activityInfoVariableExpression(getFormTree(x), path)
}

#' @export
activityInfoVariableExpression.activityInfoFormTree <- function(x, path = NULL) {
  formTree <- x
  
  if (is.null(path)) {
    stop("A NULL value passed as an ActivityInfo variable expression.")
  }
  
  pathIds <- getPathIds(formTree, path)
  lastId <- tail(pathIds, n = 1)
    
  x <- structure(
    list(
      "formTree" = formTree,
      "currentPath" = path,
      "pathIds" = pathIds,
      "lastId" = lastId
    ),
    class = "activityInfoVariableExpression"
  )
  
  x[["nextExpansion"]] <- getNextExpansions(x)
  
  x[["activityInfoColumn"]] <- paste(c(formTree$root, pathIds), collapse = ".")
  
  x
}

#' @export
activityInfoVariableExpression.activityInfoVariableExpression <- function(x, path = NULL) {
  expr <- x
  
  if (is.null(path)) return(expr)
  activityInfoVariableExpression(expr[['formTree']], path)
}

#' @export
`$.activityInfoVariableExpression` <- function(x, name) {
  nm <- as.character(substitute(name))
  
  if (nm %in% base::names(x)) {
    return(x[[nm]])
  }
  
  if (nm %in% x[["nextExpansion"]]) {
    return(activityInfoVariableExpression(x, sprintf("%s.%s", x[["currentPath"]], nm)))
  }
  
  stop("Invalid element: ", name)
}

#' @export
print.activityInfoVariableExpression <- function(x, ...) {
  expr <- x
  cat("ActivityInfo variable expression\n")
  cat(sprintf("  Database id:   %s\n", expr[["formTree"]]$forms[[expr[["formTree"]]$root]]$databaseId))
  cat(sprintf("  Root form id:        %s\n", expr[["formTree"]]$forms[[expr[["formTree"]]$root]]$id))
  cat(sprintf("  Path:        %s\n", expr[["currentPath"]]))  
  cat(sprintf("  Id path:        %s\n", expr[["activityInfoColumn"]]))  

  invisible()
}

#' @export
#' @importFrom utils .DollarNames
.DollarNames.activityInfoVariableExpression <- function(x, pattern = "") {
  vars <- c(x[["nextExpansion"]])
  # Add backticks to variables needing escaping
  # vars <- ifelse(grepl("[^A-Za-z0-9_.]", vars), paste0("`", vars, "`"), vars)
  vars[grep(pattern, vars)]
}

#' @export
`$.tbl_activityInfoRemoteRecords` <- function(x, name) {
  nm <- as.character(substitute(name))
  
  if (nm %in% base::names(x)) {
    return(x[[nm]])
  }
  
  if (nm %in% x[['step']][['vars']]) {
    expr <- tryCatch({
      activityInfoVariableExpression(x[['formTree']], x[['step']][['columns']][[nm]])
    }, 
    error = function(e) {
      expr <- x[['step']][['columns']][[nm]]
      class(expr) <- c("activityInfoFormulaExpression", class(expr))
      attr(expr, 'columnName') <- nm
      attr(expr, 'root') <- x[["formTree"]]$root
      return(expr)
    })
    
    return(expr)
  }
  
  nextExpansion <- getFormExpansions(x[['formTree']]$forms[[x[['formTree']]$root]])
  
  if (nm %in% nextExpansion) {

    return(activityInfoVariableExpression(x[['formTree']], nm))
  }
  
  stop("Invalid element: ", name)
  
  return(NULL)
}

#' @export
.DollarNames.tbl_activityInfoRemoteRecords <- function(x, pattern = "") {
  existingVars <- names(x[['step']]$vars)
  nextExpansion <- getFormExpansions(x[['formTree']]$forms[[x[['formTree']]$root]])
  
  # Combine existing vars and next expansions
  vars <- c(existingVars, nextExpansion)
  
  # Apply filtering based on the provided pattern
  vars[grep(pattern, vars)]
}



