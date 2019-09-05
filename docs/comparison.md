Translating Addresses Into Geographic Data: An Overview of Geocoding
Tools and Resources
================

#### Abstract

Geocoding, the process of turning a postal address into geographic
coordinates, is becoming increasingly relevant as more of this data is
collected. Although this practice is necessary for a large proportion of
spatial analyses, there is a dearth of literature investigating the
sources, cost, speed and accuracy of geocoding tools. We compare and
evaluate several open source and commercial options. The construction of
geocoding tools is explored.

## Introduction

## Background

The process of translating qualitative information such as postal
addresses into geographic data is known as geocoding. This process is
imperative for the spatial analysis of many data. Increasingly, both
public and private sector endeavors are collecting more of this
information from partners and consumers. Because of this trend, there is
an increasing dependency on geocoding.

### Supplemental Techonologies

  - Spatial Indexing
  - Natural Language Processing
  - Place Name and Points-Of-Interest
  - Street Interpolation
  - Building/Parcel Centroid
  - Data Matching (Geocodio)
  - Partial Address Matching and Spelling Correction
  - Spreadsheet Upload

## Data

## Methodology

## Procedure

## The Geocoders

### Commercial Options

There are several commercial options we will be reviewing here.

  - Google Maps
  - Using the ggmap library, version 3.0.0
  - Geocodio
  - Using the ‘hrbrmstr/rgeocodio’ github repo.
  - OpenCage
  - Using the opencage library, version

### Open Source Options

  - Nomanatim (OpenStreetMap)
  - The US Census Bureau
  - They maintain the most up to date address data by way of the postal
    service… ?
  - Pelias
  - Not tested here, unless want to docker setup…

### What is a Composite geocoder?

Some companies, such as Google, collect vast quantities of their own
data pertaining to the geolocation of addresses. Many companies also
purchase data from a whole industry of geospatial data companies
(Garmin, HERE, TomTom to name a few). In many of these scenarios, the
data is stored in company owned databases, and queries are compared to
the available data. As is the case in many open source programs, the
data is not centrally available or collected. The solution is a
composite geocoder that aggregates data in order to provide greater
coverage or more accurate geocoding. Some solutions, like OpenCage

The most common speed advantge is proposed by spatial indexing. That is,
if you search an American address with a 5-digit zip code, the number of
possible addresses is reduced significantly.

### Other Types of Geocoding

Outside of traditional methods of comparing addresses to known
locations, street interpolation is a common practice, which works by
approximating a point along a line segment distant proportionally from
known addresses to the approximate point. (provide a graphic) house 10
(known) —– house 15 (approximate) —– —– house 25 (known)

In the internet age, there is also a desire to locate internet
happenings on a map. Internet Protocol (IP) Address geolocation is
available, although less open and less accurate than street address
geolocation. It is also far more prone to tampering.

Several companies have also created spatial indexing systems in recent
years. Google for example, has created the plus.codes concept. In this
system, a plus code (an alphanumeric string) contains information about
the location of a ?(1x1m) grid. These systems are purported to be an
advantage in regions that lack standardized address systems.Other
companies, what3words, qalocate achieve the same thing. Their obvious
limitation is exact specificity, but they offer the advantages of an
open standard for locating things and the potential for much faster
spatial indexing.

### Advantages of Local Geocoding

Given the complexity of geocoding, particularly in processing large
quantities of data, it is often disadvantageous to replicate a geocoding
procedure on your own. However, some concerns may need to be addressed.
For data that must remain secure, local geocoding is desirable. Notably,
geocodio advetises HIPPA-compliant geocoding, but individuals will have
to evaluate their data and risks. Additionally, reproducibility cannot
be guranteed with online services. In applications that require very
rapid or numerous geocodes, the individual situation must be assessed.
For large data, compute is typically more burdensome than network
traffic. Applications that do not have access to reliable internet or
that process critical data may benefit from onsite geocoding.

Natural Area Codes also exist in concept, but lack any real
implementation. They represent latitude longitude coordinates using a
base 30 alphanumeric representation.

### A word on zipcodes

