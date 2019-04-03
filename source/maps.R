library(sf)
library(ggplot2)
library(prener)
library(viridis)
library(tidycensus)

homicides <- filter(allHomicides_gw, is.na(x) == FALSE)
homicides <- st_as_sf(homicides, coords = c("x", "y"), crs = 4269)
homicides <- st_transform(homicides, crs = 26915)

## load other data for mapping
city <- st_read("data/STL_BOUNDARY_City/STL_BOUNDARY_City.shp", stringsAsFactors = FALSE)
highway <- st_read("data/STL_TRANS_PrimaryRoads/STL_TRANS_PrimaryRoads.shp", stringsAsFactors = FALSE)

# create base map
base <- ggplot() + 
  geom_sf(data = city, color = NA, fill = "#ffffff") +
  geom_sf(data = homicides, color = "#ff0000") + 
  geom_sf(data = highway, color = "#000000", size = 1.5, fill = NA) +
  geom_sf(data = city, color = "#000000", size = .75, fill = NA) + 
  labs(
    title = "Homicides, 2008-2018",
    subtitle = "Point Locations"
  ) + 
  cp_sequoiaTheme(background = "transparent", base_size = 24, map = TRUE)

cp_plotSave(filename = "homicide-points.png", plot = base, preset = "lg", dpi = 500)

v15 <- load_variables(2015, "acs5", cache = TRUE)

homcideTract <- gw_aggregate(homicides, to = "tract")
st_geometry(homcideTract) <- NULL

pop <- get_acs(year = 2015, geography = "tract", variables = "B01003_001", state = 29, county = 510, geometry = TRUE, output = "wide")

homicideTract <- left_join(pop, homcideTract, by = "GEOID")
homicideTract <- mutate(homicideTract, perCap = COUNT/B01003_001E*1000)

# create base map
base <- ggplot() + 
  geom_sf(data = city, color = NA, fill = "#ffffff") +
  geom_sf(data = homicideTract, mapping = aes(fill = perCap), color = NA) + 
  geom_sf(data = highway, color = "#ebebeb", size = 1.5, fill = NA) +
  geom_sf(data = city, color = "#000000", size = .75, fill = NA) + 
  scale_fill_viridis(option = "magma", name = "Homcide Rate") + 
  labs(
    title = " ",
    subtitle = "Per 1,000 Residents"
  ) + 
  cp_sequoiaTheme(background = "transparent", base_size = 24, map = TRUE)

cp_plotSave(filename = "homicide-density.png", plot = base, preset = "lg", dpi = 500)

library(areal)
homicideTract <- st_transform(homicideTract, crs = 26915)

wards <- aw_interpolate(ar_stl_wards, tid = WARD, source = homicideTract, sid = GEOID, 
               weight = "sum", output = "sf", extensive = "B01003_001E")

# create base map
base <- ggplot() + 
  geom_sf(data = city, color = NA, fill = "#ffffff") +
  geom_sf(data = homicideTract, mapping = aes(fill = B01003_001E), color = NA) + 
  geom_sf(data = highway, color = "#000000", size = 1.5, fill = NA) +
  geom_sf(data = city, color = "#000000", size = .75, fill = NA) + 
  scale_fill_viridis(option = "cividis", name = "Count") + 
  labs(
    title = "Population Count",
    subtitle = "Per Census Tract"
  ) + 
  cp_sequoiaTheme(background = "transparent", base_size = 24, map = TRUE)

cp_plotSave(filename = "pop-density-tract.png", plot = base, preset = "lg", dpi = 500)

# create base map
base <- ggplot() + 
  geom_sf(data = city, color = NA, fill = "#ffffff") +
  geom_sf(data = wards, mapping = aes(fill = B01003_001E), size = .5, color = "#000000") + 
  geom_sf(data = highway, color = "#000000", size = 1.5, fill = NA) +
  geom_sf(data = city, color = "#000000", size = .75, fill = NA) + 
  scale_fill_viridis(option = "cividis", name = "Count") + 
  labs(
    title = " ",
    subtitle = "Per Ward"
  ) + 
  cp_sequoiaTheme(background = "transparent", base_size = 24, map = TRUE)

cp_plotSave(filename = "pop-density-ward.png", plot = base, preset = "lg", dpi = 500)


