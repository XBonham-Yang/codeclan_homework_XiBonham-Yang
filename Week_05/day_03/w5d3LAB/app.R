library(shiny)
library(tidyverse)
library(bslib)
olympics_medals <- read_csv("data/olympics_overall_medals.csv")%>%
  mutate(medal = factor(medal, c("Gold", "Silver", "Bronze")))
medals <- unique(olympics_medals$medal)
season <- unique(olympics_medals$season)

ui <- fluidPage(
  theme = bs_theme(bootswatch = 'minty'),
  titlePanel(h1("Five Country Medal Comparison")),
  
  
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      radioButtons(inputId = "season_input",
                   label = 'Summer or winter?',
                   choices = season),
      
      selectInput(inputId = "medal_input",
                  label = "which medal?",
                  choices = medals)
    ),
    mainPanel = mainPanel(
      plotOutput('medal_plot'),
    )
  )
)

server <- function(input, output) {
  output$medal_plot <- renderPlot({
    olympics_medals %>%
      filter(team %in% c("United States",
                         "Soviet Union",
                         "Germany",
                         "Italy",
                         "Great Britain")) %>%
      filter(medal == input$medal_input) %>%
      filter(season == input$season_input) %>%
      ggplot() +
      aes(x = team, y = count) +
      geom_col(aes(fill = medal))+
      scale_fill_manual(values = c("Gold" = "gold", "Silver" = "grey", "Bronze" = "brown"))+
      theme(legend.position="none",
      )+
      labs(x = "\nCountries",
           y = "Count")
  })
  
}

shinyApp(ui = ui, server = server)