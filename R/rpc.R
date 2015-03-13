
#' @export
#' @importFrom httr POST
#' @importFrom rjson toJSON fromJSON
executeCommand <- function(type, ...) {
  body <- list( type = type,
                command = list(...))

  url <- paste(activityInfoRootUrl(), "command", sep = "/")
  result <- POST(url, body = toJSON(body), activityInfoAuthentication())
  
  
  if (!result$status_code %in% seq(from=200, to=299, by=1)) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  }
  
  # is status code is not 200 or 201, the content() function may not return anything:
  tryCatch(fromJSON(content(result, as = "text", encoding = "UTF-8")),
           error=function(e) invisible())
}

requiredString <- function(x) {
  stopifnot(is.character(x))
  x
}

optionalString <- function(x) {
  x
}

requiredId <- function(x) {
  stopifnot(is.double(x) || is.integer(x))
  as.integer(x)
}

requiredBoolean <- function(x) {
  stopifnot(is.logical(x))
  as.logical(x)
}

optionalInteger <- function(x) {
  x
}

propertyList <- function(args, ...) {
  accessors <- list(...)
  properties <- list()
  for(i in 1:length(accessors)) {
    propertyName <- names(accessors)[i]
    accessor <- accessors[[i]]
    propertyValue <- tryCatch(accessor(args[[propertyName]]),
                              error = function(e) stop(paste(propertyName, e, sep=":")))
    if(!is.null(propertyValue)) {
      properties[propertyName] <- propertyValue
    }
  }
  properties
}

#' @export
generateId <- function()
  as.integer(runif(1, min = 0, max=2^31))


#' @export
createEntity <- function(entityName, properties) {
  
  result <- executeCommand("CreateEntity", 
                 entityName = entityName,
                 properties = properties)
  result$newId
}

#' Creates a new database
#' @param name a short-ish name for the database
#' @param description a longer description of the database
#' @param country the location and geographic reference data to use: either the
#'   numeric identifier used by ActivityInfo or an ISO-3166 two-letter code
#' @examples \dontrun{
#' id <- createDatabase(name="My Database in Bangladesh", countryId = "BD")
#' }
#' @references See \url{http://en.wikipedia.org/wiki/ISO_3166-2} for two-letter
#'   country codes.
#' @return Returns the numeric id of the newly created database.
#' @export
createDatabase <- function(name, description = NULL, countryId) {
  if(missing(countryId)) {
    stop("you must provide a country for the database, either using a numeric id or an ISO-3166 two-letter code.")
  }
  countryId <- lookupCountryId(countryId)
  createEntity("UserDatabase",
                  properties = list(
                    name = name,
                    description = description,
                    countryId = countryId))
}

#' Looks up the internal identifier for a country by code
#' @param countryId the country's name or ISO-3166-2 code 
#' @return the country's internal identifier used by AI.
#' @export
lookupCountryId <- function(countryId) {
  if(is.numeric(countryId)) {
    return(countryId)
  } else {
    countries <- getCountries()
    for(i in 1:nrow(countries)) {
      if(identical(as.character(countries$code[i]), countryId) ||
         identical(countries$name[i], countryId)) {
        return(countries$id[i])
      } 
    }
  }
  stop(paste(sprintf("Invalid country id '%s': tried matching against ISO-3166-1 alpha-2 codes and name.", countryId),
                     "See https://www.activityinfo.org/resources/countries for a full list of codes."))
}


#' Creates a new activity
#' @param databaseId the numeric id of the database in which to create this activity
#' @param name the activity's name
#' @param category the new activity's category as a string
#' @param locationTypeId the numeric id of the activity's location type
#' @param reportingFrequency a string that defines the reporting frequency; can 
#' be "once" (default) or "monthly"
#' @return Returns the numeric id of the newly created activity.
#' @export
createActivity <- function(databaseId, name, category = NULL, locationTypeId,
                           reportingFrequency = c("once", "monthly")) {
  if(missing(locationTypeId)) {
    stop("you must provide a locationTypeId")
  }
  locationTypeId <- lookupLocationType(databaseId, locationTypeId)
  
  if(is.numeric(reportingFrequency)) {
    rpCode <- reportingFrequency
  } else {
    rpCode <- switch(match.arg(reportingFrequency),
                once = 0,
                monthly = 1)
  }
  
  createEntity("Activity", 
      list(databaseId = databaseId,
           name = name,
           category = category,
           locationTypeId = locationTypeId,
           reportingFrequency = rpCode))
}

