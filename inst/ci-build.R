
# Continuous Integration Build Script


# Install required packages
install.dependencies <- function() {
  cat("Installing Dependencies...\n")
  
  # Set a CRAN mirror to use
  options(repos=structure(c(CRAN="http://cran.rstudio.com")))
  
  # Install CRAN packages
  for(pkg in c('devtools', 'httr', 'rjson', 'RUnit', 'roxygen2', 'Rcpp')) {
    if(!(pkg %in% installed.packages())) {
      install.packages(pkg, dependencies = TRUE)
    }
  }
}

# Check the package for errors
check <- function() {
  cat("Running checks...\n")
  
  library(methods)
  devtools::check(pkg="./activityinfo", document = TRUE, build_args = "--no-manual")
}

# Run the integration tests
test <- function() {
  cat("GOAL: test\n")
  install.dependencies()
  check()
  source("activityinfo/inst/integration-tests.R", chdir = TRUE)
}

git <- function(...) {
  arguments <- list(...)
  commandLine <- paste(c("git", "--git-dir=activityinfo/.git", "--work-tree=activityinfo", arguments), collapse = " ")
  cat(commandLine, "\n")
  output <- system(command = commandLine, intern = TRUE)
  cat(output)
  return(output)
}

commit.release <- function(version) {
  git("add DESCRIPTION man/*.Rd")
  git("commit", "-m", sprintf('"[RELEASE] Version %s"', version))
}

# Increment the version number of this package
update.version <- function() {
  
  # Get the build number (provided by Jenkins)
  build.number <- Sys.getenv("BUILD_NUMBER")
  if(nchar(build.number) == 0) {
    stop("The BUILD_NUMBER environment variable has not been defined, are we running in Jenkins?")
  }
  
  # Update the description file
  description <- read.dcf("./activityinfo/DESCRIPTION")
  version <- numeric_version(description[1,"Version"])  
  version$Version[3] <- build.number
  
  description[1, "Version"] <- as.character(version)
  
  write.dcf(description, file="./activityinfo/DESCRIPTION")
  
  return(as.character(version))
}

# Release a new version of the library, incrementing the version number
# and comitting back to the master branch
release <- function() {
  
  # Ensure that we're on the release branch
  currentBranch <- git("symbolic-ref --short HEAD")
  if(!identical(currentBranch, "release")) {
    stop(sprintf("release must be performed from the 'release' branch, currently on '%s'", currentBranch))
  }
  
  install.dependencies()
  new.version <- update.version()
  check()
  commit.release(new.version)
  
  # Write the new version out to a property file for
  # subsequent build steps
  cat(sprintf("RELEASE_VERSION=%s\n", new.version), file = "release.properties")
}

# Check Arguments
goals <- c("test", "release")
arg <- commandArgs(trailingOnly = TRUE)

if(length(arg) != 1 || !(arg %in% goals)) {
  cat("Usage: Rscript ci-build.R (", paste(goals, collapse = " | "), ")\n")
  q(status=-1)
}
cat(sprintf("Executing %s\n", arg))
goal <- get(arg)
goal()

