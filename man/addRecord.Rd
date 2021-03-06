% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/records.R
\name{addRecord}
\alias{addRecord}
\title{Adds a new record}
\usage{
addRecord(formId, parentRecordId = NA_character_, fieldValues)
}
\arguments{
\item{formId}{the id of the form to which the record should be added}

\item{parentRecordId}{the id of this record's parent record, if the form is a subform}

\item{fieldValues}{a named list of fields to change}
}
\description{
Adds a new record
}
