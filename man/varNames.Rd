% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/records.R
\name{varNames}
\alias{varNames}
\title{Get the variable and/or column names for forms}
\usage{
varNames(x, style, addNames)
}
\arguments{
\item{x}{the form id, form schema, form tree, or remote records object.}

\item{style}{a column style object.}

\item{addNames}{if TRUE will name the vector. Used internally to create
column selection objects for \link{queryTable}. Typically a helper function such
as \link{prettyColumns} should be used to create columns.}
}
\description{
This function provides the list of variable names in the
\link{defaultColumnStyle} but it is possible to override with another style.
}
