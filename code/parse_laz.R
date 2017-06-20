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

lidar_in <- readLAS("data/2013_SJER_1_252000_4103000_colorized.laz")

lidar_data <- lidar_in@data

min_x = min(lidar_data$X)
max_x = max(lidar_data$X)
min_y = min(lidar_data$Y)
max_y = max(lidar_data$Y)

lidar_data[lidar_data$X == 252821]

diff(range(lidar_data$X))
diff(range(lidar_data$Y))
diff(range(lidar_data$Z))

lidar_binned <- lidar_data %>%
  mutate(X_bins = cut(X, breaks = seq(min(lidar_data$X), 
                                      max(lidar_data$X), 
                                      by = 10))) %>%
  mutate(Y_bins = cut(Y, breaks = seq(min(lidar_data$Y), 
                                      max(lidar_data$Y), 
                                      by = 10))) %>%
  group_by(X_bins, Y_bins) %>%
  summarize(max_Z = max(Z),
            min_Z = min(Z),
            mean_Z = mean(Z, na.rm = TRUE),
            range_Z = diff(range(Z))) %>%
  na.omit() %>%
  ungroup()
  



hist(lidar_data$X)
hist(lidar_data$Y)
hist(lidar_data$Z)

ggplot(lidar_data, aes(x = X_bins, y = Y_bins, color = Z)) +
  geom_density2d()
