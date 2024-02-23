testthat::test_that("getQuantityTable() works", {
  dbTest <- addDatabase("Reporting DB")
  form <- addForm(formSchema(
    dbTest$databaseId,
    label = "Activities",
    elements = list(textFieldSchema("Province", code = "PROVINCE", key = TRUE),
                    quantityFieldSchema("Nb of families", code = "FAM"),
                    quantityFieldSchema("Nb of clinics", code = "CLINICS"))))
  
  addRecord(formId = form$id, fieldValues = list(PROVINCE = "North", FAM = 1012, CLINICS = 5))
  addRecord(formId = form$id, fieldValues = list(PROVINCE = "South", FAM = 4445, CLINICS = 13))
  
  quantityTable <- getQuantityTable(databaseId = dbTest$databaseId)
  assertthat::assert_that(nrow(quantityTable) == 4)
})
