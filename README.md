
ActivityInfo R Client
=====================

Provides access to ActivityInfo databases through R 

Installation
------------

## Latest Release

[![Build Status](https://jenkins.bedatadriven.com/buildStatus/icon?job=ActivityInfo/R-Client/ActivityInfo-R-Client)](https://jenkins.bedatadriven.com/job/ActivityInfo/R-Client/ActivityInfo-R-Client)

You can install the latest stable release directly from GitHub:

    install.packages("devtools")
    library(devtools)
    install_github( "bedatadriven/activityinfo-R", ref = "release")

Getting Started
---------------

Once the package is installed, you can authenticate interactively
using the activityInfoLogin() function


    library(activityinfo)
    activityInfoLogin()

You will be prompted to save your password locally. 

Contributing
------------

Please commit new work against the `development` branch or open a pull
request based on the `development` branch.

Releasing
---------

Following a change to the `release` branch, generate the package documentation and export the required methods by running `roxygen`:

```
library(roxygen2)
roxygenize()
```

Increment the release Version in [DECSRIPTION](DESCRIPTION) and commit the changed files to GitHub. Please see [here](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html) for more details on `roxygen`.

Releases are provided to users directly from GitHub (see [Latest Release](#latest-release)). 
