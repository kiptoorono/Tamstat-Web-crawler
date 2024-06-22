# Load necessary packages
rm(list = ls(all = TRUE)) # Clear R Global Environment

library(raster)
library(sf)
library(ncdf4)
library(ggplot2) # for general plotting

#------------file paths and Directory-----------------------------------------------
ARC_path <- 'E:/R/Tamstat_data'

#------------Polygons/Shapefiles----------------------------------------------------
Location_Shapefile <- st_read("E:/R/gadm41_KEN_shp/gadm41_KEN_3.shp")

# Plot the shapefile
plot(st_geometry(Location_Shapefile))

#------------Recursive Function to Find .nc Files-----------------------------------
find_nc_files <- function(dir) {
  list.files(dir, full.names = TRUE, recursive = TRUE, pattern = "\\.nc$")
}

all_nc <- find_nc_files(ARC_path)
print(all_nc)

# Check if the directory exists
if (file.exists(ARC_path)) {
  print("file path exists")
} else {
  stop("file path does not exist")
}

# Check if Nc files have been added to all_nc
if (length(all_nc) == 0) {
  stop("No .nc files found in the directory ")
}

# Function to inspect NetCDF file structure
inspect_nc_file <- function(nc_file) {
  nc <- nc_open(nc_file)
  print(nc)
  nc_close(nc)
}

# Inspect the structure of each NetCDF file
lapply(all_nc, inspect_nc_file)

# Load all .nc files into a RasterStack
ARC_stack <- stack(all_nc)
print(ARC_stack)

# Check the structure of the raster stack
print(names(ARC_stack))
print(nlayers(ARC_stack))

# Extract raster stack data and write it out to a CSV
tryCatch({
  v <- extract(ARC_stack, Location_Shapefile, fun = mean, df = TRUE)
  output <- data.frame(v)

  # Create a .csv of mean Monthly Rainfall values being sure to give a descriptive name
  write.csv(output, file = "E:/R/Tamsat_soilmoisture_data.csv")
  print("Data extraction and CSV writing completed successfully.")
}, error = function(e) {
  print(paste("Error during extraction or CSV writing:", e$message))
})

# Print completion message
print("Script completed.")
