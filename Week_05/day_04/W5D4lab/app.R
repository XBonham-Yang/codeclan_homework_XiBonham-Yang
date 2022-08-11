#Height and Arm Span vs Age
# two histograms that show the height and arm-span  
#different ages, as chosen by radio buttons on the top of the app.

#Hints:

#Use radioButtons with inline = TRUE, to get horizontal radio buttons.
#This app uses fluidRow and column
#Both plots use the same data. Can you use reactive to make this efficient?
library(shiny)
library(tidyverse)
students_big <- CodeClanData::students_big
ages <- unique(students_big$ageyears)

# ui ----------------------------------------------------------------------
ui <- fluidPage(
  fluidRow(
    column(6, offset = 1,
           radioButtons('age_input',
                        'Age',
                        choices = ages,
                        inline = TRUE)
    )
  ),
  
  fluidRow(
    column(6,
           plotOutput("height_output")
    ),
    column(6,
           plotOutput("arm_output")
    )
  )
)


# server ------------------------------------------------------------------
server <- function(input, output) {
  
  filtered_data <- reactive({
    students_big %>%
      filter(ageyears == input$age_input) 
  }) 
  
  
  output$height_output <- renderPlot({
    ggplot(filtered_data())+
      geom_histogram(aes(x = height))
  })
  
  
  output$arm_output <- renderPlot({
    ggplot(filtered_data())+
      geom_histogram(aes(x = arm_span))
  })
}
  

# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
  
  
  
  
  
  
  
  
  