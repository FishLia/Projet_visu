require(tidyverse)


dep_01_init <- read.table("C:/Users/augus/OneDrive/Documents/Cours/ACO/M2/Visualisation/Projet/recent_files/MENS_departement_01_periode_1950-2023.csv", header = TRUE, sep = ",")



print(head(arrange(dep_01, AAAAMM)))
dep_01_init$AAAAMM <- as.factor(dep_01_init$AAAAMM)


row_class <- sapply(X=dep_01_init, FUN = class)
subset_col <- names(row_class)[row_class == "integer" | row_class == "numeric"]
subset_col <- subset_col[-c(4,5)]


dep_01 <- dep_01_init %>%
  group_by(year, month, AAAAMM) %>%
  summarise(across(all_of(subset_col), mean, na.rm = T))


summary(dep_01)
dep_01$AAAAMM <- as.Date(as.character(dep_01$AAAAMM), "%b.%Y")
class(dep_01$AAAAMM)

dep_01 %>% ggplot()+
  aes(x = AAAAMM, y = )



