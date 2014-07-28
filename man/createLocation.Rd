\name{createLocation}
\alias{createLocation}
\title{Creates a new site}
\usage{
createLocation(id = generateId(), locationTypeId, name, axe = NULL,
  longitude = NULL, latitude = NULL)
}
\arguments{
  \item{id}{the id for the new location}

  \item{locationTypeId}{the id of the locationType to which
  to add this location}

  \item{name}{the name of the location}

  \item{axe}{an optional secondary name of the location
  (originally axe routiere, but can be used for PCODEs or
  alternate spellings)}

  \item{longitude}{optional latitude of the location}

  \item{latitude}{optional longitude of the location}
}
\description{
Creates a new site
}

