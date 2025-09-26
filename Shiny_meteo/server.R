# app.R  ----
library(shiny)

function(input, output, session) {
  
  # 1. Carte
  output$map_plot <- renderPlot({
    plot(
      1, 1,
      main = paste("Carte :", input$map_variable,
                   "-", input$map_year,
                   "-", month.name[input$map_month])
    )
  })
  
  # 2. Graphique comparatif
  output$graph_plot <- renderPlot({
    plot(
      1:10, rnorm(10),
      type = "b", col = "pink",
      main = paste("Analyse :", input$graph_variable),
      xlab = "Exemple X", ylab = "Exemple Y"
    )
  })
}

