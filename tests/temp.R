roleId = "rp"
roleLabel = "Reporting partner"

# create a partner reference form
partnerForm <- formSchema(
  databaseId = database$databaseId, 
  label = "Reporting Partners") |>
  addFormField(
    textFieldSchema(
      code = "name",
      label = "Partner name", 
      required = TRUE))

addForm(partnerForm)

# create a reference partner table
partnerTbl <- tibble(id = paste0("partner",1:3), name = paste0("Partner ",1:3))

# import partner records
importRecords(partnerForm$id, data = partnerTbl, recordIdColumn = "id")

# create a reporting table with a reporting partner field
reportingForm <- formSchema(
  databaseId = database$databaseId, 
  label = "Reports") |>
  addFormField(
    referenceFieldSchema(
      referencedFormId = partnerForm$id, 
      code = "rp", 
      label = "Partner", 
      required = TRUE)) |>
  addFormField(
    textFieldSchema(
      label = "Report", 
      required = TRUE))

addForm(reportingForm)

# create a reports table
reportingTbl <- tibble(Partner = rep(paste0("partner",1:3), 2), Report = rep(paste0("This is a report from Partner ",1:3),2))

# import reports
importRecords(reportingForm$id, data = reportingTbl)

# create a role
newRole <- 
  role(id = roleId,
       label = roleLabel,
       parameters = list(
         parameter(id = "partner", label = "Partner", range = partnerForm$id)),
       grants = list(
         grant(resourceId = reportingForm$id,
               permissions = permissions(
                 view = sprintf("%s == @user.partner", partnerForm$id),
                 edit_record = sprintf("%s == @user.partner", partnerForm$id),
                 discover = TRUE,
                 export_records = TRUE)),
         grant(resourceId = partnerForm$id,
               permissions = permissions(
                 view = TRUE,
                 discover = FALSE))),
       filters = list(
         roleFilter(
           id = "partner", 
           label = "Partner is user's partner", 
           filter = sprintf("%s == @user.partner", partnerForm$id)))
  )


updateRole(databaseId = database$databaseId, role = newRole)

newRoleAbridged <- 
  role(id = roleId,
       label = roleLabel,
       parameters = list(
         parameter(id = "partner", label = "Partner", range = partnerForm$id)),
       grants = list(
         grant(resourceId = reportingForm$id,
               permissions = permissions(
                 view = sprintf("%s == @user.partner", partnerForm$id),
                 edit_record = sprintf("%s == @user.partner", partnerForm$id),
                 discover = TRUE,
                 export_records = TRUE)),
         grant(resourceId = partnerForm$id,
               permissions = permissions(
                 view = TRUE,
                 discover = FALSE))))

updateRole(databaseId = database$databaseId, role = newRoleAbridged)

deprecatedNonGrantRole <- list(
  id = "rpold",
  label = "Reporting partner",
  permissions = permissions(
    view = sprintf("%s == @user.partner", partnerForm$id),
    edit_record = sprintf("%s == @user.partner", partnerForm$id),
    export_records = TRUE
  ),
  parameters = list(
    list(
      id = "partner",
      label = "Partner",
      range = partnerForm$id
    )
  ),
  filters = list(
    list(
      id = "partner",
      label = "partner is user's partner",
      filter = sprintf("%s == @user.partner", partnerForm$id)
    )
  ))


updateRole(databaseId = database$databaseId, role = deprecatedNonGrantRole)

deprecatedNonGrantRoleNoFilter <- list(
  id = "rpold",
  label = "Reporting partner",
  permissions = permissions(
    view = sprintf("%s == @user.partner", partnerForm$id),
    edit_record = sprintf("%s == @user.partner", partnerForm$id),
    export_records = TRUE
  ),
  parameters = list(
    list(
      id = "partner",
      label = "Partner",
      range = partnerForm$id
    )
  ), grantBased = FALSE)

updateRole(databaseId = database$databaseId, role = deprecatedNonGrantRoleNoFilter)