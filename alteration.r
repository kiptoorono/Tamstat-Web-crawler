# Load packages
rm(list=ls(all=TRUE))   # Clear R Global Environment

library(raster)
library(rgdal)
library(shapefiles)
library(ggplot2)   # for general plotting
library(ggmap)     # for fortifying shapefiles

# File paths and Directory
ARC_path <- "E:/R/Tamstat_data"
shapefile_path <- "E:/R/gadm41_KEN_shp"

# Check available layers in the shapefile
layers <- ogrListLayers(shapefile_path)
print(layers)

# Read the specific layer
Location_Shapefile <- readOGR(dsn = shapefile_path, layer = "gadm41_KEN_0")

# Visualize the shapefile
plot(Location_Shapefile)

# RasterPath and Directory
# Assign path to object = cleaner code
all_ARC <- list.files(ARC_path, full.names = TRUE, pattern = ".tif$")

# View list - note the full path, relative to our working directory, is included
print(all_ARC)

if(length(all_ARC) == 0) {
  stop("No .tif files found in the specified directory.")
}

# RasterStacking/Brick
# Create a raster stack of the CHIRPS time series
ARC_stack <- stack(all_ARC)
print(ARC_stack)

# Extract raster stack data and write it out to a csv
v <- extract(ARC_stack, Location_Shapefile, fun = mean)
output = data.frame(v)
print(output)

# Create a .csv of mean Monthly Rainfall values being sure to give descriptive name
write.csv(output, file="Mayfair_Chirps.csv")
