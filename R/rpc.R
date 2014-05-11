
#' @export
#' @importFrom httr POST
#' @importFrom rjson fromJSON
executeCommand <- function(type, ...) {
  body <- list( type = type,
                command = list(...))

  
  url <- paste(activityInfoRootUrl(), "command", sep = "/")
  result <- POST(url, body = toJSON(body), authenticate())
  
  
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

deleteActivity <- function(activityId) 
  invisible(executeCommand("Delete", entityName = "Activity", id = activityId))