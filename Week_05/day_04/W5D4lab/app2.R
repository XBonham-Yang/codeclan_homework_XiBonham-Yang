#A customisable scatter plot
#Here we are going to change attributes of a scatter plot, without changing the data used to make the scatter plot.

#Hints:
  
#colours = c(Blue = "#3891A6", Yellow = "#FDE74C", Red = "#E3655B")
#shape, Square = 15, Circle = 16, Triangle = 17. 
#This uses the sidebar layout
library(shiny)
library(tidyverse)
students_big <- CodeClanData::students_big
colours <- c(Blue = "#3891A6", Yellow = "#FDE74C", Red = "#E3655B")
shapes <- c("Square", "Circle", "Triangle")
# ui ----------------------------------------------------------------------
ui <- fluidPage(
  titlePanel(h1("Reaction Time VS Memory Game")),
sidebarLayout(
  sidebarPanel = sidebarPanel(
    radioButtons(inputId = "colour_input",
                 label = "Colour of points",
                 choices = colours),
    sliderInput("alpha_input", 
                "Transparency of points", 
                value = 50, min = 0, max = 1),
    
    selectInput(inputId = "shape_input",
                label = "Shape of points",
                choices = shapes)
  ),
  
  mainPanel = mainPanel(
    plotOutput('relation_plot'),
    
  )
)
)


# server ------------------------------------------------------------------

server <- function(input, output) {
  output$relation_plot <- renderPlot({
    students_big %>% 
      ggplot()+
      aes(x = score_in_memory_game, y = reaction_time) +
      geom_point(colour = input$colour_input,
                 shape = c( Square = 15, Circle = 16, Triangle = 17)[input$shape_input],
                 alpha = input$alpha_input)
  })
  
}



# run app -----------------------------------------------------------------
shinyApp(ui = ui, server = server)


