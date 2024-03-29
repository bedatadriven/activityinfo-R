% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/records.R
\name{styledColumns}
\alias{styledColumns}
\title{Create the column selection object for queryTable() using styles}
\usage{
styledColumns(x, select, style = defaultColumnStyle(), forceId = FALSE)
}
\arguments{
\item{x}{the form id, form schema, form tree, or remote records object.}

\item{select}{a character vector of column names to select.}

\item{style}{a column style object.}

\item{forceId}{require the underlying expression for each column to be based
on form field ids and not the code or label}
}
\description{
This function is primarily used for \link{queryTable}. The default column style is
used or can be overridden using the style parameter.
}
