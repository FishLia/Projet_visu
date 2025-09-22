#### création du jeu de donnée France

library(dplyr)
library(purrr)
library(readr)  # plus sûr que read.table
library(lubridate)

# Dossier où se trouvent tes fichiers
data_path <- "C:/Users/augus/OneDrive/Documents/Cours/ACO/M2/Visualisation/Projet/recent_files/"

# Liste tous les fichiers CSV qui commencent par "MENS_departement"
files <- list.files(path = data_path, pattern = "^MENS_departement.*\\.csv$", full.names = TRUE)

# Fonction qui traite un seul fichier
process_file <- function(file) {
  print(file)
  dep_init <- read_csv(file, show_col_types = FALSE)
  
  dep_init$AAAAMM <- as.factor(dep_init$AAAAMM)
  
  row_class <- sapply(dep_init, class)
  subset_col <- names(row_class)[row_class %in% c("integer", "numeric")]
  subset_col <- subset_col[!subset_col %in% c("year", "month")]
  
  dep <- dep_init %>%
    group_by(year, month, AAAAMM) %>%
    summarise(across(all_of(subset_col), mean, na.rm = TRUE), .groups = "drop")
  
  dep$date <- as.Date(paste(dep$year, dep$month, "01", sep = "-"))
  return(dep)
}

# Appliquer la fonction à tous les fichiers et stocker les résultats dans une liste
dep_list <- map(files, process_file)

# Option 1 : conserver une liste (chaque élément = un département)
names(dep_list) <- gsub("^.*MENS_departement_|_periode.*$", "", files)

# Option 2 : combiner tous les départements dans un seul data.frame
dep_all <- bind_rows(dep_list, .id = "departement")
