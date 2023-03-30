#' Convert an expression using columns in a remote records into an ActivityInfo style formula
#'
#' @description
#' This function attempts to convert an R expression using the columns of the
#' [activityinfo::getRecords] object into an ActivityInfo formula (as a string).
#'
#' @param .data the remote records object fetched with getRecords().
#' @param expr the expression to convert
#' 
#' @export
toActivityInfoFormula <- function(.data, expr) {
  
  stopifnot("tbl_activityInfoRemoteRecords" %in% class(.data))

  columns <- tblColumns(.data)
  exprQuo <- rlang::enquo(expr)
  expr2 <- rlang::quo_get_expr(exprQuo)
  
  # Symbols: handle variable names
  if(is.symbol(expr2)) {
    chexpr2 <- rlang::as_name(expr2)
    
    if (chexpr2 %in% names(columns)) {
      idVar <- rlang::eval_tidy(expr2, data = columns)
      if(grepl(x = idVar, pattern = "^[A-Za-z_][A-Za-z0-9_]*$")) {
        return(idVar)
      } else {
        #return(sprintf("[%s]", idVar))
        return(sprintf("%s", idVar))
      }
    } else {
      expr2 <- deparse(rlang::eval_tidy(exprQuo))
    }
  }
  
  # Function calls
  if(is.call(expr2)) {
    fn <- as.character(expr2[[1]])
    if(fn %in% c("+", "-", "*", "/","==", "!=", ">", "<", ">=", "<=")) {
      # These binary infix operators use the same semantic and syntax in ActivityInfo
      return(sprintf("(%s %s %s)", toActivityInfoFormula(.data, !!expr2[[2]]), fn, toActivityInfoFormula(.data, !!expr2[[3]])))
    } else if(fn == "grepl") {
      # Translate a call to grepl to AI's REGEXMATCH()
      call <- match.call(definition = grepl, expr2)
      return(sprintf("REGEXMATCH(%s, %s)", toActivityInfoFormula(.data, !!call$x), toActivityInfoFormula(.data, !!call$pattern)))
    } else {
      stop("This function is not yet supported: ", fn)
      #return(deparse(rlang::eval_tidy(exprQuo, data = columns)))
    }
  }
  
  # Literals: evaluate to be sure we've got the literal. Just deparse, R and ActivityInfo use the same literal syntax
  # Currently to do not support lists, better to do that in the context of the handling of functions like match or %in%.
  if(is.character(expr2) || is.numeric(expr2)) {
    expr2 <- rlang::eval_tidy(exprQuo)
    if(length(expr2) != 1) {
      stop(sprintf("The expression %s has a length of %d", deparse(expr2), length(expr2)))
    }
    return(deparse(expr2))
  }
  
  stop(sprintf("TODO: %s", deparse(expr2)))
}

