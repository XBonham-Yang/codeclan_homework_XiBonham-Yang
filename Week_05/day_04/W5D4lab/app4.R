library(shiny)
library(tidyverse)
students_big <- CodeClanData::students_big
regions <- unique(students_big$region)
genders <- unique(students_big$gender)


# ui ----------------------------------------------------------------------
ui <- fluidPage(
titlePanel(h1("Reaction time and memory game score")),
sidebarLayout(
  sidebarPanel = sidebarPanel(
    selectInput(inputId = "gender_input",
                 label = 'Gender',
                 choices = genders),
    
    selectInput(inputId = "region_input",
                label = "Region",
                choices = regions),
    
    actionButton("update", "Update dashboard")
  ),
  
  mainPanel = mainPanel(
    tabPanel('Plot', 
             fluidRow(
               column(4, plotOutput('internet_output')),
               column(4, plotOutput('pollution_output'))
               )),
    
    tabPanel('Data',
             DT::dataTableOutput("table_output"))
    
  )
)
)


# server ------------------------------------------------------------------
server <- function(input, output) {
  
  filtered_data <- eventReactive(input$update, {
    students_big %>%
      filter(gender == input$gender_input) %>%
      filter(region == input$region_input)
  }) 
  
  output$table_output <- DT::renderDataTable({
    filtered_data()
  })
  
  output$internet_output <- renderPlot({
    ggplot(filtered_data()) + 
      geom_bar(aes(x = importance_internet_access))
  })
  
  output$pollution_output <- renderPlot({
    ggplot(filtered_data()) + 
      geom_bar(aes(x = importance_reducing_pollution))
  })
}


# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
