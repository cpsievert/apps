library(plotly)
library(shiny)

# compute a correlation matrix
m <- round(cor(mtcars), 3)
nms <- names(mtcars)

ui <- fluidPage(
  mainPanel(
    plotlyOutput("heat"),
    plotlyOutput("scatterplot")
  ),
  verbatimTextOutput("selection")
)

server <- function(input, output, session) {
  output$heat <- renderPlotly({
    plot_ly(x = nms, y = nms, z = m, key = m, type = "heatmap") %>%
      layout(xaxis = list(title = ""), yaxis = list(title = ""))
  })
  
  rv <- reactive({
    # the 'group' here should match the 'set' in plot_ly() 
    # (this naming is likely to change)
    cv <- crosstalk::ClientValue$new("plotly_click", group = "A")
    cv$get()
  })
  
  output$selection <- renderPrint({
    s <- rv()
    if (length(s) == 0) {
      "Click on a cell in the heatmap to display a scatterplot"
    } else {
      cat("You selected: \n\n")
      as.list(s)
    }
  })
  
  output$scatterplot <- renderPlotly({
    s <- rv()
    if (length(s)) {
      vars <- c(s[["x"]], s[["y"]])
      d <- setNames(mtcars[vars], c("x", "y"))
      yhat <- fitted(lm(y ~ x, data = d))
      plot_ly(d, x = x, y = y, mode = "markers") %>%
        add_trace(x = x, y = yhat, mode = "lines") %>%
        layout(xaxis = list(title = s[["x"]]), 
               yaxis = list(title = s[["y"]]), showlegend = FALSE)
    } else {
      plot_ly()
    }
  })
  
}

shinyApp(ui, server, options = list(display.mode = "showcase"))
