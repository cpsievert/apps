library(shiny)

ui <- fluidPage(
  plotOutput("p")
)

server <- function(input, output, ...) {
  
  output$p <- renderPlot({
    plot(1, main = "Everything works")
  })
  
}

shinyApp(ui, server)