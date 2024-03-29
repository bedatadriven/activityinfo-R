% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/records.R
\name{allColumnStyle}
\alias{allColumnStyle}
\title{A form table style including all columns with configurable label names}
\usage{
allColumnStyle(columnNames = c("code", "label"))
}
\arguments{
\item{columnNames}{Can be "pretty", "label", "id", c("code", "id), or c("code", "label")}
}
\description{
This function is primarily used in \link{getRecords}.

The column names options are:
\itemize{
\item "pretty": Using the labelling logic of the web user interface as much as possible, for example "Focus Country Name"
\item "label" : Using the form field labels in the style of activity info formulas, for example "[Focus Country].[Name]"
\item "code" : Using form field codes as defined by the user, for example "country.name". As codes are optional, the fallback columnName option can be specified as a vector, for example c("code", "label") or c("code", "id).
\item "id" : Using the form field unique id used by ActivityInfo, for example "c12c92vi5olfmn7khb4.c13cmf6la3lfmn7khb5"
}
}
