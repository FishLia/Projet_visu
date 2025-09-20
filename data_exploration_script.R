setwd("C:/Users/emili/Desktop/Better_meteo_data/data_cut/recent_files")

library(ggplot2)
library(tidyverse)
library(flextable)
library(patchwork)
library(RColorBrewer)
library(viridis)
library(dplyr)
library(lubridate)
library(stringr)
library(zoo)
library(rlang)

dir()
files <- list.files(pattern = "\\.csv$")

data <- data.table::fread(dir()[35])
head(data)

nrow <- nrow(data)
nrow

nrow_df <- data.frame(file = character(),
                      rows = integer(),
                      group = character(),
                      stringsAsFactors = FALSE)

### not useful anymore cause i put separate folders
for (f in files) {
  message("Processing: ", f)

  dat <- data.table::fread(f)
  nb_rows <- nrow(dat)

  if (str_detect(f, "1949")) {
    grp <- "old"
  } else if (str_detect(f, "2023")) {
    grp <- "recent"
  } else if (str_detect(f, "2024")) {
    grp <- "very_recent"
  }

  nrow_df <- rbind(nrow_df, data.frame(file = f, rows = nb_rows, group = grp))

  rm(dat)
  gc()
}
nrow_df

nrow_df %>% ggplot() +
  aes(x = reorder(file, rows), y = rows, fill = group) +
  geom_col() +
  labs(x = "Files",
       y = "Number of rows",
       fill = "Group",
       title = "Number of rows per file, colored by group") +
  theme(axis.text.x = element_blank(),
        axis.ticks.x=element_blank(),
        title = element_text(size = 20),
        axis.title = element_text(size = 14, face = "bold"),
        legend.text = element_text(size = 14))



for (f in files) {
  message("Processing: ", f)
  dat <- data.table::fread(f)

  file_id <- substr(f, start = 17, stop = 20)

  rr_year <- dat %>% summarise(mean_RR = mean(RR), .by = (year))
  tm_year <- dat %>% summarise(mean_RR = mean(TM), .by = (year))
  tx_year <- dat %>% summarise(mean_RR = mean(TX), .by = (year))

  var_year <- rr_year %>%
    left_join(tm_year, by = "year") %>%
    left_join(tx_year, by = "year") %>%
    mutate(file = file_id)

  var_region <- bind_rows(var_region, var_year)

  rm(dat)
  gc()
}

var_region <- data.frame()
for (f in files) {
  message("Processing: ", f)
  dat <- data.table::fread(f)

  file_id <- substr(f, start = 17, stop = 20)

  var_year <- dat %>%
    group_by(year) %>%
    summarise(
      mean_RR = mean(RR, na.rm = TRUE),
      mean_TM = mean(TM, na.rm = TRUE),
      mean_TX = mean(TX, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    mutate(region = file_id)

  var_region <- bind_rows(var_region, var_year)

  rm(dat)
  gc()
}
colnames(var_region)
head(var_region)
nrow(var_region)
unique(var_region$region)



var_region %>%
  ggplot() +
  aes(x = year) +
  geom_histogram()
#  geom_line(x = year, y = rr_year, color = rr_year) +
#  geom_point(x = year, y = tm_year, color = tm_year) +
#  geom_point(x = year, y = tx_year, color = tx_year)

## "mean_RR" "mean_TM" "mean_TX"

plotting_per_region <- function(reg) {
  var_region %>%
    filter(region == reg) %>%
    pivot_longer(cols = c(mean_RR, mean_TM, mean_TX),
                 names_to = "variable",
                 values_to = "value") %>%
    ggplot(aes(x = year, y = value, color = variable)) +
    geom_point() +
    geom_line() +
    labs(x = "Année",
         y = "Valeur",
         color = "Variable",
         title = paste0("Evolution de RR, TM, TX pour la région ", reg))
}
plotting_per_region("_01_")