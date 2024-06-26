% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/records.R
\name{updateRecord}
\alias{updateRecord}
\title{Updates a single record}
\usage{
updateRecord(formId, recordId, fieldValues)
}
\arguments{
\item{formId}{a form id}

\item{recordId}{a record id}

\item{fieldValues}{a named list of fields to change}
}
\description{
Updates a single record
}
\examples{
\dontrun{

# When updating field values, you can use either a field's code, or its
# built-in cuid. In the example below, "participant_dob" is a field code,
# and "cyz123456" is the same field's built-in id.

updateRecord(formId = "cyx123", fieldValues = list(participant_dob = "1980-01-01"))
updateRecord(formId = "cyx123", fieldValues = list(cxyz123456 = "1980-01-01"))

# To set a record to blank, use the NA value.
updateRecord(formId = "cupqmc2l1bvi9ys2",
  recordId = "ckl8h0l1bvj7lfd",
  fieldValues = list(HOH_NAME = NA))

# The value of the field depends on its type.
# Most fields can be specified using an R string or number, For example:
updateRecord(formId = "cxy123", recordId = "czyz3323", fieldValues = list(
   text_field = "Alice Jones",
   multi_line_text = "Line 1\nLine 2",
   date_of_birth = "1980-01-01",
   week_project_start = "2022W1",
   month = "2023-06",
   quantity_field = 42.0))

# Single- and multiple-select fields will accept either the label of the
# select item, or the item's built-in cuid. For multiple select, you can
# provide a vector of strings.
updateRecord(formId = "cxy123", recordId = "czyz3323", fieldValues = list(
   nationality = c("Palestinian", "Jordanian"),
   registered = "Yes"
))

# When providing a value for a reference field, you must provide
# the built-in ID of the related record. For example, if you a have
# a field that references the Afghanistan Province form
# (https://www.activityinfo.org/app#form/E0000001249/table),
# you must provide the record id, not the name of the province.

updateRecord(formId = "cxy123", recordId = "czyz3323", fieldValues = list(
   name = "Bibi Khan",
   province = "z0000000289"))

# When providing a value for geographic point fields, provide a named list
# for the point, including the latitude, longitude, and optionally the accuracy
# in meters reported by a geolocation sensor.

updateRecord(formId = "cxy123", recordId = "czyz3323", fieldValues = list(
   name = "Water point 42",
   location = list(latitude = 52.0735343, longitude = 4.3304164, accuracy = 12)
))

}
}
\seealso{
Other record functions: 
\code{\link{addRecord}()},
\code{\link{deleteRecord}()},
\code{\link{getAttachment}()},
\code{\link{getRecord}()},
\code{\link{getRecordHistory}()},
\code{\link{recoverRecord}()}
}
\concept{record functions}
