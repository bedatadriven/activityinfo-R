
base36digits <- c(0:9, letters)

base36 <- function(x) {
  digits <- character(0)
  digiti <- 1
  while(x > 0) {
    dx <- floor(x / 36)
    r <- x - (dx * 36)
    digits[digiti] <- base36digits[r + 1]
    x <- dx
    digiti <- digiti + 1
  }
  paste(rev(digits), collapse = "")
}

#' Generates a CUID 
#' 
#' CUIDs are Collision-resistant IDs that are generated by clients and used to uniquely
#' identify forms, records, fields and other resources in ActivityInfo.
#' 
#' @export
cuid <- local({
  counter <- 1L
  function() {
    time <- as.double(Sys.time()) * 1000L
   # random <- round(runif(1, min = 0, max = 2^63))
    result <- paste0(base36(time), base36(counter))
    count <<- counter + 1L
    result
  }
})