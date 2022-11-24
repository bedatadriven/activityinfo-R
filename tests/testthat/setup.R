library(httr)

# Isolate every test completely by creating a completely new user.
# We will use the testing API to do this, which is only enabled in pre-production.

testUser <- list(email = sprintf("test%s@example.com", cuid()),
                 password = "notasecret",
                 name = "Bob",
                 platformRole = "NONE",
                 locale = "en",
                 trial = TRUE)

cat(sprintf("Adding user %s...\n", testUser$email))

preprodEndpoint <- Sys.getenv("preprod_testing_endpoint")
preprodRootUrl <- Sys.getenv("preprod_root_url")

if (preprodEndpoint == "" || preprodRootUrl == "") stop("Pre-production environment variables are not available.")

tryCatch(
  {
    response <- POST(preprodEndpoint, body = testUser, encode = "json",  accept_json())
    stop_for_status(response)
  },
  http_error = function(e) {
    stop(sprintf("HTTP error while trying to setup pre-production user: %s", e$message))
  }
)

# Now we can connect to this server using this account
# Point the Package to the Pre-production server. This URL is always
# running the latest release candidate, not neccessarily the same as 

# www.activityinfo.org
activityInfoRootUrl(preprodRootUrl)
activityinfo:::activityInfoAuthentication(sprintf("%s:%s", testUser$email, testUser$password))

# Add a new database for this user
database <- activityinfo:::postResource("databases", body = list(id = cuid(), label = "My database", templateId = "blank"))

# Add a form to the database
personFormId <- cuid()
addForm(database$databaseId, schema = 
          list(id = personFormId,
               databaseId = database$databaseId,
               label = "Test form",
               elements = list(
                 list(
                   id = cuid(),
                   code = "NAME",
                   label = "Respondent name",
                   description = "Ask the respondent their name",
                   relevanceCondition = "",
                   validationCondition = "",
                   key = TRUE,
                   required = TRUE,
                   type = "FREE_TEXT",
                   typeParameters = list(
                     inputMask = "",
                     barcode = FALSE
                   ),
                   tableVisible = TRUE,
                   dataEntryVisible = TRUE
                 )
               )))

# Add some records to the form

addRecord(formId = personFormId, fieldValues = list(NAME = "Bob"))
addRecord(formId = personFormId, fieldValues = list(NAME = "Alice"))

# Verify that the records are actually there
records <- queryTable(personFormId)

assertthat::assert_that("Bob" %in% records$NAME)
assertthat::assert_that("Alice" %in% records$NAME)