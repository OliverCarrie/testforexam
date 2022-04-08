# Perform a first GET request, that searches for event venues in Germany (countryCode = "DE"). 
 # Extract the content from the response object and inspect the resulting list. Describe what you can see.

library(jsonlite)
library(httr)
library(rlist)
library(tidyverse)
library(naniar)

first_request <- GET(url = "https://app.ticketmaster.com/discovery/v2/venues?apikey=7elxdku9GGG5k8j0Xm8KWdANDgecHMV0&locale=*&countryCode=DE")
content_request <- content(first_request)
content_request$page

event_DE <- jsonlite::fromJSON(content(first_request, as = "text"))
venue <- flatten(event_DE)
venue <- as.data.frame(venue)
venue <- venue %>%
  select(venues.name,
         venues.city,
         venues.postalCode,
         venues.address,
         venues.url,
         venues.location)
venue <- venue %>%
  unnest(venues.city, venues.address, venues.location)
venue <- venue %>%
  rename(
    name = venues.name,
    city = name,
    postalCode = venues.postalCode,
    address = line1,
    url = venues.url
  )
venue$longitude <- as.double(venue$longitude)
venue$latitude <- as.double(venue$latitude)
glimpse(venue)








n <- content_request$page$totalElements
entries_per_page <- 20
pages <- floor(n/entries_per_page)
remainder <- n - entries_per_page *floor(n/entries_per_page)

venue_data <- tibble(
  name = character(n),
  city = character(n),
  postalCode = character(n),
  address = character(n),
  url = character(n),
  longitude = double(n),
  latitude = double(n)
)

for (i in 1:pages) {
  first_request <- GET(url = "https://app.ticketmaster.com/discovery/v2/venues?apikey=7elxdku9GGG5k8j0Xm8KWdANDgecHMV0&locale=*&countryCode=DE")
  content_request <- content(first_request)
  
  venue_data <- list
}