lookupLocationType <- function(databaseId, locationTypeId) {
  if(is.numeric(locationTypeId)) {
    return(locationTypeId)
  }
  db <- getDatabaseSchema(databaseId)
  countryId <- db$country$id
  types <- getLocationTypes(countryId)
  for(type in types) {
    if(identical(type$name, locationTypeId)) {
      return(type$id)
    }
  }
  stop(sprintf("Could not match locationTypeId %s to a location type in country %s: %s",
               deparse(locationTypeId),
               db$country$name,
               paste(sapply(types, function(t) t$name), collapse=",")))
}

#' Creates a new Indicator
#' @param activityId the numeric id of the activity to which this indicator
#'   should be added
#' @param name the name of this indicator
#' @param category the activity's category as a string
#' @param listHeader a short label to be used when displaying the indicator as a
#'   column
#' @param description an extended description of this indicator
#' @param units the units of measure of this indicator
#' @param aggregation the method to use when aggregating this indicator's values; 
#'   can be "sum" (default), "mean" or "count"
#' @param sortOrder an ordinal value indicating the order of this indicator
#' @return Returns the numeric id of the newly created indicator.
#' @export
createIndicator <- function(activityId, 
                            name, 
                            category = NULL, 
                            listHeader = NULL, 
                            description = NULL,
                            units,
                            aggregation = c("sum", "mean", "count"),
                            sortOrder = NULL) {
  
  if(is.numeric(aggregation)) {
    aggCode <- aggregation
  } else {
    aggCode <- switch(match.arg(aggregation),
                     sum = 0,
                     mean = 1,
                     count = 2)
  }
  
  createEntity("Indicator", 
               list(
                 activityId = activityId,
                 name = name, 
                 category = category,
                 listHeader = listHeader,
                 description = description, 
                 units = units,  
                 aggregation = aggCode,
                 sortOrder = sortOrder))
}


#' Creates a new AttributeGroup
#' 
#' @export
createAttributeGroup <- function(...) 
  createEntity("AttributeGroup", 
               propertyList(list(...), 
                            activityId = requiredId,
                            name = requiredString, 
                            multipleAllowed = requiredBoolean,
                            mandatory = requiredBoolean))


#' Creates a new attribute
#' 
#' @export
createAttribute <- function(...) 
  createEntity("Attribute", 
               propertyList(list(...), 
                            attributeGroupId = requiredId,
                            name = requiredString))


#' Creates a new site
#' 
#' @export
createSite <- function(properties) 
  executeCommand("CreateSite", properties = properties)


#' Creates a new site
#' @param id the id for the new location
#' @param locationTypeId the id of the locationType to which to add this location
#' @param name the name of the location
#' @param axe an optional secondary name of the location (originally axe routiere, but can be
#'        used for PCODEs or alternate spellings)
#' @param longitude optional latitude of the location
#' @param latitude optional longitude of the location
#' @export 
createLocation <- function(id = generateId(), locationTypeId, name, axe = NULL, longitude = NULL, latitude = NULL) 
  invisible(executeCommand("CreateLocation", properties = list(
      id=id, 
      locationTypeId=locationTypeId, 
      name=name,
      axe=axe,
      longitude=longitude,
      latitude=latitude)))

#' Deletes an activity
#' 
#' @export
deleteActivity <- function(activityId) 
  invisible(executeCommand("Delete", entityName = "Activity", id = activityId))

#' Deletes an indicator
#' 
#' @export
deleteIndicator <- function(indicatorId) 
  invisible(executeCommand("Delete", entityName = "Indicator", id = indicatorId))

#' Deletes a site
#' 
#' @export
deleteSite <- function(siteId) 
  invisible(executeCommand("DeleteSite", id = siteId))


