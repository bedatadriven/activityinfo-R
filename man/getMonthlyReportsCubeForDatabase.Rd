\name{getMonthlyReportsCubeForDatabase}
\alias{getMonthlyReportsCubeForDatabase}
\title{getMonthlyReportsCubeForDatabase}
\usage{
getMonthlyReportsCubeForDatabase(databaseId, month)
}
\arguments{
  \item{databaseId}{}

  \item{month}{the calendar month to retrieve in the format
  '2014-02'}
}
\description{
Retrieves a data.frame containing the siteId, indicatorId,
and indicatorName, month, and value columns for all sites
in the given database, combined with details about the
sites.
}
\details{
This routine will return only rows for those activities and
sites with results for the given months- if a site has no
results provided for the given month, it will not appear in
these results.
}

