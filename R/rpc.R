
#' @export
#' @importFrom httr POST
#' @importFrom rjson toJSON fromJSON
executeCommand <- function(type, ...) {
  body <- list( type = type,
                command = list(...))

  print(body)
  
  url <- paste(activityInfoRootUrl(), "command", sep = "/")
  result <- POST(url, body = toJSON(body), activityInfoAuthentication())
  
  
  if(result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d: %s",
                 url, result$status_code, result$headers$statusmessage))
  }
  
  fromJSON(content(result, as = "text", encoding = "UTF-8"))
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
#' @export
createDatabase <- function(name, description, countryId) 
  createEntity("UserDatabase",
                  properties = list(
                    name = name,
                    description = description,
                    countryId = countryId))

#' Creates a new activity
#' @export
createActivity <- function(...) 
  createEntity("Activity", 
    propertyList(list(...), 
                   databaseId = requiredId,
                   name = requiredString,
                   category = optionalString,
                   locationTypeId = requiredId,
                   reportingFrequency = requiredId))

#' Creates a new Indicator
#' 
#' @export
createIndicator <- function(...) 
  createEntity("Indicator", 
    propertyList(list(...), 
                 activityId = requiredId,
                 name = requiredString, 
                 category = optionalString,
                 listHeader = optionalString,
                 description = optionalString, 
                 units = requiredString,  
                 aggregation = requiredId,
                 sortOrder = requiredId))

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

#' Deletes an attribute group
#' 
#' @export
deleteAttributeGroup <- function(attributeGroupId) 
  invisible(executeCommand("Delete", entityName = "AttributeGroup", id = attributeGroupId))
