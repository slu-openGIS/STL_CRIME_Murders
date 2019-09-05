## BROKEN DUE TO CHANGES IN https://www.slmpd.org/Crimereports.shtml

# Make Homicide Dataset
library(compstatr)

# Creat e Index of Available Data

idx <- cs_create_index()
crime_dta <- vector("list", 11)

# get all years
for (i in 1:11) {
  crime_dta[[i]] <- cs_get_data(year = (2008:2018)[i], index = idx)  
}

# fix the outliers
# 1-5 all 18s
for (i in 1:5) {
  crime_dta[[i]] <- cs_standardize(crime_dta[[i]], all, config = 18)
}

# 6 Jan - May July Aug 18s # Jun Sep-Dec 20
crime_dta[[6]][["January"]]  <- cs_standardize(crime_dta[[6]], "January", config = 18)$January
crime_dta[[6]][["February"]] <- cs_standardize(crime_dta[[6]], "February", config = 18)$February
crime_dta[[6]][["March"]]    <- cs_standardize(crime_dta[[6]], "March", config = 18)$March
crime_dta[[6]][["April"]]    <- cs_standardize(crime_dta[[6]], "April", config = 18)$April
crime_dta[[6]][["May"]]      <- cs_standardize(crime_dta[[6]], "May", config = 18)$May
crime_dta[[6]][["July"]]     <- cs_standardize(crime_dta[[6]], "July", config = 18)$July
crime_dta[[6]][["August"]]   <- cs_standardize(crime_dta[[6]], "August", config = 18)$August

# 10, May 26
crime_dta[[10]][["May"]] <- cs_standardize(crime_dta[[10]], "May", config = 26)$May

# build full dataset
crimes08_18 <- dplyr::bind_rows(crime_dta[[1]], crime_dta[[2]], crime_dta[[3]],
                                crime_dta[[4]], crime_dta[[5]], crime_dta[[6]],
                                crime_dta[[7]], crime_dta[[8]], crime_dta[[9]],
                                crime_dta[[10]], crime_dta[[11]])

homicides08_18 <- dplyr::filter(crimes08_18, as.numeric(crime) == 10000)

