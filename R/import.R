

#' Stages data to import to ActivityInfo 
#' 
#' 
stageImport <- function(text) {
  
  url <- paste(activityInfoRootUrl(), "resources", "imports", "stage", sep = "/")
  
  result <- POST(url, activityInfoAuthentication(), accept_json())
  
  if (result$status_code != 200) {
    stop(sprintf("Request for %s failed with status code %d %s: %s",
                 url, result$status_code, http_status(result$status_code)$message,
                 content(result, as = "text", encoding = "UTF-8")))
  }
  
  response <- fromJSON(content(result, as = "text", encoding = "UTF-8"))
  
  PUT(response$uploadUrl, body = text, encode = "raw")
  
  response$importId
}



