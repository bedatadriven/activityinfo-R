

getConfig <- function(name) {
  val <- Sys.getenv(name) 
  if(!is.character(val) || nzchar(val) == 0) {
    stop(sprintf("the '%s' environment variable must be be set to run tests", name))
  }
  val
}