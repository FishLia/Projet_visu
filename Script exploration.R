require(tidyverse)
library(ggcorrplot)
library(FactoMineR)
library(Factoshiny)

dep_01_init <- read.table("C:/Users/augus/OneDrive/Documents/Cours/ACO/M2/Visualisation/Projet/recent_files/MENS_departement_01_periode_1950-2023.csv", header = TRUE, sep = ",")

dep_01_init$AAAAMM <- as.factor(dep_01_init$AAAAMM)

row_class <- sapply(X=dep_01_init, FUN = class)
subset_col <- names(row_class)[row_class == "integer" | row_class == "numeric"]
subset_col <- subset_col[!subset_col %in% c("year", "month")]


dep_01 <- dep_01_init %>%
  group_by(year, month, AAAAMM) %>%
  summarise(across(all_of(subset_col), mean, na.rm = T))

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
plot_corrmat <- ggcorrplot(cor_mat,lab = T, lab_size = 3)
plot_corrmat

dfcompleted <- missMDA::imputePCA(dep_01, ncp=2,quali.sup=c(3,15))$completeObs
res.PCA<-PCA(dfcompleted,quali.sup=c(3,15),graph=FALSE)
plot.PCA(res.PCA,choix='var',title="Graphe des variables de l'ACP")
plot.PCA(res.PCA,invisible=c('quali','ind.sup'),habillage='year',title="Graphe des individus de l'ACP",label ='none')


