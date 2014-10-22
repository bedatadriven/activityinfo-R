
# Integration tests meant to run against the development server
source("config.R")
source("mailinator.R")

library(activityinfo)

activityInfoRootUrl(getConfig("TEST_ROOT_URI"))
activityInfoLogin(getConfig("TEST_USER"), getConfig("TEST_PASS"))

# Generate a base identifier for this test run
testId <- paste("test", strftime(Sys.time(), "%Y%m%d-%H%M%S"), sep="-")
users <- paste(testId, 1:5, sep="-")

# Create a test db from scratch
testDbName <- paste(testId, "A", sep = "-")
testDbId <- createDatabase(name=testDbName, description="Test 1..2..3... anything but that", country="SS")


# Create an activity in the new db
testA1 <- createActivity(databaseId=testDbId, name="A1", locationTypeId="State")
testI1 <- createIndicator(activityId=testA1, name="Number of thneeds", description="A thing everyone, EVERYONE, needs.",
                          units="thneeds")

# Add a partner to the db
partnerId <- addPartner(database=testDbId, partnerName="NRC", fullPartnerName="Norweigen Refugee Council")

# Add a (new) user to the db
updateUserPermissions(databaseId=testDbId, 
                      userEmail=paste(users[2], "mailinator.com", sep="@"),
                      userName="Testy McTest Test",
                      partner=partnerId)

assertInvitationReceived(inboxId=users[2])


# Ensure that the change have stuck
db <- getDatabaseSchema(testDbId)
authorizedUsers <- getAuthorizedUsers(testDbId)

stopifnot(identical(db$name, testDbName))
stopifnot(db$designAllowed)
stopifnot(length(db$activities) == 1)
stopifnot(identical(db$activities[[1]]$name, "A1"))
stopifnot(length(authorizedUsers)==1)

