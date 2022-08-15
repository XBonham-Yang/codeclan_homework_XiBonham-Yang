
library(shiny)
library(tidyverse)
library(bslib)
games <- CodeClanData::game_sales
genre <- unique(games$genre)
# ui ----------------------------------------------------------------------

ui <- fluidPage(
    theme = bs_theme(bootswatch = 'sketchy'),
  
    titlePanel("Game Game Game"),
    fluidRow(
      column(3,
             multiInput(
               inputId = "genre_input", label = "Genre",
               choices = genre
             )),
      column(7,tabsetPanel(
        tabPanel("Sale", plotOutput("sale_output")),
        tabPanel("Score", plotOutput("score_output")))),
      
      
      column(2, tags$img(src = 'nook.png',
                         height=100,width=80)))

)


# server ------------------------------------------------------------------
server <- function(input, output) {
  filtered_data <- reactive({
    games%>%
      filter(genre %in% input$genre_input)
  }) 
  
  output$sale_output <- renderPlot({
    ggplot(filtered_data())+
      aes(x = user_score, y = critic_score)+
      geom_point(aes(colour = genre, size = sales), aplha = 0.5)+
      labs(title = "Public vs Critic",
           x="User Score",
           y = "Critic Score")
  })
  
  output$score_output <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = genre,  y = sales))+
      geom_boxplot(aes(colour = genre))+
      ylim(0,2)+
      geom_jitter(alpha = 0.3, aes(colour = genre))+
      labs(title = "Sales for each genre",
           x = "Genre",
           y = "Sale")
  })
}


# run app -----------------------------------------------------------------


shinyApp(ui = ui, server = server)
