\name{getMonthlyReportsCube}
\alias{getMonthlyReportsCube}
\title{getMonthlyReportsCube}
\usage{
getMonthlyReportsCube(activityId, month)
}
\arguments{
  \item{activityId}{the activityid}

  \item{month}{the calendar month to retrieve in the format
  '2014-02'}
}
\description{
Retrieves a data.frame containing sites and indicators in
rows
}
\examples{
\dontrun{
db <- getDatabase(1064)
sites <- getSitesDataFrame(db$activities[[1]])
cube <- getMonthlyReportsCube(1064, month = '2014-06')
merge(sites, cube)
}
}

