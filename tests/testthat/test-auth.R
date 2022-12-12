interactiveTestEnvironment <- function() {
  tempenv <- new.env()
  tempenv$f <- file()
  withr::defer_parent(close(tempenv$f))
  tempenv
}

testthat::test_that("activityInfoLogin() works interactively", {
  interactiveEnv <- interactiveTestEnvironment()

  testCases <- list(
    responses = list(
      c("example1@example.com", "password1", "n", "No"),
      c("example2@example.com", "password2", "Y", "yes")
    ),
    fileSaved = list(FALSE, TRUE),
    credentials = list(
      "example1@example.com:password1",
      "example2@example.com:password2"
    )
  )

  testBasicCredentials <- function(x) {
    testthat::expect_identical(file.exists(activityinfo:::credentialsFile), testCases$fileSaved[[x]])
    if (testCases$fileSaved[[x]]) {
      line <- readLines(activityinfo:::credentialsFile, warn = FALSE)[1]
      testthat::expect_identical(line, testCases$credentials[[x]])
    }
    auth <- activityinfo:::activityInfoAuthentication()
    testthat::expect_identical(auth$options$userpwd, testCases$credentials[[x]])
    testthat::expect_equal(auth$options$httpauth, 1)
    testthat::expect_s3_class(auth, "request")

    if (file.exists(activityinfo:::credentialsFile)) file.remove(activityinfo:::credentialsFile)
  }

  if (file.exists(activityinfo:::credentialsFile)) file.remove(activityinfo:::credentialsFile)

  withr::with_environment(interactiveEnv, {
    withr::with_options(list(activityinfo.interactive.con = f, activityinfo.interactive = TRUE), {
      testthat::expect_true(activityinfo:::interactive2())
      responses <- paste(unlist(testCases$responses), collapse = "\n")
      write(responses, f)
      lapply(1:2, function(x) {
        # test fully interactive
        testthat::expect_warning({
          testthat::expect_warning(
            {
              activityInfoLogin()
            },
            regexp = "deprec"
          )
          testBasicCredentials(x)
        })

        # test with arguments
        testthat::expect_warning({
          testthat::expect_warning(
            {
              activityInfoLogin(userEmail = testCases$responses[[x]][1], password = testCases$responses[[x]][2])
            },
            regexp = "deprec"
          )
          testBasicCredentials(x)
        })
      })
    })
  })

  withr::with_options(list(activityinfo.interactive = FALSE), {
    testthat::expect_warning({
      testthat::expect_false(activityinfo:::interactive2())
      testthat::expect_warning(
        {
          activityInfoLogin(userEmail = testCases$responses[[1]][1], password = testCases$responses[[1]][2])
        },
        regexp = "deprec"
      )
      testBasicCredentials(1)
    })
  })
})


testthat::test_that("activityInfoToken() works", {
  interactiveEnv <- interactiveTestEnvironment()

  testCases <- list(
    responses = list(
      c("abcdefghijklmnopqrstuv0123456789", "No", "n"),
      c("0123456789abcdefghijklmnopqrstuv", "Y", "yes")
    ),
    fileSaved = list(FALSE, TRUE),
    credentials = list(
      "abcdefghijklmnopqrstuv0123456789",
      "0123456789abcdefghijklmnopqrstuv"
    )
  )

  if (file.exists(activityinfo:::credentialsFile)) file.remove(activityinfo:::credentialsFile)

  testTokenCredentials <- function(x) {
    testthat::expect_identical(file.exists(activityinfo:::credentialsFile), testCases$fileSaved[[x]])
    if (testCases$fileSaved[[x]]) {
      line <- readLines(activityinfo:::credentialsFile, warn = FALSE)[1]
      testthat::expect_identical(line, testCases$credentials[[x]])
    }
    auth <- activityinfo:::activityInfoAuthentication()
    testthat::expect_identical(auth$headers[[1]], sprintf("Bearer %s", testCases$credentials[[x]]))
    testthat::expect_identical(attr(auth$headers, "names"), "Authorization")
    testthat::expect_s3_class(auth, "request")
    if (file.exists(activityinfo:::credentialsFile)) file.remove(activityinfo:::credentialsFile)
  }

  withr::with_environment(interactiveEnv, {
    withr::with_options(list(activityinfo.interactive.con = f, activityinfo.interactive = TRUE), {
      responses <- paste(unlist(testCases$responses), collapse = "\n")
      write(responses, f)
      lapply(1:2, function(x) {
        # test fully interactive
        activityInfoToken()
        testTokenCredentials(x)

        # test with arguements
        activityInfoToken(token = testCases$responses[[x]][1])
        testTokenCredentials(x)
      })
    })
  })

  withr::with_options(list(activityinfo.interactive = FALSE), {
    activityInfoToken(token = testCases$responses[[1]][1])
    testTokenCredentials(1)
  })
})

tokenRequest <- setAuthentication()
