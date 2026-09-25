

test_that("importRecords() works", {
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
  
  importRecords(schema$id, data = df)
  
  imported <- queryTable(schema$id)
  
  expect_equal(nrow(imported), 2)
  expect_identical(imported$Name[1], "Bob")
  expect_identical(imported$Name[2], "Alice")
  
  testthat::test_that("importTable() is deprecated.", {
    testthat::expect_warning({
      importTable(schema$id, data = df)
    })
  })
  
})


test_that("importRecords() works with stageDirect = FALSE", {
  
})


test_that("importRecords() works with stageDirect = TRUE", {
  
})

test_that("importRecords() works with multiple reference fields and getRecords() skips notes", {
  target <- addForm(schema = formSchema(
    databaseId = database$databaseId,
    label = "Multiple reference target",
    elements = list(
      textFieldSchema(label = "Name", code = "NAME", key = TRUE))))
  
  importRecords(target$id, data = data.frame(NAME = c("A", "B", "C")))
  targetRecords <- queryTable(target$id, id = "_id", name = "NAME")
  ids <- targetRecords$id[order(targetRecords$name)]
  
  schema <- addForm(schema = formSchema(
    databaseId = database$databaseId,
    label = "Multiple reference source",
    elements = list(
      textFieldSchema(label = "Title", code = "TITLE", key = TRUE),
      noteFieldSchema(label = "A note", description = "Some guidance"),
      multipleReferenceFieldSchema(label = "Targets", code = "TARGETS", referencedFormId = target$id))))
  
  df <- data.frame(
    TITLE = c("None", "One", "Two"),
    TARGETS = c(NA, ids[1], paste(ids[2], ids[3], sep = ",")))
  
  importRecords(schema$id, data = df)
  
  imported <- queryTable(schema$id, title = "TITLE", targets = "TARGETS")
  imported <- imported[order(imported$title),]
  
  expect_identical(imported$title, c("None", "One", "Two"))
  expect_true(is.na(imported$targets[1]))
  expect_identical(imported$targets[2], ids[1])
  expect_setequal(strsplit(imported$targets[3], "\\s*,\\s*")[[1]], ids[2:3])
  
  expect_error(
    importRecords(schema$id, data = data.frame(TITLE = "Bad", TARGETS = "not a record id!")),
    regexp = "invalid record ids"
  )
  
  records <- getRecords(schema$id, style = allColumnStyle()) %>% collect()
  expect_false(any(grepl("note", names(records), ignore.case = TRUE)))
  expect_true("TARGETS" %in% names(records))
})
