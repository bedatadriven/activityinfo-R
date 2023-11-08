library(dplyr)

withr::local_options(list(
  warnPartialMatchDollar = TRUE,
  warnPartialMatchArgs = TRUE,
  warnPartialMatchAttr = TRUE
))

# Hide import progress bar which makes a mess of test output
options(activityinfo.import.progress = FALSE)

# Avoid warning message when calling grSoftVersion on first call
suppressWarnings(grSoftVersion())

##### Testing functions #####

# creating a cuid that artificially enforces a sort order on IDs for snapshotting of API objects
cuid <- local({
  i <- 10000000L

  function() {
    i <<- i + 1L
    sprintf("c%d%s", i, activityinfo:::cuid())
  }
})

canonicalizeActivityInfoObject <- function(tree, replaceId = TRUE, replaceDate = TRUE, replaceResource = TRUE) {
  recursiveCanonicalize <- function(x, path = "") {
    # jsonlite converts an empty json object to an empty named list
    # which seems to throw testthat's snapshots
    if (identical(x, structure(list(), names = character(0)))) {
      return(list())
    }

    if (is.list(x)) {
      savedAttributes <- attributes(x)

      x <- x[order(namesOrIndexes(x))]

      # reorder names in saved attributes
      savedAttributes$names <- names(x)

      if (replaceId) {
        n <- (grepl(pattern = "[Ii]d$", names(x)) &
                !grepl(pattern = "roles", names(x))) |
          grepl(pattern = "email", names(x))
        x[n] <- "<id value>"
      }

      if (replaceDate) {
        n <- grepl(pattern = "Time", names(x), ignore.case = TRUE) | grepl(pattern = "Date", names(x), ignore.case = TRUE)
        x[n] <- "<date or time value>"
      }

      if (replaceResource) {
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
      } else if (is.vector(x) && is.character(x)) {
        # reorder character vectors (which are not lists) as sort order is not guaranteed by API 
        x <- x[order(x)]
      }


      x <- lapply(x, function(y) {
        recursiveCanonicalize(y, path = paste(c(path, path), collapse = "."))
      })
      attributes(x) <- savedAttributes
      x
    } else {
      x
    }
  }
  canonicalizedTree <- recursiveCanonicalize(tree)
  canonicalizedTree
}

namesOrIndexes <- function(x) {
  if (is.list(x)) {
    if (is.null(names(x))) {
      if (length(x)>0) {
        return(seq(length(x)))
      } else {
        return(character())
      }
    }
    names(x)
  }
}

identicalForm <- function(a,b) {
  a <- a[!(namesOrIndexes(a) %in% c("schemaVersion"))]
  b <- b[!(namesOrIndexes(b) %in% c("schemaVersion"))]
  a <- canonicalizeActivityInfoObject(a, replaceId = FALSE, replaceDate = FALSE, replaceResource = FALSE)
  b <- canonicalizeActivityInfoObject(b, replaceId = FALSE, replaceDate = FALSE, replaceResource = FALSE)
  testthat::expect_identical(a,b)
}

expectActivityInfoSnapshot <- function(x, replaceId = TRUE, replaceDate = TRUE, replaceResource = TRUE) {
  x <- canonicalizeActivityInfoObject(x, replaceId, replaceDate, replaceResource)
  testthat::expect_snapshot_value(x, style = "deparse")
}


setupBlankDatabase <- function(label) {
  activityinfo:::postResource("databases", body = list(id = cuid(), label = label, templateId = "blank"), task = sprintf("Creating test database '%s' post request", label))
}

##### Setup code #####

preprodRootUrl <- Sys.getenv("TEST_URL")

if (preprodRootUrl == "") stop("TEST_URL environment variable is not set.")

preprodEndpoint <- sprintf("%s/resources/testing", preprodRootUrl)

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
    response <- httr::POST(preprodEndpoint, body = testUser, encode = "json", httr::accept_json())
    httr::stop_for_status(response)
  },
  http_error = function(e) {
    stop(sprintf("HTTP error while trying to setup pre-production user: %s", e$message))
  }
)

# Now we can connect to this server using this account
# Point the Package to the Pre-production server. This URL is always
# running the latest release candidate, not necessarily the same as

# www.activityinfo.org
activityInfoRootUrl(preprodRootUrl)

# Use these credentials for the rest of the tests
activityinfo:::activityInfoAuthentication(sprintf("%s:%s", testUser$email, testUser$password))


# Add a new database for this user
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
              textFieldSchema(
                code = "NAME",
                label = "Respondent name",
                description = "Ask the respondent their name",
                key = TRUE,
                required = TRUE),
              subformFieldSchema(
                code = "CHILDREN",
                label = "Children",
                description = "List the children present in the household",
                subformId = childrenSubformId)
            )
          ))

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
  records[records$NAME == x, ]$`X.id`
})

lapply(1:nChildren, function(x) {
  addRecord(formId = childrenSubformId, parentRecordId = parentRecordId[[x]], fieldValues = list(
    NAME = childrenNames[[x]],
    DOB = childrenDOB[[x]]
  ))
})

records <- queryTable(personFormId)

itemNames <- c("bed", "light", "house", "shoes", "coat", "gloves", "table", "chair", "computer", "fridge", "bicycle", "car", "truck", "freezer", "stove", "utensils", "bowl", "plate", "bucket", "soap", "water container", "rice bag", "cereal", "fruit", "jerrycan", "shovel", "latrine", "toilet", "phone", "tablet", "solar charger")
