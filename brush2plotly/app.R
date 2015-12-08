# passing plotOutput selections to plotly
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

data(tips, package = "reshape2")

ui <- fluidPage(
  sidebarPanel(
    plotOutput("scatter1", brush = brushOpts("brush", direction = "xy"))
  ),
  mainPanel(
    plotlyOutput("plot1")
  )
)

server <- function(input, output, session) {
  output$scatter1 <- renderPlot({
    ggplot(tips, aes(total_bill, tip, color = day)) + 
      geom_point() + theme(legend.position = "bottom")
  })
  
  output$plot1 <- renderPlotly({
    p <- tips %>%
      count(day) %>%
      plot_ly(x = day, y = n, opacity = 0.5, type = "bar") %>%
      layout(barmode = "overlay", showlegend = FALSE)
    if (!is.null(input$brush)) { 
      br <- input$brush
      s <- tips %>%
        filter(br$xmin <= total_bill, total_bill <= br$xmax) %>%
        filter(br$ymin <= tip, tip <= br$ymax) %>%
        count(day)
      p <- add_trace(p, x = day, y = n, data = s)
    }
    p
  })
  
}

shinyApp(ui, server)
