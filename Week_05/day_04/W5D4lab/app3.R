# a bar , a horizontal bar and a stacked bar chart.
# You will need to use if-statements inside server to do this. You can use if statements inside #renderPlot. Remember that the last thing renderPlot should return is the plot you want to make.

library(shiny)
library(tidyverse)
students_big <- CodeClanData::students_big
plots <- c('Bar', 'Horizontal Bar', 'Stacked Bar')

# ui ----------------------------------------------------------------------
ui <- fluidPage(
  fluidRow(radioButtons('type_input',
                        'Plot Type',
                        choices = plots)
    ),

  fluidRow(plotOutput("graph_output"))
)

# server ------------------------------------------------------------------

server <- function(input, output) {
  
  filtered_data <- reactive({
    students_big %>%
      select(handed,gender) 
  }) 
  #'Bar', 'Horizontal Bar', 'Stacked Bar' 
  output$graph_output <- 
    renderPlot({
      if(input$type_input == "Bar"){
      ggplot(filtered_data())+
        geom_bar(aes(x = handed,fill = gender), position = 'dodge')}else{
          if(input$type_input == "Horizontal Bar"){
            ggplot(filtered_data())+
              geom_bar(aes(x = handed,fill = gender), position = 'dodge')+
              coord_flip()
          }else{
            ggplot(filtered_data())+
              geom_bar(aes(x = handed,fill = gender),position="stack")
          }
        }
    })
  
}
# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
