An Experiment of Geocoders
================

## Introduction

In this experiment, we will geocode the same set of addresses using 8
commercially available options.

## Workflow

Some of the technical stuff is left out of this notebook for the sake of
brevity and reduced complexity. For example, in the `source/` folder you
will find scripts to reproduce the example dataset, define the geocoding
functions, and securely decrypt your API credentials.

First, we’ll import the geocoding functions.

``` r
source("../source/geocoders.R")
```

Next, we’ll decrypt the credential file. To reproduce these results, you
may substitute your own access credentials for each respective geocoder.

``` r
# Decrypt
#source("../source/Decrypt_creds.R")
# Import
creds <- yaml::read_yaml("../creds/credentials.yaml")
```

We’ll then load the premade dataset, housed in the `censusxy` package.
We need to briefly manipulate it into a single column data.frame. We use
`dplyr` to handle this. We also remove absolute duplicates, which would
exagerate the impact of single addresses.

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following object is masked from 'package:glue':
    ## 
    ##     collapse

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
homicides <- censusxy::stl_homicides %>%
  transmute(address = paste(street_address, city, state)) %>%
  filter(!duplicated(address))
```

## Geocoding

Now, we will geocode the same set of addresses using 8 different web
services. The results are stored in lists.

``` r
address <- homicides$address[1:25] #SMALL

arcmap   <- batch(address, ArcMap, creds$Esri)
bing     <- batch(address, Bing, creds$Bing)
census   <- batch(address, CensusBureau)
geocodio <- batch(address, Geocodio, creds$Geocodio)
google   <- batch(address, GoogleMaps, creds$`Google Maps`)
here     <- batch(address, HERE, creds$HERE$`App ID`, creds$HERE$`App Code`)
opencage <- batch(address, OpenCage, creds$OpenCage)
tomtom   <- batch(address, TomTom, creds$TomTom)
```

We must manipulate these results into something more manageable. So, we
create a dataframe with columns by provider, with each row containing a
matrix with the geocoded coordinates.

``` r
homicides <- homicides[1:25,] #SMALL
homicides$arcmap   <- t(sapply(arcmap, unlist))
homicides$bing     <- t(sapply(bing, unlist))
homicides$census   <- t(sapply(census, unlist))
homicides$geocodio <- t(sapply(geocodio, unlist))
homicides$google   <- t(sapply(google, unlist))
homicides$here     <- t(sapply(here, unlist))
homicides$opencage <- t(sapply(opencage, unlist))
homicides$tomtom   <- t(sapply(tomtom, unlist))
```

## Comparison (THE CODE STARTS TO GET UGLY FROM HERE\!)

First we’ll evaluate the total match rate:

``` r
summary(is.na(homicides)) # more human readable way to do this (i can read it for now)
```

    ##   address           lat             lon             lat         
    ##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
    ##  FALSE:25        FALSE:25        FALSE:25        FALSE:25       
    ##     lon             lat             lon             lat         
    ##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
    ##  FALSE:25        FALSE:25        FALSE:25        FALSE:25       
    ##     lon             lat             lon             lat         
    ##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
    ##  FALSE:25        FALSE:25        FALSE:25        FALSE:25       
    ##     lon             lat             lon             lat         
    ##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
    ##  FALSE:25        FALSE:25        FALSE:25        FALSE:25       
    ##     lon         
    ##  Mode :logical  
    ##  FALSE:25

In the sample of the first 10, all had 100% success rates

Next, we’ll compare the distances. We’re still establishing groud truth
using a city master address list, but for the moment, we’ll explore the
relative distance by calculating an average center and measuring
deviance.

``` r
# centroid and distance... investigate
# geosphere::centroid())
# Imap::gdist
```

``` r
mean_lat <- function(x) {mean(c(homicides$arcmap[x,"lat"], homicides$bing[x, "lat"],  homicides$census[x, "lat"], homicides$geocodio[x, "lat"], homicides$google[x, "lat"], homicides$here[x, "lat"], homicides$opencage[x, "lat"], homicides$tomtom[x, "lat"]))}

mean_lon <- function(x) {mean(c(homicides$arcmap[x,"lon"], homicides$bing[x, "lon"],  homicides$census[x, "lon"], homicides$geocodio[x, "lon"], homicides$google[x, "lon"], homicides$here[x, "lon"], homicides$opencage[x, "lon"], homicides$tomtom[x, "lon"]))}

mean_lat_list <- vector("numeric", 25)
mean_lon_list <- vector("numeric", 25)

for (i in 1:25) {
  mean_lat_list[i] <- mean_lat(i)
  mean_lon_list[i] <- mean_lon(i)
}


for (j in c("arcmap", "bing", "census", "geocodio", "google", "here", "opencage", "tomtom")) {
  l <- vector("numeric", 25)
  for (i in 1:25) {
    l[i] <- Imap::gdist(lon.1 = homicides[[j]][i,"lon"],
            lat.1 = homicides[[j]][i,"lat"],
            lon.2 = mean_lon_list[i],
            lat.2 = mean_lat_list[i], units = "m")
  }
  homicides[[paste0("dist_",j)]] <- l
}

