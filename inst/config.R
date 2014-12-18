

getConfig <- function(name) {
  val <- Sys.getenv(name) 
  if(!is.character(val) || nzchar(val) == 0) {
    stop(sprintf("the '%s' environment variable must be be set to run tests", name))
  }
  val
}

getCredentials <- function() {
  val <- Sys.getenv("TEST_CREDENTIALS") 
  if(!is.character(val) || nzchar(val) == 0 || !grepl(pattern=":", val)) {
    stop(paste("the 'TEST_CREDENTIALS' environment variable in the format 'user@domain.org:password'",
                "must be be set to run integration tests."))
  }
  pair <- strsplit(val, split=":")[[1]]
  list(userEmail = pair[1], password = pair[2])
}