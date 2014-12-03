
# Integration tests meant to run against the development server
source("config.R")
source("mailinator.R")

library(activityinfo)

activityInfoRootUrl(getConfig("TEST_ROOT_URI"))
activityInfoLogin(getConfig("TEST_USER"), getConfig("TEST_PASS"))

integration.tests <- defineTestSuite("c2f",
     dirs = file.path(.path.package(package="activityinfo"), "inst/tests"),
     testFileRegexp = "^runit.+\\.r",
     testFuncRegexp = "^test.+",
     rngKind = "Marsaglia-Multicarry",
     rngNormalKind = "Kinderman-Ramage")
