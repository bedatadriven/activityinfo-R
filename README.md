
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

Releases are performed automatically by the [ActivityInfo-R-Release](https://jenkins.bedatadriven.com/job/ActivityInfo-R-Release) job
on the BeDataDriven build server. Running this job will merge the `development` branch in the `release` branch, increment the version number,
check the package, tag the release, and push to the `release` branch.

