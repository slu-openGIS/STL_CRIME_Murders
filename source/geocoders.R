## Access to Geocoding APIs
library(httr)
library(glue)

# Google Maps
GoogleMaps <- function(address, key){
  # build a query
  url <- utils::URLencode(
    glue::glue('https://maps.googleapis.com/maps/api/geocode/json?address={address}&key={key}')
  )
  
  # send
  response <- httr::GET(url)
  payload  <- httr::content(response)
  
  # error on no results
  if(payload$status == "ZERO_RESULTS"){
    stop('No Matches Found for Specified Address')
  }
  
  # parse response
  lat <- payload$results[[1]]$geometry$location$lat
  lon <- payload$results[[1]]$geometry$location$lng
  
  coords <- list(lat = lat, lon = lon)
  
  return(coords)
}

# HERE
HERE <- function(address, app_id, app_code){
  # build a query
  url <- utils::URLencode(
    glue::glue('https://geocoder.api.here.com/6.2/geocode.json?searchtext={address}&app_id={app_id}&app_code={app_code}&gen=8')
  )
  
  # send
  response <- httr::GET(url)
  payload  <- httr::content(response)
  
  # error on no results
  if(length(payload$Response$View) == 0){
    stop('No Matches Found for Specified Address')
  }
  
  # parse response
  lat <- payload$Response$View[[1]]$Result[[1]]$Location$DisplayPosition$Latitude
  lon <- payload$Response$View[[1]]$Result[[1]]$Location$DisplayPosition$Longitude
    
  coords <- list(lat = lat, lon = lon)
  
  return(coords)
}

# Geocodio
Geocodio <- function(address, key){
  # build a query
  url <- utils::URLencode(
    glue::glue('https://api.geocod.io/v1.3/geocode?q={address}&api_key={key}')
  )
  
  # send
  response <- httr::GET(url)
  payload  <- httr::content(response)
  
  # error on no results
  if(length(payload$results) == 0){
    stop('No Matches Found for Specified Address')
  }
  
  # parse response
  lat <- payload$results[[1]]$location$lat
  lon <- payload$results[[1]]$location$lng
  
  coords <- list(lat = lat, lon = lon)
  
   return(coords)
}

# OpenCage
OpenCage <- function(address, key){
  # build a query
  url <- utils::URLencode(
    glue::glue('https://api.opencagedata.com/geocode/v1/json?key={key}&q={address}&pretty=1')
  )
  
  # send
  response <- httr::GET(url)
  payload  <- httr::content(response)
  
  # error on no results
  if(length(payload$results) == 0){
    stop('No Matches Found for Specified Address')
  }
  
  # parse response
  lat <- payload$results[[1]]$geometry$lat
  lon <- payload$results[[1]]$geometry$lng
  
  coords <- list(lat = lat, lon = lon)
  
  return(coords)
}

# TomTom
TomTom <- function(address, key){
  # build a query
  url <- utils::URLencode(
    glue::glue('https://api.tomtom.com/search/2/geocode/{address}.json?key={key}')
  )
  
  # send
  response <- httr::GET(url)
  payload  <- httr::content(response)
  
  # error on no results
  if(payload$summary$numResults == 0){
    stop('No Matches Found for Specified Address')
  }
  
  # parse response
  lat <- payload$results[[1]]$position$lat
  lon <- payload$results[[1]]$position$lon
  
  coords <- list(lat = lat, lon = lon)
  
  return(coords)
}

# Esri
ArcMap <- function(address, token){
  # build a query
  url <- utils::URLencode(
    glue::glue('https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?f=json&SingleLine={address}&token={token}')
  )
  
  # send
  response <- httr::GET(url)
  payload  <- httr::content(response)
  
  # error on no results
  if(length(payload$candidates) == 0){
    stop('No Matches Found for Specified Address')
  }
  
  # parse response
  lat <- payload$candidates[[1]]$location$y
  lon <- payload$candidates[[1]]$location$x
  
  coords <- list(lat = lat, lon = lon)
  
  return(coords)
}

# Bing
Bing <- function(address, key){
  # build a query
  url <- utils::URLencode(
    glue::glue('http://dev.virtualearth.net/REST/v1/Locations/US/addressLine={address}?key={key}')
  )
  
  # send
  response <- httr::GET(url)
  payload  <- httr::content(response)
  
  # error on no results
  if(length(payload$resourceSets) == 0){
    stop('No Matches Found for Specified Address')
  }
  
  # parse response
  lat <- payload$resourceSets[[1]]$resources[[1]]$point$coordinates[[1]]
  lon <- payload$resourceSets[[1]]$resources[[1]]$point$coordinates[[2]]
  
  coords <- list(lat = lat, lon = lon)
  
  return(coords)
}

# Census Bureau (Single Line)
CensusBureau <- function(address){
  # build a query
  url <- utils::URLencode(
    glue::glue('https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?address={address}&benchmark=4')
  )
  
  # send
  response <- httr::GET(url)
  payload  <- httr::content(response)
  
  # error on no results
  if(length(payload$result$addressMatches) == 0){
    stop('No Matches Found for Specified Address')
  }
  
  # parse response
  lat <- payload$result$addressMatches[[1]]$coordinates$y
  lon <- payload$result$addressMatches[[1]]$coordinates$x
  
  coords <- list(lat = lat, lon = lon)
  
  return(coords)
}

## Generic Function for Batch Geocoding
batch <- function(addresses, FUN, ...){
  
  # initialize a vector and iterate function
  l <- vector("list", length(addresses))
  for (i in seq_along(l)) {
    l[[i]] <- try({match.fun(FUN)(addresses[i], ...)}, silent = TRUE)
  }
  # replace try-catch (Failures) with NA
  l[sapply(l, function(x) class(x) == 
                                "try-error")] <- NA
  
  return(l)
}





