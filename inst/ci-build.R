
# Set a CRAN mirror to use
options(repos=structure(c(CRAN="http://cran.rstudio.com")))

# Install packages to Jenkins' root folder
.libPaths(new="~/R/libs")

# Install CRAN packages
for(pkg in c('devtools', 'httr', 'rjson', 'RUnit', 'roxygen2', 'Rcpp')) {
  if(!(pkg %in% installed.packages())) {
    install.packages(pkg, dependencies = TRUE)
  }
}

# Check the package for errors
devtools::check(pkg="./activityinfo")

# Run the integration tests
source("activityinfo/inst/integration-tests.R")


# Install staticdocs (using a specific commit so we don't break due to hadley's changes)
if('staticdocs' %in% installed.packages()) {
  devtools::install_github('hadley/staticdocs', ref = '4be10f2a30f56a56961930e2e9d097ecd1771e28')
}
staticdocs::build_site("activityinfo")

