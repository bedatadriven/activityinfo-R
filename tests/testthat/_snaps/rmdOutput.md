# Rmd outputs as expected

    Code
      writeLines(text)
    Output
      TestMessages
      Nicolas Dickinson
      2022-12-11
      This is a test of issue #29
      try({
      if (grepl(pattern = &quot;activityinfo-R$&quot;, rstudioapi::getActiveProject())) {
      devtools::load_all(&quot;.&quot;)
      withr::with_options(new = list(activityinfo.interactive = FALSE), {
      source(file = testthat::test_path(&quot;setup.R&quot;))
      })
      }
      }, silent = TRUE)
      dt &lt;- as.data.frame(getFormSchema(formId = personFormId))
      knitr::kable(dt[,c(&quot;fieldCode&quot;, &quot;fieldType&quot;)])
      fieldCode
      fieldType
      NAME
      FREE_TEXT
      CHILDREN
      subform
      NA
      reference
      NA
      reference
      NA
      reference

