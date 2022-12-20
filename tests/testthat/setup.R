withr::local_options(list(
  warnPartialMatchDollar = TRUE,
  warnPartialMatchArgs = TRUE,
  warnPartialMatchAttr = TRUE
))

# creating a cuid that artificially enforces a sort order on IDs for snapshotting of API objects
cuid <- local({
  i <- 10000L

  function() {
    i <<- i + 1L
    sprintf("c%d%s", i, activityinfo:::cuid())
  }
})

canonicalizeActivityInfoObject <- function(tree) {
  savedAttributes <- attributes(tree)
  recursiveCanonicalize <- function(x, path = "") {
    if (is.list(x)) {
      xNames <- names(x)
      n <- (grepl(pattern = "[Ii]d$", names(x)) &
        !grepl(pattern = "roles", names(x))) |
        grepl(pattern = "email", names(x))
      x[n] <- "<id value>"

      n <- grepl(pattern = "Time", names(x), ignore.case = TRUE) | grepl(pattern = "Date", names(x), ignore.case = TRUE)
      x[n] <- "<date or time value>"

      n <- grepl(pattern = "resources", names(x)) & lengths(x) == 1
      x[n] <- list("Empty resources until we can ensure a sort order in the API.")

      n <- grepl(pattern = "resources", names(x)) & lengths(x) > 1

      # replace a list or vector of resource ids
      x[n] <- lapply(x[n], function(y) {
        if (is.recursive(y)) {
          # y
          list("Empty resources until we can ensure a sort order in the API.")
        } else if (is.list(y)) {
          # yReturn <- list(rep("<resource id>", length(y)))
          # names(yReturn) <- names(y)
          list("Empty resources until we can ensure a sort order in the API.")
        } else {
          # rep("<resource id>", length(y))
          list("Empty resources until we can ensure a sort order in the API.")
        }
      })

      # names(lapply(x, recursiveCanonicalizeId)) <- xNames
      lapply(x, function(y) {
        recursiveCanonicalize(y, path = paste(c(path, path), collapse = "."))
      })
    } else {
      x
    }
  }
  canonicalizedTree <- recursiveCanonicalize(tree)
  attributes(canonicalizedTree) <- savedAttributes
  canonicalizedTree
}

expectActivityInfoSnapshot <- function(x) {
  testthat::expect_snapshot_value(canonicalizeActivityInfoObject(x), style = "deparse")
}

preprodEndpoint <- Sys.getenv("PREPROD_TESTING_ENDPOINT")
preprodRootUrl <- Sys.getenv("PREPROD_ROOT_URL")

if (preprodEndpoint == "" || preprodRootUrl == "") stop("Pre-production environment variables are not available.")

# Isolate every test completely by creating a completely new user.
# We will use the testing API to do this, which is only enabled in pre-production.

testUser <- list(
  email = sprintf("test%s@example.com", cuid()),
  password = "notasecret",
  name = "Bob",
  platformRole = "NONE",
  locale = "en",
  trial = TRUE
)

message(sprintf("Adding user %s...\n", testUser$email))

tryCatch(
  {
    response <- httr::POST(preprodEndpoint, body = testUser, encode = "json", accept_json())
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

setAuthentication <- function() {
  activityinfo:::activityInfoAuthentication(sprintf("%s:%s", testUser$email, testUser$password))

  # get a personal API token
  activityInfoToken(
    token = postResource("accounts/tokens/generate", body = list(label = sprintf("read write testing token %s", cuid()), scope = "READ_WRITE"), task = "Creating test user token")$token
  )
}

tokenRequest <- setAuthentication()

# Add a new database for this user
setupBlankDatabase <- function(label) {
  activityinfo:::postResource("databases", body = list(id = cuid(), label = label, templateId = "blank"), task = sprintf("Creating test database '%s' post request", label))
}

database <- setupBlankDatabase("My first database")
database2 <- setupBlankDatabase("My second database")

# Add a form to the database
personFormId <- cuid()
childrenSubformId <- cuid()

addForm(database$databaseId,
  schema =
    list(
      id = personFormId,
      databaseId = database$databaseId,
      label = "Person form",
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
        ),
        list(
          id = cuid(),
          code = "CHILDREN",
          label = "Children",
          description = "List the children present in the household",
          relevanceCondition = "",
          validationCondition = "",
          key = FALSE,
          required = TRUE,
          type = "subform",
          typeParameters = list(
            formId = childrenSubformId
          ),
          tableVisible = TRUE,
          dataEntryVisible = TRUE
        )
      )
    )
)

# Add some records to the form
addRecord(formId = personFormId, fieldValues = list(NAME = "Bob"))
addRecord(formId = personFormId, fieldValues = list(NAME = "Alice"))

updateFormSchemaResult <- updateFormSchema(schema = list(
  id = childrenSubformId,
  databaseId = database$databaseId,
  label = "Children",
  parentFormId = personFormId,
  subFormKind = "REPEATING", # anachronism.
  elements = list(
    list(
      id = cuid(),
      code = "NAME",
      label = "Child name",
      relevanceCondition = "",
      validationCondition = "",
      key = TRUE,
      required = TRUE,
      type = "FREE_TEXT",
      typeParameters = list(
        inputMask = "",
        barcode = FALSE
      )
    ),
    list(
      id = cuid(),
      code = "DOB",
      label = "Date of birth",
      relevanceCondition = "",
      validationCondition = "",
      key = FALSE,
      required = TRUE,
      type = "date"
    )
  )
))

records <- queryTable(personFormId)

# Verify that the records are actually there
assertthat::assert_that("Bob" %in% records$NAME)
assertthat::assert_that("Alice" %in% records$NAME)

# Create some sub-form data
nChildren <- 12
childrenNames <- paste0("child", 1:nChildren)
childrenDOB <- withr::with_seed(100, as.Date("1990-01-01") + runif(nChildren, min = 1, max = 10000))
childrenParent <- c(rep("Alice", nChildren / 2), rep("Bob", nChildren / 2))
parentRecordId <- lapply(childrenParent, function(x) {
  records[records$NAME == x, ]$X.id
})

lapply(1:nChildren, function(x) {
  addRecord(formId = childrenSubformId, parentRecordId = parentRecordId[[x]], fieldValues = list(
    NAME = childrenNames[[x]],
    DOB = childrenDOB[[x]]
  ))
})

records <- queryTable(personFormId)

itemNames <- c("bed", "light", "house", "shoes", "coat", "gloves", "table", "chair", "computer", "fridge", "bicycle", "car", "truck", "freezer", "stove", "utensils", "bowl", "plate", "bucket", "soap", "water container", "rice bag", "cereal", "fruit", "jerrycan", "shovel", "latrine", "toilet", "phone", "tablet", "solar charger")
