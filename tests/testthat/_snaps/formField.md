# Test deleteFormField()

    structure(list(databaseId = "<id value>", elements = list(structure(list(
        code = "txt2", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 2", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list")), structure(list(
        code = "txt4", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 4", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list")), structure(list(
        code = "txt5", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 5", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list"))), id = "<id value>", 
        label = "R form with multiple fields to delete"), class = c("activityInfoFormSchema", 
    "formSchema", "list"))

---

    structure(list(databaseId = "<id value>", elements = list(structure(list(
        code = "txt1", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 1", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list")), structure(list(
        code = "txt2", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 2", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list")), structure(list(
        code = "txt3", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 3", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list")), structure(list(
        code = "txt5", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 5", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list"))), id = "<id value>", 
        label = "R form with multiple fields to delete"), class = c("activityInfoFormSchema", 
    "formSchema", "list"))

---

    structure(list(databaseId = "<id value>", elements = list(structure(list(
        code = "txt2", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 2", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list")), structure(list(
        code = "txt3", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 3", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list")), structure(list(
        code = "txt4", description = NULL, id = "<id value>", key = FALSE, 
        label = "Text field 4", relevanceCondition = "", required = FALSE, 
        tableVisible = TRUE, type = "FREE_TEXT", typeParameters = list(
            barcode = FALSE), validationCondition = ""), class = c("activityInfoTextFieldSchema", 
    "activityInfoFormFieldSchema", "formField", "list"))), id = "<id value>", 
        label = "R form with multiple fields to delete"), class = c("activityInfoFormSchema", 
    "formSchema", "list"))

# migrateFieldData() works

    Code
      recordsMinimal
    Output
          a  b  c       newA newB newC
      1   1  1  1 2023-03-01    1    a
      2   2  2  2 2023-03-02    2    b
      3   3  3  3 2023-03-03    3    c
      4   4  4  4 2023-03-04    4    d
      5   5  5  5 2023-03-05    5    e
      6   6  6  6 2023-03-06    6    f
      7   7  7  7 2023-03-07    7    g
      8   8  8  8 2023-03-08    8    h
      9   9  9  9 2023-03-09    9    i
      10 10 10 10 2023-03-10   10    j

