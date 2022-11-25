testthat::test_that("parseColumnSet() works", {
  
})

testthat::test_that("queryTable() returns a data.frame with 2 rows and expected columns", {
  output = suppressWarnings(suppressMessages(activityinfo::queryTable(form = personFormId)))
  testthat::expect_true(inherits(output, 'data.frame')) 
  testthat::expect_true(nrow(output) == 2)
  testthat::expect_true(all(c("X.id","X.lastEditTime","NAME","CHILDREN") %in% names(output)))
})

testthat::test_that("queryTable() returns a valid data.frame with the same column names as the input columns if the user gives a specific number of 'columns' as input ", {
  
  input_parameters = list(form = childrenSubformId,
                          "Person name" = "NAME",
                          "Date of Birth" = "DOB")
  
  names_parameters = names(input_parameters)[-1]     # exclude the 'form' parameter
  names_valid = make.names(names_parameters)         # make valid names
  
  output = suppressWarnings(suppressMessages((do.call(activityinfo::queryTable, input_parameters))))
  
  testthat::expect_true(inherits(output, 'data.frame'))
  testthat::expect_true(all(names_valid %in% colnames(output)))
})


testthat::test_that("queryTable() returns a single column data.frame if the input is a single column", {
  
  input_parameters = list(form = personFormId,
                          "Person name" = "NAME")
  
  names_parameters = names(input_parameters)[-1]     # exclude the 'form' parameter
  names_valid = make.names(names_parameters)         # make valid names
  
  output = suppressWarnings(suppressMessages((do.call(activityinfo::queryTable, input_parameters))))
  
  testthat::expect_true(inherits(output, 'data.frame'))
  testthat::expect_true(all(names_valid %in% colnames(output)))
  testthat::expect_identical(length(colnames(output)), 1L)
  
})


testthat::test_that("queryTable() returns missing values (NA's) for the specified column if the corresponding to the column ID is invalid", {
  
  input_parameters = list(form = childrenSubformId,
                          "Serial number" = "INVALID")
  
  names_param = names(input_parameters)[-1]
  names_valid = make.names(names_param)
  
  output = suppressWarnings(suppressMessages((do.call(activityinfo::queryTable, input_parameters))))
  
  testthat::expect_true(inherits(output, 'data.frame') & all(names_valid %in% colnames(output)) & all(is.na(output[[names_valid]])) )
})


testthat::test_that("queryTable() gives an error if the input 'form' parameter is invalid", {
  testthat::expect_error( suppressWarnings(suppressMessages(activityinfo::queryTable(form = "INVALID"))), class = "http_404")
})


# testthat::test_that("the loaded 'cvhp7v7l45jy5av3.csv' file and the retrieved data.frame from the Activityinfo API are identical", {
#   
#   output = suppressWarnings(suppressMessages(activityinfo::queryTable(form = FORM_ID)))
#   dat_csv = utils::read.csv(file = pth_csv, stringsAsFactors = F, header = T, colClasses = c('character', 'numeric', rep('character', 2), 'numeric', rep('character', 4)))
#   dat_csv$Serial.number = gsub("['’]", "", dat_csv$Serial.number)
#   
#   testthat::expect_true( identical(x = dat_csv, y = output) )
# })