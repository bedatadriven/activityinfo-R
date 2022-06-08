

testthat::test_that("the function returns a warning if there is an anonymous access to the 'activityinfo' API", {

  testthat::expect_warning( suppressMessages(activityinfo::queryTable(form = FORM_ID)) )
})


testthat::test_that("the function returns a data.frame with 2 rows and multiple columns", {

  output = suppressWarnings(suppressMessages(activityinfo::queryTable(form = FORM_ID)))

  testthat::expect_true( inherits(output, 'data.frame') & nrow(output) == 2 & ncol(output) > 1 )
})


testthat::test_that("if the user gives a specific number of 'columns' as input then the function returns a valid data.frame with the same column names as the input columns", {

  input_parameters = list(form = FORM_ID,
                          "Serial number" = "cxiu5aul45jyco35",
                          "What is your name?" = "c2n3mwtl45jyo3m7",
                          "Quantity" = "cdyxb4ol45jyiu96",
                          "Birth date" = "ci18vg1l45jz2eh8",
                          "Current month" = "cap72e1l45jzhal9",
                          "Favorite color" = "cbtgy16l45k0mlwf",
                          "Nationality" = "cm3iy15l45kaihtt")

  names_parameters = names(input_parameters)[-1]     # exclude the 'form' parameter
  names_valid = make.names(names_parameters)         # make valid names

  output = suppressWarnings(suppressMessages((do.call(activityinfo::queryTable, input_parameters))))

  testthat::expect_true( inherits(output, 'data.frame') & nrow(output) == 2 & all(names_valid %in% colnames(output)) )
})


testthat::test_that("the function returns a single column data.frame if the input is a single column", {

  input_parameters = list(form = FORM_ID,
                          "Serial number" = "cxiu5aul45jyco35")

  names_parameters = names(input_parameters)[-1]     # exclude the 'form' parameter
  names_valid = make.names(names_parameters)         # make valid names

  output = suppressWarnings(suppressMessages((do.call(activityinfo::queryTable, input_parameters))))

  testthat::expect_true( inherits(output, 'data.frame') & nrow(output) == 2 & all(names_valid %in% colnames(output)) )
})


testthat::test_that("the function returns missing values (NA's) for the specified column if the corresponding to the column ID is invalid", {

  input_parameters = list(form = FORM_ID,
                          "Serial number" = "INVALID")

  names_param = names(input_parameters)[-1]
  names_valid = make.names(names_param)

  output = suppressWarnings(suppressMessages((do.call(activityinfo::queryTable, input_parameters))))

  testthat::expect_true( inherits(output, 'data.frame') & nrow(output) == 2 & all(names_valid %in% colnames(output)) & all(is.na(output[[names_valid]])) )
})


testthat::test_that("the function gives an error if the input 'form' parameter is invalid", {

  testthat::expect_error( suppressWarnings(suppressMessages(activityinfo::queryTable(form = "INVALID"))) )
})

