# Script to parse laz LiDAR files and calculate summary stats for different
# grid sizes
# Naupaka Zimmerman
# June 20, 2017 naupaka@gmail.com

# Load packages and install if needed
if (!require("lidR")) {
  install.packages("lidR")
  install.packages("devtools")
  devtools::install_github("Jean-Romain/rlas", dependencies = TRUE)
  library("lidR")
}

if (!require("ggplot2")) {
  install.packages("ggplot2")
  library("ggplot2")
}

if (!require("dplyr")) {
  install.packages("dplyr")
  library("dplyr")
}

lidar_in <- readLAS("data/2013_SJER_1_256000_4112000_colorized.laz")
plot(lidar_in)

hmean <- lidar_in %>% grid_metrics(entropy(Z), res = 10)
plot(hmean)