summary(homicides)
```

    ##    address              arcmap.lat           arcmap.lon     
    ##  Length:25          Min.   :38.57364     Min.   :-90.28612  
    ##  Class :character   1st Qu.:38.64179     1st Qu.:-90.27394  
    ##  Mode  :character   Median :38.66670     Median :-90.25007  
    ##                     Mean   :38.65614     Mean   :-90.25052  
    ##                     3rd Qu.:38.67786     3rd Qu.:-90.23578  
    ##                     Max.   :38.71375     Max.   :-90.19744  
    ##       bing.lat             bing.lon      
    ##  Min.   :38.57349     Min.   :-90.28618  
    ##  1st Qu.:38.64169     1st Qu.:-90.27420  
    ##  Median :38.66690     Median :-90.24976  
    ##  Mean   :38.65674     Mean   :-90.25030  
    ##  3rd Qu.:38.67764     3rd Qu.:-90.23551  
    ##  Max.   :38.71382     Max.   :-90.19749  
    ##      census.lat           census.lon     
    ##  Min.   :38.57428     Min.   :-90.28631  
    ##  1st Qu.:38.64189     1st Qu.:-90.27331  
    ##  Median :38.66667     Median :-90.24952  
    ##  Mean   :38.65609     Mean   :-90.25047  
    ##  3rd Qu.:38.67769     3rd Qu.:-90.23574  
    ##  Max.   :38.71365     Max.   :-90.19770  
    ##     geocodio.lat         geocodio.lon    
    ##  Min.   :38.57349     Min.   :-90.28617  
    ##  1st Qu.:38.64058     1st Qu.:-90.27421  
    ##  Median :38.66674     Median :-90.24976  
    ##  Mean   :38.65606     Mean   :-90.25051  
    ##  3rd Qu.:38.67764     3rd Qu.:-90.23551  
    ##  Max.   :38.71382     Max.   :-90.19776  
    ##      google.lat           google.lon     
    ##  Min.   :38.57351     Min.   :-90.28614  
    ##  1st Qu.:38.64166     1st Qu.:-90.27424  
    ##  Median :38.66706     Median :-90.24981  
    ##  Mean   :38.65607     Mean   :-90.25045  
    ##  3rd Qu.:38.67771     3rd Qu.:-90.23572  
    ##  Max.   :38.71382     Max.   :-90.19751  
    ##       here.lat             here.lon      
    ##  Min.   :38.57349     Min.   :-90.28618  
    ##  1st Qu.:38.64174     1st Qu.:-90.27420  
    ##  Median :38.66683     Median :-90.24976  
    ##  Mean   :38.65611     Mean   :-90.25052  
    ##  3rd Qu.:38.67764     3rd Qu.:-90.23551  
    ##  Max.   :38.71382     Max.   :-90.19754  
    ##     opencage.lat         opencage.lon    
    ##  Min.   :38.57426     Min.   :-90.28627  
    ##  1st Qu.:38.64183     1st Qu.:-90.27337  
    ##  Median :38.66670     Median :-90.24942  
    ##  Mean   :38.65595     Mean   :-90.25011  
    ##  3rd Qu.:38.67766     3rd Qu.:-90.23568  
    ##  Max.   :38.71373     Max.   :-90.19775  
    ##      tomtom.lat           tomtom.lon       dist_arcmap     
    ##  Min.   :38.57349     Min.   :-90.29828   Min.   :  13.08  
    ##  1st Qu.:38.63163     1st Qu.:-90.27412   1st Qu.:  17.79  
    ##  Median :38.66626     Median :-90.25177   Median :  22.02  
    ##  Mean   :38.65259     Mean   :-90.25310   Mean   : 104.27  
    ##  3rd Qu.:38.67593     3rd Qu.:-90.23382   3rd Qu.:  67.99  
    ##  Max.   :38.71381     Max.   :-90.20039   Max.   :1255.47  
    ##    dist_bing         dist_census      dist_geocodio      dist_google      
    ##  Min.   :   7.011   Min.   :  16.03   Min.   :   7.18   Min.   :   2.461  
    ##  1st Qu.:  11.194   1st Qu.:  21.81   1st Qu.:  12.04   1st Qu.:  10.421  
    ##  Median :  20.131   Median :  34.86   Median :  18.99   Median :  20.015  
    ##  Mean   : 157.157   Mean   : 114.76   Mean   : 103.79   Mean   : 100.539  
    ##  3rd Qu.:  64.637   3rd Qu.:  68.08   3rd Qu.:  65.65   3rd Qu.:  65.850  
    ##  Max.   :1650.535   Max.   :1237.61   Max.   :1269.94   Max.   :1264.473  
    ##    dist_here        dist_opencage       dist_tomtom      
    ##  Min.   :   6.204   Min.   :   6.857   Min.   :   5.613  
    ##  1st Qu.:  11.194   1st Qu.:  13.554   1st Qu.:  11.122  
    ##  Median :  18.493   Median :  24.560   Median :  22.326  
    ##  Mean   : 100.282   Mean   : 127.338   Mean   : 565.292  
    ##  3rd Qu.:  64.637   3rd Qu.:  67.594   3rd Qu.: 271.735  
    ##  Max.   :1270.033   Max.   :1242.768   Max.   :8810.156
