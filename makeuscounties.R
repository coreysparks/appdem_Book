# Builds the county boundary files used in macro.qmd (R) and pymacro.qmd (Python)
# from the Census Bureau cartographic boundary files via tigris.
library(tigris)
library(sf)
library(dplyr)

us_counties <- counties(cb = TRUE, year = 2020, progress_bar = FALSE) %>%
  # NHGIS-style GISJOIN key so the geometry joins to the NHGIS county tables
  mutate(GISJOIN = paste0("G", STATEFP, "0", COUNTYFP, "0")) %>%
  select(GISJOIN, STATEFP, COUNTYFP, GEOID, NAME, NAMELSAD, ALAND, AWATER) %>%
  st_transform(5070)  # USA Contiguous Albers Equal Area Conic

saveRDS(us_counties, "data/US_county_2020.rds")
st_write(us_counties, "data/US_county_2020.gpkg", delete_dsn = TRUE, quiet = TRUE)
