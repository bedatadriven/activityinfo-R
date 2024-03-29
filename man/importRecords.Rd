% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import.R
\name{importRecords}
\alias{importRecords}
\title{Batch imports a data.frame into an ActivityInfo form}
\usage{
importRecords(
  formId,
  data,
  recordIdColumn,
  parentIdColumn,
  stageDirect = TRUE,
  progress = getOption("activityinfo.import.progress", default = TRUE)
)
}
\arguments{
\item{formId}{The form ID}

\item{data}{The data.frame to import}

\item{recordIdColumn}{The record ID column}

\item{parentIdColumn}{The parent ID column required when importing a subform}

\item{stageDirect}{Whether the import should be directly staged to Google Cloud Storage. This may not be possible if connecting from Syria or other countries that are blocked from accessing Google services directly. This option is ignored when connecting to a self-managed instance of ActivityInfo.}

\item{progress}{Show import progress while waiting for import job to complete}
}
\description{
Please be aware of the 600 column and 200,000 row limit for ActivityInfo forms.
See more details here: https://www.activityinfo.org/support/docs/m/84877/l/1144008.html
}
\details{
Currently, not all types of fields are supported and you will get a warning
if you attempt to import records with unsupported fields.
}
