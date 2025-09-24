rm(list = ls())

library(ggplot2)
library(plotly)
library(maps)
france <- map_data("france")
ggplot(france, aes(x=long, y=lat, group = group)) +   
  geom_polygon(fill="grey30", colour="white") 