Zipcodes, also known as postal codes, are a 5 digit system developed by
the United States Postal Service (USPS). They are an efficient way to
move millions of parcels accross the country on a daily basis. They are
designated in relationship to the location of post offices. Just as
spatial indexes are computationally efficient, zip codes work in a
similar hierarchical sense. The first digit alone will deduce at most 9
possible states (a national area). The subsequent 2 will designate a
sectional center or large city post office, and the final 2 will
determine the associate post office or delivery area. Many zip codes
also contain a 4 digit suffix, further designating a block or building.

Although often used in research, zipcodes are among the weakest
geographic operationalizations available. It is understandable that in
many situations, data are not available at a more granular level in
order to protect individual privacy. However, in any opportunity your
data have more information available than zip codes, they should be used
to geolocate data.

## The Data

As our test data, we will be using the addresses of 1822 homicides that
took place in the City of Saint Louis, MO between 2008 and 2018.

The geocoder we’ve created uses data made publicly available by the City
itself. If one desires to replicate a similar tool,
[openaddresses](https://openaddresses.io/) appears to be the largest
available resource for address data.

## The Procedure

Each Geocoder will be tested 5 times on the same hardware, and times
will be compared.

### Ground Truth

The City of Saint Louis maintains a master address list that can be used
to translate address information into latitude/longitude coordinates. We
will treat the matched addresses using this method as ground truth, from
which we will compare several commercial and open source options.

## Results

### Qualitative Rankings of Geocoders

| Geocoder                    | Quantity Free | Price per 1k\* | Price per Unlimited | Ease of Use | Accuracy | Speed |
| --------------------------- | ------------- | -------------- | ------------------- | ----------- | -------- | ----- |
| Google Maps                 | 40K/Month     | $5.00          | \-                  | High        |          |       |
| HERE                        | 250K/Month    | $1.00          | \-                  | High        |          |       |
| Geocodio                    | 2500/Day      | $0.50          | $750                | High        |          |       |
| OpenCage                    | 2500/Day      | $0.17          | \-                  | High        |          |       |
| CensusXY                    | Unlimited     | \-             | $0                  | Moderate    |          |       |
| Gateway (Composite)         | Unlimited     | \-             | $0                  | Moderate    |          |       |
| Pelias                      | Unlimited     | \-             | $0                  | Difficult   |          |       |
| Nominatim (OpenStreetMap)   | Unlimited     | \-             | $0                  | Difficult   |          |       |
| TomTom                      | 2500/Day      | $3.98          | \-                  | High        |          |       |
| Geobuffer (Social Explorer) | 50K/Trial     | $0.18          | \-                  | High        |          |       |
| Esri ArcGIS                 | 1M/Month      | $4.00          | \-                  | High        |          |       |

\* Prices are estimated as of 8/25/19.

Many companies offer specific terms and pricing subject to the use and
quantity of geocodes.

### Speed of Geocoding

### Accuracy

Accuracy is measured both in the number of successful geocodes relative
to the master addres list, and in the average difference of distance
from the master address list. Small variations in accuracy may exist due
to different methods of locating point (parcel centroid vs building
footprint centroid for example), but large variations are indicative of
erroneous matching.

### Features and Ease of Use

It is not entirely fair to compare this assortment of geocoding tools
without differentiating the features and ease of use. Services like
Google Maps, for example, offer the simplest interface with
considerations meant for increased usability.

Natural language processing, for example, is used in many of these
tools. It allows for the user to input single character inputs
representing an address. Whereas, some of the options presented require
that addresses be neatly parsed into components. Open source options do
exist, such as `libpostal` and non-NLP methods such as those in the R
package `postmastr` do exist.

## Limitations

Obtaining objective measures of speed concerning programs is difficult
due to numerous variations in hardware, operating systems and network
speed. However, we can confidently state that limitations in local
geocoding are due to limitations in compute power, while APIs such as
that offered by the Census Bureau or Google Maps are restricted due to
network speed, server hardware and imposed limitations (Rate or quantity
limits, for example).

We did not test the geocoding of points of interest, but third-party
services are typically much better at processing these queries than open
source options.

## Conclusion

In applications that require high reliability, reproducbility, scalable
thoroughput and high data privacy, local geocoding should be considered.
For most applications, however, using a third-party service offers more
simplicity and adequate speed for most use-cases.

In our testing, \_\_\_\_\_ appeared to have the highest accuracy
combined with the quickest speed. However, this performance comes at a
price…

### Conflicts of Interest

The authors report no conflicts of interest in this research.
