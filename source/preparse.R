# Pre-Parse the Murder Addresses

library(postmastr)

murders <- censusxy::stl_homicides

murders <- pm_identify(murders, street_address)
  
pm_prep(murders, var = street_address, type = 'street') %>%
  pm_house_parse() %>%
  pm_streetDir_parse() %>%
  pm_streetSuf_parse() %>%
  pm_street_parse() -> parsed

parsed$city <- 'St. Louis'
parsed$state <- 'MO'

# Rebuild the address column
murders <- dplyr::left_join(murders, parsed)

# replacing NAs with Blank for Paste...
murders[is.na(murders)] <- ""

murders <- 
  dplyr::mutate(murders,
         preParsed = stringr::str_c(
         pm.house,
         pm.preDir,
         pm.street,
         pm.streetSuf,
         sep = ' ') %>% 
         # have to get rid of double spaces
         gsub(pattern = '\\s{2}', replacement = ' ') %>% 
         # and end of string space
         gsub(pattern = '\\s$', replacement = ''))

# All but 46 Match the Original
table(
  murders$preParsed == censusxy::stl_homicides$street_address, useNA = 'always'
)
