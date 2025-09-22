require(tidyverse)
library(ggcorrplot)

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

dep_01$date <- paste0(dep_01$year, dep_01$month) 
dep_01$date <- as.Date(paste(dep_01$year, dep_01$month, "01", sep = "-"))


RR_by_year <- dep_01 %>% group_by(year) %>% 
  summarise(moy = mean(RR)) %>% 
  ggplot()+
  aes(x = year, y = moy) + 
  geom_line()

NBJNEIG_by_year <- dep_01 %>% group_by(year) %>% 
  summarise(NBJNEIG = sum(NBJNEIG)) %>% 
  ggplot()+
  aes(x = year, y = NBJNEIG) + 
  geom_line()

NBJNEIG_by_year

TM_by_year <- dep_01 %>% group_by(year) %>% 
  summarise(TM_moy = mean(TM)) %>% 
  ggplot()+
  aes(x = year, y = TM_moy) + 
  geom_point()+
  geom_smooth()

TM_by_year

cor_mat <- cor(dep_01[,-c(3,15)])
ggcorrplot(cor_mat,lab = T, lab_size = 3)

