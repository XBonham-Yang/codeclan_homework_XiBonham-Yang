library("shiny")
library("shinyWidgets")


# simple use

ui <- fluidPage(
  multiInput(
    inputId = "id", label = "Fruits :",
    choices = c("Banana", "Blueberry", "Cherry",
                "Coconut", "Grapefruit", "Kiwi",
                "Lemon", "Lime", "Mango", "Orange",
                "Papaya")
  ),
  verbatimTextOutput(outputId = "res")
)

server <- function(input, output, session) {
  output$res <- renderPrint({
    input$id
  })
}

shinyApp(ui = ui, server = server)