#' Deletes an attribute group
#' 
#' @export
deleteAttributeGroup <- function(attributeGroupId) 
  invisible(executeCommand("Delete", entityName = "AttributeGroup", id = attributeGroupId))


#' Adds a partner to a database. 
#' 
#' Currently, partners are globally shared objects with an identity derived from their
#' name. 
#' 
#' @param databaseId the numeric id of the database to which the partner will be added
#' @param partnerName the partner's acronym or shortened name
#' @param partnerFullName the partner's complete name. Only used if a partner identified by 'partnerName' does 
#'        not yet exist
#' @return Returns the numeric id of the partner. 
#' @export 
addPartner <- function(databaseId, partnerName, fullPartnerName = NULL) {
  result <- executeCommand("AddPartner", 
                          databaseId=databaseId,
                          partner=list(name=partnerName, fullName=fullPartnerName))
  result$newId
}



#' Updates a user's permission to access a database. 
#' 
#' If the user identified by the 
#' given email address does not yet have an ActivityInfo account, they will receive
#' an email inviting them to create a new account and choose a password.
#' 
#' @param databaseId the id of the database
#' @param userEmail the user's email address
#' @param userName the user's full name. If the user with this email address already has an 
#'                  activityinfo account, this parameter will have no effect.
#' @param partner the id or name of the partner to which the user will be added.
#' @param allowView if TRUE, the user can view sites belonging to their partner
#' @param allowViewAll if TRUE, the user can view sites belonging to all partners
#' @param allowEdit if TRUE, the user can create and edit sites belonging to their partner
#' @param allowEditAll if TRUE, the user can  create and edit sites belonging to all partners
#' @param allowDesign if TRUE, the user can create and modify the structure of the database
#' @param allowManageUsers if TRUE, the user can change the permission of users for the database within their own partner
#' @param allowManageUsers if TRUE, the user can change the permission of all users within the database
#' @export
updateUserPermissions <- function(databaseId, 
                                  userEmail, userName, 
                                  partner,
                                 allowView = TRUE,
                                 allowViewAll = FALSE,
                                 allowEdit = FALSE,
                                 allowEditAll = FALSE,
                                 allowDesign = FALSE,
                                 allowManageUsers = FALSE,
                                 allowManageAllUsers = FALSE) {
  userEmail <- as.character(userEmail)
  userName <- as.character(userName)
  
  stopifnot(grepl(userEmail, pattern=".+@.+"))
  stopifnot(!missing(userName))
 
  partnerId <- lookupPartnerId(databaseId, partner)
  
  invisible(executeCommand("UpdateUserPermissions", 
                 databaseId = databaseId,
                 model = list(
                   name = userName,
                   email = userEmail,
                   partner = list(id = partnerId),
                   allowView = allowView,
                   allowViewAll = allowViewAll,
                   allowEdit = allowEdit,
                   allowEditAll = allowEditAll,
                   allowDesign = allowDesign,
                   allowManageUsers = allowManageUsers,
                   allowManageAllUsers = allowManageAllUsers)))
}

#' Retrieves a partner's id from a database by name
#' 
#' @param databaseId the database in which to look
#' @param partnerId numeric id or short name on which to search
#' @return the partner's numeric id
#' @export
lookupPartnerId <- function(databaseId, partnerId) {
  db <- getDatabaseSchema(databaseId)
  for(partner in db$partners) {
    if(is.numeric(partnerId) && length(partnerId) == 1 &&
         partnerId == partner$id) {
        return(partner$id)
        
    } else if(identical(partnerId, partner$name)) {
        return(partner$id)
    }
  }
  
  partnerNames <- paste(sort(sapply(db$partners, function(p) p$name)), collapse=", ")
  stop(sprintf("Could not find partner with id or name %s in database %d. The following partners are present: %s",
               deparse(partnerId), databaseId, partnerNames))
  
}

#' Retrieves a list of authorized users of the given database
#' @param databaseId the id of the database for which to retrieve authorized users
#' @export
getAuthorizedUsers <- function(databaseId) 
  executeCommand("GetUsers", databaseId = databaseId)$data
