test_that("importTable() works", {
  database <- addDatabase("Test database")
  schema <- addForm(schema = formSchema(
    databaseId = database$databaseId,
    label = "Import test",
    elements = list(
      textFieldSchema(label = "Name", key = TRUE),
      quantityFieldSchema(label = "How old are you?", code = "AGE"),
      dateFieldSchema(label = "Date of birth", code = "DOB"),
      singleSelectFieldSchema(label = "Sex", options = c("Female", "Male")),
      monthFieldSchema(label = "Month of registration", code = "MONTH"))))
  
  df <- data.frame(
    Name = c("Bob", "Alice"),
    Age = c(29, 42),
    DOB = c("1980-01-15", "1990-03-10"),
    Sex = c("Male", "Female"),
    Month = c("2022-01", "2022-02"))
  
  importTable(schema$id, data = df)
  
  fmSchm <- addFormField(formSchema = fmSchm, schema = fieldSchema)
  dbMetadata <- addForm(databaseId = databaseId, schema = fmSchm)
})
