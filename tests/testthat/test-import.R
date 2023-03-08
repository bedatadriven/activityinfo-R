

test_that("importTable() works", {
  database <- addDatabase("Import tests")
  
  schema <- addForm(schema = formSchema(
    databaseId = database$databaseId,
    label = "Simple form",
    elements = list(
      textFieldSchema(label = "Name", key = TRUE),
      quantityFieldSchema(label = "How old are you?", code = "AGE"),
      dateFieldSchema(label = "Date of birth", code = "DOB"),
      singleSelectFieldSchema(label = "Sex", options = c("Female", "Male")),
      monthFieldSchema(label = "Month of registration", code = "MONTH"))))
  
  df <- data.frame(
    Name = c("Bob", "Alice"),
    AGE = c(29, 42),
    DOB = c("1980-01-15", "1990-03-10"),
    Sex = c("Male", "Female"),
    Month = c("2022-01", "2022-02"))
  
  importTable(schema$id, data = df)
  
  imported <- queryTable(schema$id)
  
  expect_equal(nrow(imported), 2)
  expect_identical(imported$Name[1], "Bob")
  expect_identical(imported$Name[2], "Alice")
})


test_that("importTable() works with stageDirect = FALSE", {
  
})


test_that("importTable() works with stageDirect = TRUE", {
  
})