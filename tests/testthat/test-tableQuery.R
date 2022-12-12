testthat::test_that("parseColumnSet() works", {

})

testthat::test_that("queryTable() returns a data.frame with 2 rows and expected columns", {
  output <- suppressWarnings(suppressMessages(activityinfo::queryTable(form = personFormId)))
  testthat::expect_true(inherits(output, "data.frame"))
  testthat::expect_true(nrow(output) == 2)
  testthat::expect_true(all(c("X.id", "X.lastEditTime", "NAME", "CHILDREN") %in% names(output)))
})

testthat::test_that("queryTable() returns a valid data.frame with the same column names as the input columns if the user gives a specific number of 'columns' as input ", {
  input_parameters <- list(
    form = childrenSubformId,
    "Person name" = "NAME",
    "Date of Birth" = "DOB"
  )

  names_parameters <- names(input_parameters)[-1] # exclude the 'form' parameter
  names_valid <- make.names(names_parameters) # make valid names

  output <- suppressWarnings(suppressMessages((do.call(activityinfo::queryTable, input_parameters))))

  testthat::expect_true(inherits(output, "data.frame"))
  testthat::expect_true(all(names_valid %in% colnames(output)))
})


testthat::test_that("queryTable() returns a single column data.frame if the input is a single column, has expected snapshot content, and provides warning if deprecated parameter is used", {
  input_parameters1 <- list(
    form = personFormId,
    "Person name" = "NAME",
    truncate.strings = TRUE
  )

  input_parameters2 <- list(
    form = personFormId,
    "Person name" = "NAME",
    truncateStrings = FALSE
  )

  input_parameters_incompatible <- list(
    form = personFormId,
    "Person name" = "NAME",
    truncate.strings = TRUE,
    truncateStrings = FALSE
  )

  names_parameters <- names(input_parameters1)[-1] # exclude the 'form' parameter
  names_parameters <- names_parameters[-length(names_parameters)] # exclude truncate parameter
  names_valid <- make.names(names_parameters) # make valid names


  testthat::expect_warning(
    {
      output <- do.call(activityinfo::queryTable, input_parameters1)
    },
    regexp = "truncateStrings"
  )

  testthat::expect_error(testthat::expect_warning({
    outputError <- do.call(activityinfo::queryTable, input_parameters_incompatible)
  }), regexp = "truncateStrings")

  testthat::expect_no_warning({
    output <- do.call(activityinfo::queryTable, input_parameters2)
  })


  testthat::expect_true(inherits(output, "data.frame"))
  testthat::expect_true(all(names_valid %in% colnames(output)))
  testthat::expect_identical(length(colnames(output)), 1L)

  testthat::expect_snapshot_value(deparse(output))
})


testthat::test_that("queryTable() returns missing values (NA's) for the specified column if the corresponding to the column ID is invalid", {
  input_parameters <- list(
    form = childrenSubformId,
    "Serial number" = "INVALID"
  )

  names_param <- names(input_parameters)[-1]
  names_valid <- make.names(names_param)

  output <- suppressWarnings(suppressMessages((do.call(activityinfo::queryTable, input_parameters))))

  testthat::expect_true(inherits(output, "data.frame") & all(names_valid %in% colnames(output)) & all(is.na(output[[names_valid]])))
})


testthat::test_that("queryTable() gives an error if the input 'form' parameter is invalid", {
  testthat::expect_error(suppressWarnings(suppressMessages(activityinfo::queryTable(form = "INVALID"))), class = "http_404")
})
