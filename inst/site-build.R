
# Generate static documentation site for the package

args <- commandArgs(trailingOnly=TRUE)

if(length(args) != 1) {
  cat("Usage: Rscript site-build.R <site path>\n")
  q(status=-1)
}

# Install staticdocs (using a specific commit so we don't break due to hadley's changes)
if(!('staticdocs' %in% installed.packages())) {
  devtools::install_github('hadley/staticdocs', ref = '4be10f2a30f56a56961930e2e9d097ecd1771e28')
}

library(staticdocs)

build_site(as.sd_package("activityinfo", site_path=args[1]))