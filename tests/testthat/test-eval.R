test_that("toActivityInfoFormula() works", {
  x <- getRecords(
    getDatabaseResources(database$databaseId) %>% filter(label == "Person form") %>% pull(id)
  )
  y <- getRecords(
    getDatabaseResources(database$databaseId) %>% filter(label == "Children") %>% pull(id)
  )
  
  testthat::expect_equal(toActivityInfoFormula(x, `_id`),"_id")
  testthat::expect_equal(toActivityInfoFormula(x, `_lastEditTime`),"_lastEditTime")
  testthat::expect_equal(toActivityInfoFormula(x, `Children`),x$step$columns[["Children"]])
  testthat::expect_equal(toActivityInfoFormula(x, `[Children]`),sprintf("%s.%s", x[["formTree"]]$root, x[["step"]]$columns[["Children"]]))
  testthat::expect_equal(toActivityInfoFormula(x, `[Children].[Child name]`),sprintf("%s.%s.%s", x[["formTree"]]$root, x[["step"]]$columns[["Children"]], y[["step"]]$columns[["Child name"]]))
    
  aIFormula <- toActivityInfoFormula(x, TEXTJOIN(",", TRUE, `[Children].NAME`))
  aIFormula2 <- toActivityInfoFormula(x, TEXTJOIN(",", TRUE, x$Children$NAME))
  
  pre_df_1 <- mutate(x, children_names = TEXTJOIN(",", TRUE, x$Children$NAME))
  
  df <- pre_df_1 %>% 
    filter(`Respondent name` == "Bob", `Respondent name` == x$`Respondent name`, `Respondent name`==`[Respondent name]`) %>%
    collect()

  testthat::expect_true(nrow(df)==1)
  testthat::expect_true(all(!is.na(df$children_names)&lengths(df$children_names)>0))
  
  df <- x %>% 
    mutate(
      children_names = TEXTJOIN(",", TRUE, x$Children$NAME)
    ) %>% 
    select(starts_with("_"), children_names) %>% 
    collect()
  
  testthat::expect_true(all(!is.na(df$children_names)&lengths(df$children_names)>0))
  
  df <- y %>% mutate(parent_name = y$`@parent`$NAME) %>% collect()
  
  testthat::expect_true(nrow(df)>1)
  testthat::expect_true(all(!is.na(df$parent_name)&lengths(df$parent_name)>0))
  
})

test_that("$ syntax works to create variable expressions and activityInfoVariableExpression() and getNextExpansions() works", {
  # these are implicit in the $ tests
  # reference field
  # sub-form field
  # multiple reference field
  # reverse reference field
  
  testthat::expect_no_error({
    personSchemaCopy <- getFormSchema(personFormId)
    
    titleFieldSchema <- textFieldSchema("Title", code = "title_field")
    authorFieldSchema <- referenceFieldSchema("Author[yup!!]", code = "author_field", referencedFormId = personSchemaCopy$id)
    aboutFieldSchema <- multipleReferenceFieldSchema("People referenced", code = "about_people", referencedFormId = personSchemaCopy$id)
    descFieldSchema <- textFieldSchema("Description", code = "desc_field")
    
    entryFormSchema <- formSchema(databaseId = database$databaseId, "Journal entry") %>%
      addFormField(titleFieldSchema) %>%
      addFormField(authorFieldSchema) %>%
      addFormField(aboutFieldSchema) %>%
      addFormField(descFieldSchema)
    
    authorReversed <- reverseReferenceFieldSchema(
      "Author (reverse reference) ------------ really long", 
      referencedFormId = entryFormSchema$id, 
      referencedFieldId = authorFieldSchema$id,
      code = "author_reverse")
    
    aboutReversed <- reverseReferenceFieldSchema(
      "People referenced (reverse reference) ------------ really long", 
      referencedFormId = entryFormSchema$id, 
      referencedFieldId = aboutFieldSchema$id,
      code = "about_reverse")
    
    personSchemaCopy <- personSchemaCopy %>%
      addFormField(authorReversed) %>%
      addFormField(aboutReversed)
    
    dbMetadata <- addForm(databaseId = database$databaseId, schema = entryFormSchema)
    dbMetadata <- updateFormSchema(schema = personSchemaCopy)
    
    x <- getRecords(personSchemaCopy$id)
    
    # with reverse reference fields
    # with special characters in label using remote column expression
    # with code
    x$author_reverse$`[Author[yup!!]]`
    x$CHILDREN$`_id`
    
    # with circular reference fields
    x$author_reverse$author_field$CHILDREN
    x$about_reverse$about_people$author_reverse$author_field
    
    # with multiple reference fields
    x$author_reverse$about_people$CHILDREN
    
    # climb back up to parent
    x$author_reverse$about_people$CHILDREN$`@parent`$NAME
    
    # using local calculated column from lazy data frame
    y <- x %>% mutate(chldrn_plus_one = Children+1)
    y$chldrn_plus_one
    z <- collect(y)
    testthat::expect_gt(nrow(z),0)
    testthat::expect_gt(sum(z$chldrn_plus_one),0)
    
    yy <- y %>% select(y$chldrn_plus_one) %>% mutate(chldrn_plus_one2 = y$chldrn_plus_one) %>% collect()
    testthat::expect_gt(nrow(yy),0)
    testthat::expect_gt(sum(yy$chldrn_plus_one2),0)
  })
})
