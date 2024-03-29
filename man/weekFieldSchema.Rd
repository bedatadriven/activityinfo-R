% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formField.R
\name{weekFieldSchema}
\alias{weekFieldSchema}
\title{Create a week form field schema object}
\usage{
weekFieldSchema(
  label,
  description = NULL,
  code = NULL,
  id = cuid(),
  key = FALSE,
  required = key,
  hideFromEntry = FALSE,
  hideInTable = FALSE,
  relevanceRule = "",
  validationRule = "",
  reviewerOnly = FALSE
)
}
\arguments{
\item{label}{The label of the form field}

\item{description}{The description of the form field}

\item{code}{The code name of the form field}

\item{id}{The id of the form Field; default is to generate a new cuid}

\item{key}{Whether the form field is a key field; default is FALSE}

\item{required}{Whether the form field is required; default is FALSE}

\item{hideFromEntry}{Whether the form field is hidden during data entry; default is FALSE}

\item{hideInTable}{Whether the form field is hidden during data display; default is FALSE}

\item{relevanceRule}{Relevance rules for the form field given as a single character string; default is ""}

\item{validationRule}{Validation rules for the form field given as a single character string; default is ""}

\item{reviewerOnly}{Whether the form field is for reviewers only; default is FALSE}
}
\description{
The Week format in ActivityInfo is YYYY-WW. Users can directly type using
this format or use the calendar to select a week. Please note that the Week
field uses the EPI week convention.
}
\seealso{
Other field schemas: 
\code{\link{attachmentFieldSchema}()},
\code{\link{barcodeFieldSchema}()},
\code{\link{calculatedFieldSchema}()},
\code{\link{dateFieldSchema}()},
\code{\link{formFieldSchema}()},
\code{\link{geopointFieldSchema}()},
\code{\link{monthFieldSchema}()},
\code{\link{multilineFieldSchema}()},
\code{\link{multipleSelectFieldSchema}()},
\code{\link{quantityFieldSchema}()},
\code{\link{referenceFieldSchema}()},
\code{\link{sectionFieldSchema}()},
\code{\link{serialNumberFieldSchema}()},
\code{\link{singleSelectFieldSchema}()},
\code{\link{subformFieldSchema}()},
\code{\link{userFieldSchema}()}
}
\concept{field schemas}
