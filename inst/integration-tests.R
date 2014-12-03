
library(RUnit)

# Integration tests meant to run against the development server
source("config.R")
source("mailinator.R")

library(activityinfo)

activityInfoRootUrl(getConfig("TEST_ROOT_URI"))
activityInfoLogin(getConfig("TEST_USER"), getConfig("TEST_PASS"))

integration.tests <- defineTestSuite("Integration Tests",
     dirs = "tests",
     testFileRegexp = ".+\\.R",
     testFuncRegexp = "^test.+")

testResult <- runTestSuite(integration.tests)

printTextProtocol(testResult)

errors <- RUnit::getErrors(testResult)
if(errors$nErr > 0 || errors$nFail > 0) {
  cat("There were test failures.\n")
  if(!interactive()) {
    q(status=-1)
  }
}
