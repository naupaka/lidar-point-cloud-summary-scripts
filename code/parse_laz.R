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
plot(lidar_in)

lidar_data <- lidar_in@data

min_x = min(lidar_data$X)
max_x = max(lidar_data$X)
min_y = min(lidar_data$Y)
max_y = max(lidar_data$Y)

lidar_data[lidar_data$X == 252821]

diff(range(lidar_data$X))
diff(range(lidar_data$Y))
diff(range(lidar_data$Z))


all_data <- matrix(NA, 0, 9)
for (bin_sizes in seq(5, 100, by = 5)) {
  my_lidar_binned <- lidar_data %>%
    mutate(X_bins = cut(X, breaks = seq(min(lidar_data$X), 
                                        max(lidar_data$X), 
                                        by = bin_sizes))) %>%
    mutate(Y_bins = cut(Y, breaks = seq(min(lidar_data$Y), 
                                        max(lidar_data$Y), 
                                        by = bin_sizes))) %>%
    group_by(X_bins, Y_bins) %>%
    summarize(max_Z = max(Z),
              min_Z = min(Z),
              mean_Z = mean(Z, na.rm = TRUE),
              range_Z = diff(range(Z)),
              count_Z = n(),
              sd_Z = sd(Z)) %>%
    na.omit() %>%
    mutate(bin_size = bin_sizes)
  my_lidar_binned <- as.matrix(my_lidar_binned)
  all_data <- rbind(all_data, my_lidar_binned)
} 
all_data <- as.data.frame(all_data)

all_data %>%
  group_by(bin_size) %>%
  summarize(avg_mean_Z = mean(as.numeric(as.character(mean_Z)), na.rm = TRUE),
            avg_min_Z = mean(as.numeric(as.character(min_Z))),
            avg_max_Z = mean(as.numeric(as.character(max_Z))),
            avg_range_Z = mean(as.numeric(as.character(range_Z))),
            avg_sd_Z = mean(as.numeric(as.character(sd_Z))),
            avg_count_Z = mean(as.numeric(as.character(count_Z, na.rm = TRUE)))) %>%
  arrange(as.numeric(as.character(bin_size)))
