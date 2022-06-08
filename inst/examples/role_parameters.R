
library(activityinfo)

databaseId <- "cs962g1kz74fld52"

# This is the form that provides the values for the user's parameter.
# In this case, it is a list of sectors.
sectorFormId <- "c9xo8hnkzsgz6pp2"

role <- list(
  id = "operation",
  label = "Operation reporter",
  permissions = list(),
  parameters = list(
    list(parameterId = "operation",
         label = "Operation",
         range = sectorFormId)
  ),
  filters = list(
    list(id = "operationfilter",
         label = "belongs to the user's operation",
        filter = "c9xo8hnkzsgz6pp2 == @user.operation")
  )
)

updateRole(databaseId, role)
