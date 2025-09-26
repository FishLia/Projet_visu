fluidPage(
  
  ## --- Titre avec logo ---
  #   -> placer un fichier logo.png dans le dossier www/
  titlePanel(
    title = div(
      img(
        src   = "c072d427-b77c-4672-a337-b63adc292287.png",
        height = "40px",
        style  = "margin-right:10px;"
      )
      ,
      "Visualisation Météo Interactive"
    )
  ),
  # image de fond 
  tags$head(
    tags$style(
      HTML("
        body {
          background-image: url('4141314-fond-ciel-bleu-air-clair-fond-ciel-illustrationle-vectoriel.jpg');
          background-size: cover;       #l'image couvre tout l'écran
          background-repeat: no-repeat; #pas de répétition
          background-attachment: fixed; #reste fixe quand on scrolle
          background-position: center;  #centrage
        }
      ")
    )
  ),
  
  ## --- Onglets ---
  tabsetPanel(
    
    # Onglet Carte
    tabPanel("Carte de la France",
             sidebarLayout(
               sidebarPanel(
                 radioButtons("map_variable", "Sélectionner une variable météo :",
                              choices = c("Pluviométrie", "Vent", "Ensoleillement", "Température"),
                              selected = "Pluviométrie"),
                 selectInput("map_year", "Choisir une année :",
                             choices = 2000:2025,
                             selected = 2020),
                 sliderInput("map_month", "Choisir un mois :",
                             min = 1, max = 12, value = 1,
                             step = 1, ticks = TRUE)
               ),
               mainPanel(
                 h4("Carte interactive de la France"),
                 plotOutput("map_plot", height = "500px")
               )
             )
    ),
    
    # Onglet Analyses
    tabPanel("Analyses graphiques",
             sidebarLayout(
               sidebarPanel(
                 radioButtons("graph_variable", "Sélectionner une variable météo :",
                              choices = c("Pluviométrie", "Vent", "Ensoleillement", "Température"),
                              selected = "Pluviométrie")
               ),
               mainPanel(
                 h4("Graphiques comparatifs"),
                 plotOutput("graph_plot", height = "500px")
               )
             )
    )
  )
)

