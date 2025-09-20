setwd("C:/Users/emili/Desktop/Better_meteo_data/data_cut")

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

dir()[35]
files <- list.files(pattern = "\\.csv$")

data <- data.table::fread(dir()[35])
head(data)

nrow <- nrow(data)
nrow

nrow_df <- data.frame(file = character(),
                      rows = integer(),
                      group = character(),
                      stringsAsFactors = FALSE)

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