
test.createDatabase <- function() {
  
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
  
  
  # Ensure that the change has stuck
  db <- getDatabaseSchema(testDbId)
  authorizedUsers <- getAuthorizedUsers(testDbId)
  
  checkIdentical(db$name, testDbName)
  checkTrue(db$designAllowed)
  checkTrue(length(db$activities) == 1)
  checkIdentical(db$activities[[1]]$name, "A1")
  checkTrue(length(authorizedUsers)==1)
  
  # Now try to copy users to a new db
  testCopyDbId <- createDatabase(name=testDbName, country="SS")
  copyUsers(testDbId, testCopyDbId)
  
  copiedUsers <- getAuthorizedUsers(databaseId=testDbId)
  checkTrue(length(copiedUsers)==1)
  checkIdentical(copiedUsers$userName, "Testy McTest Test")
  checkTrue(copiedUsers$allowView)
}