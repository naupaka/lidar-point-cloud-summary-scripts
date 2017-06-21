# Script to parse laz LiDAR files and calculate summary stats for different
# grid sizes
# Naupaka Zimmerman
# June 20, 2017 naupaka@gmail.com

# Load packages and install if needed
if (!require("lidR")) {
  install.packages("lidR")
  install.packages("devtools")
  devtools::install_github("Jean-Romain/lidR", dependencies = TRUE)
  devtools::install_github("Jean-Romain/rlas", dependencies = TRUE)
  library("lidR")
}

lidar_in <- readLAS("data/2013_SJER_1_256000_4112000_colorized.laz")
dtm = grid_terrain(lidar_in, res = 5, method = "knnidw")
lasnorm <- lasnormalize(lidar_in, dtm)
lasnorm@data$Z[lasnorm@data$Z < 0] <- 0
normalized_metrics <- lasnorm %>% grid_metrics(.stdmetrics, res = 1)

plot(lasnorm)

plot(entropy)
