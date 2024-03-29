% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rest.R
\name{activityInfoAPICondition}
\alias{activityInfoAPICondition}
\title{Create an ActivityInfo API condition}
\usage{
activityInfoAPICondition(result, type = NULL, task = NULL, call = sys.call(-1))
}
\arguments{
\item{result}{The result of the API call}

\item{type}{forced type for the condition}

\item{task}{The task of the request}

\item{call}{The call stack}
}
\description{
Extends the httr conditions to be able to create specific condition messages for the API.
}
