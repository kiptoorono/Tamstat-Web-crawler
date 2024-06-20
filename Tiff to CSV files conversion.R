# load packages

rm(list=ls(all=TRUE))   # Clear R Global Environment

library(raster)
library(rgdal)
library(shapefiles)
library(ggplot2)   # for general plotting
library(ggmap)     # for fortifying shapefiles

#------------file paths and Directory-----------------------------------------------

ARC_path <- "E:/R/Tamstat_data"

#------------Polygons/Shapefiles----------------------------------------------------

Location_Shapefile <- readOGR(dsn = "E:/R/gadm41_KEN_shp")
#Visualize the shapefile
#crs(Location_Shapefile) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

plot(Location_Shapefile)

#------------RasterPath and Directory------------------------------------------------

# Assign path to object = cleaner code
all_ARC <- list.files(ARC_path,
                      full.names = TRUE,
                      pattern = ".tif$")
# View list - note the full path, relative to our working directory, is included

all_ARC

#------------RasterStacking/Brick---------------------------------------------------

# Create a raster stack of the CHIRPS time series
ARC_stack <- stack(all_ARC)
ARC_stack

#crs(ARC_stack) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
#------------Extract raster stack data and write it out to a csv--------------------------------------------------------
v <- extract(ARC_stack, Location_Shapefile, fun = mean)
output = data.frame(v)
#print(output)

# Create a .csv of mean Monthly Rainfall values being sure to give descriptive name
# write.csv(DateFrameName, file="NewFileName")
write.csv(output, file="Mayfair_Chirps.csv")
#-------------------------------------------------------------------------------------------------------------------------
