## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ---- eval=FALSE--------------------------------------------------------------
#  # install.packages("devtools")
#  devtools::install_github("bedatadriven/activityinfo-R")

## -----------------------------------------------------------------------------
#  library(activityinfo)

## ---- eval=FALSE--------------------------------------------------------------
#  activityInfoLogin(userEmail, password)

## -----------------------------------------------------------------------------
#  db_schema <- getDatabaseSchema("ck35o0kja3")
#  head(db_schema)

## -----------------------------------------------------------------------------
#  form_schema <- getFormSchema("ck35pixlz9")
#  head(form_schema, 4)

## ---- warning=FALSE-----------------------------------------------------------
#  records <- getDatabaseRecordTable("ck35o0kja3", as.single.table = TRUE)
#  head(records)

## -----------------------------------------------------------------------------
#  qt <- queryTable("ck2ll1o1ec", columns = c(
#    id = "_id",
#    sum = "Parent.sum",
#    sqm = "[Square Meters]"
#  ))
#  head(qt)

