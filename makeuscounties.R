library(tigris)
us_counties <- counties(cb=T, year = 2020)

library(sf)
st_write(us_counties, dsn = "dem_stats/data/us_county10.geojson", driver = "GEOjson")
