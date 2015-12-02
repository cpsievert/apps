# passing plotOutput selections to plotly
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

ui <- fluidPage(
  plotOutput("scatter1", brush = brushOpts("brush", direction = "xy")),
  plotlyOutput("plot1")
)

server <- function(input, output, session) {
  output$scatter1 <- renderPlot({
    ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
      geom_point()
  })
  
  output$plot1 <- renderPlotly({
    p <- iris %>%
      count(Species) %>%
      plot_ly(x = Species, y = n, opacity = 0.5, type = "bar") %>%
      layout(barmode = "overlay", showlegend = FALSE)
    if (!is.null(input$brush)) { 
      br <- input$brush
      s <- iris %>%
        filter(br$xmin <= Sepal.Length, Sepal.Length <= br$xmax) %>%
        filter(br$ymin <= Sepal.Width, Sepal.Width <= br$ymax) %>%
        count(Species)
      p <- add_trace(p, x = Species, y = n, data = s)
    }
    p
  })
  
}

shinyApp(ui, server)
