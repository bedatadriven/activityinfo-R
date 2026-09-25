testthat::test_that("Rmd outputs as expected", {
  testthat::expect_no_warning(
    testthat::expect_no_error(
      suppressMessages(capture_output(rmarkdown::render(testthat::test_path("ext/TestMessages.Rmd"))))
    )
  )
  
  # Compare only the text of the rendered body: the rest of the html depends on 
  # the versions of pandoc and rmarkdown
  html <- paste(readLines(testthat::test_path("ext/TestMessages.html"), warn = FALSE), collapse = "\n")
  body <- sub(".*<body[^>]*>(.*)</body>.*", "\\1", html)
  body <- gsub("(?s)<script.*?</script>|<style.*?</style>", "", body, perl = TRUE)
  text <- trimws(unlist(strsplit(gsub("<[^>]+>", "", body), "\n")))
  text <- text[nzchar(text)]
  
  testthat::expect_snapshot(writeLines(text))
})
