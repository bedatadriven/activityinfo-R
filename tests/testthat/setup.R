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
        
        n <- grepl(pattern = "resources", names(x)) & lengths(x) > 1
        # replace a list or vector of resource ids
        x[n] <- lapply(x[n], function(y) {
          if (is.recursive(y)) {
            # y
            rep(list(list(id = "<id>", note = "Empty resources until we can ensure a sort order in the API.")), length(y))
          } else if (is.list(y)) {
            # yReturn <- list(rep("<resource id>", length(y)))
            # names(yReturn) <- names(y)
            rep(list(list(id = "<id>", note = "Empty resources until we can ensure a sort order in the API.")), length(y))
          } else {
            # rep("<resource id>", length(y))
            rep(list(list(id = "<id>", note = "Empty resources until we can ensure a sort order in the API.")), length(y))
          }
        })
        
        n <- grepl(pattern = "resources", names(x)) & lengths(x) == 1
        if (sum(n)>0) {
          x[n] <- list(list(id = "<id>", note = "Empty resources until we can ensure a sort order in the API."))
        }
        
        
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

compare_recursively <- function(a, b, path = list()) {
  if (is.atomic(a) && is.atomic(b)) {
    if (!identical(a,b)) {
      message(sprintf("Field with name/key '%s' value has changed", paste(path, collapse="'->'")))
    }
    testthat::expect_identical(object = b, expected = a)
  } else if (is.list(a) && is.list(b)) {
    additionalFields <- names(b)[!names(b) %in% names(a)]
    if (length(additionalFields)>0) {
      message(sprintf("Additional fields found at name/key %s: '%s'", paste(path, collapse = "'->'"), paste(additionalFields, collapse = "', '")))
    }
    for (name in names(a)) {
      # Check if the name in 'a' exists in 'b', then compare their values recursively
      test <- name %in% names(b)
      if(!test) message(sprintf("Missing expected field name/key %s", paste(c(path, name), collapse="->")))
      testthat::expect_true(test)
      compare_recursively(a[[name]], b[[name]], c(path, name))
    }
  } else {
    message(sprintf("Incompatible structures under name/key '%s'", paste(path, collapse="'->'")))
    testthat::expect_identical(object = b, expected = a)
  }
}

identicalForm <- function(a,b, b_allowed_new_fields = TRUE) {
  a <- a[!(namesOrIndexes(a) %in% c("schemaVersion"))]
  b <- b[!(namesOrIndexes(b) %in% c("schemaVersion"))]
  a <- canonicalizeActivityInfoObject(a, replaceId = FALSE, replaceDate = FALSE, replaceResource = FALSE)
  b <- canonicalizeActivityInfoObject(b, replaceId = FALSE, replaceDate = FALSE, replaceResource = FALSE)
  
  if (b_allowed_new_fields) {
    compare_recursively(a, b)
  } else {
    testthat::expect_identical(object = b, expected = a)
  }
}

expectActivityInfoSnapshotCompare <- function(x, snapshotName, replaceId = TRUE, replaceDate = TRUE, replaceResource = TRUE, allowed_new_fields = TRUE) {
  if (missing(snapshotName)) stop("You must give the snapshot a name")
  stopifnot("The snapshotName must be a character string" = is.character(snapshotName)&&length(snapshotName)==1)
  
  x <- canonicalizeActivityInfoObject(x, replaceId, replaceDate, replaceResource)
  
  path <- testthat::test_path("_activityInfoSnaps", sprintf("%s.RDS", snapshotName))
  
  if (file.exists(path)) {
    y <- readRDS(file = path)
  } else {
    message("Adding activityInfo snapshot: ", snapshotName, ".RDS")
    saveRDS(x, file = path)
    return(invisible(NULL))
  }
  
  if (allowed_new_fields) {
    compare_recursively(y, x)
  } else {
    testthat::expect_identical(object = x, expected = y)
  }
}

expectActivityInfoSnapshot <- function(x, replaceId = TRUE, replaceDate = TRUE, replaceResource = TRUE) {
  x <- canonicalizeActivityInfoObject(x, replaceId, replaceDate, replaceResource)
  testthat::expect_snapshot_value(x, style = "deparse")
}

setupBlankDatabase <- function(label) {
  db <- activityinfo:::postResource("databases", body = list(id = cuid(), label = label, templateId = "blank"), task = sprintf("Creating test database '%s' post request", label))
  db$billingAccountId <- as.character(db$billingAccountId)
  db
}

##### Setup code #####

preprodRootUrl <- Sys.getenv("TEST_URL")

if (preprodRootUrl == "") stop("TEST_URL environment variable is not set.")


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
    response <- httr::POST(sprintf("%s/resources/testing", preprodRootUrl), body = testUser, encode = "json", httr::accept_json())
    httr::stop_for_status(response)
  },
  http_error = function(e) {
    stop(sprintf("HTTP error while trying to setup pre-production user: %s", e$message))
  }
)

message(sprintf("Obtaining session cookie for %s...\n", testUser$email))


login_credentials <- list(
  email = testUser$email,
  password = testUser$password
)

login_response <- httr::POST(
  sprintf("%s/login", preprodRootUrl),
  body = login_credentials,
  encode = "json"
)

httr::stop_for_status(login_response)

# Extract the session cookie
session_cookie <- httr::cookies(login_response)
auth_cookie <- session_cookie$value[session_cookie$name == "auth"]


if (length(auth_cookie) == 0) {
  stop("Authentication cookie 'auth' not found in login response.")
}

message("Session cookie obtained successfully.\n")
message("Generating API token...\n")

token_data <- list(
  label = "Testing",
  scope = "READ_WRITE"
)

token_response <- httr::POST(
  sprintf("%s/resources/accounts/tokens/generate", preprodRootUrl),
  body = token_data,
  encode = "json",
  httr::add_headers(Cookie = paste0("auth=", auth_cookie)),
  httr::accept_json()
)

httr::stop_for_status(token_response)

token_result <- httr::content(token_response, "parsed")

# Now we can connect to this server using this account
# Point the Package to the Pre-production server. This URL is always
# running the latest release candidate, not necessarily the same as

# www.activityinfo.org
activityInfoRootUrl(preprodRootUrl)

# Use these credentials for the rest of the tests
activityinfo:::activityInfoToken(token_result$token, prompt = FALSE)


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
