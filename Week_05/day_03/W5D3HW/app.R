library(shiny)
library(tidyverse)
library(bslib)
library(png)

students <- CodeClanData::students_big %>% janitor::clean_names() %>% 
  filter(region %in% c("Home Counties","North East","South West","West Midlands","North West","South","East","East Midlands","South East")) %>% 
  filter(reaction_time != 0)

regions <- unique(students$region)
genders <- unique(students$gender)


ui <- fluidPage(
  theme = bs_theme(bootswatch = 'solar'),
  
  tabsetPanel(
    tabPanel('plot',titlePanel(h1("Reaction time and memory game score")),
             sidebarLayout(
               sidebarPanel = sidebarPanel(
                 radioButtons(inputId = "gender_input",
                              label = tags$em('Male or Female?'),
                              choices = genders),
                 
                 selectInput(inputId = "region_input",
                             label = "Which region",
                             choices = regions)
               ),
               
               mainPanel = mainPanel(
                 plotOutput('relation_plot'),
                 
               )
             )
             
             
    ),

    tabPanel('My cats', 
             titlePanel(tags$h1("My cats")),
             
             fluidRow(
               column(4, offset = 1,
                      tags$img(src='orin,png',
                          height=50,width=50)
               ),
               column(4,
                      tags$img(src = 'peggy.png',
                          height=50,width=50)
               )
             ),
             fluidRow(
               column(4, offset = 1,
                      p("This is Orin")),
               column(4,
                      p('This is Peggy'))
             )
    )
  )
)
  
server <- function(input, output) {
  output$relation_plot <- renderPlot({
    students %>% 
      filter(region == input$region_input, 
             gender == input$gender_input) %>% 
      ggplot()+
      aes(x = score_in_memory_game, y = reaction_time) +
      geom_point(aes(colour = as.factor(ageyears))) +
      labs(x = "\nMemory game score",
           y = "Reaction time",
           colour = "Age")
  })
  
}

shinyApp(ui = ui, server = server)



