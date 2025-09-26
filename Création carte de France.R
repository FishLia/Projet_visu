rm(list = ls())

library(ggplot2)
library(plotly)
library(maps)
library(tidyverse)
france <- map_data("france")
ggplot(france, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "grey30", colour = "white")


carte_1 <- dep_all %>% filter(year == 1980 & month == 01) %>% 
  right_join(france, by = "region") %>%
  ggplot() +
  aes(x = long, y = lat, group = region) +
  geom_polygon(aes(fill = TM), color = "black")+
  scale_fill_gradient2(low = "darkgreen", mid ="yellow",  high = "red")
  

carte_1

dep_all[,"group"] %>% group_by(group)

table(dep_all$group)
table(france$group)

dep_all %>% filter(year == 2000 & month == 01) %>% 
  ggplot() +
  aes(x = group, y = TM) +
  geom_point()

table(france$group, france$region)
