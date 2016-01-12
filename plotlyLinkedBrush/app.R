library(plotly)
library(shiny)

# create a key row identifier for mapping selection(s) back to the data
iris$key <- seq_len(nrow(iris))

# user interface
ui <- fluidPage(
  titlePanel("Linked highlighting with plotly and shiny"),
  mainPanel(
    plotlyOutput("x", width = 400, height = 250, inline = T),
    wellPanel(
      style = "display:inline-block; vertical-align:top;", 
      sliderInput("xbins", "Number of x bins", 
                  min = 1, max = 50, value = 20, width = 250),
      sliderInput("ybins", "Number of y bins", 
                  min = 1, max = 50, value = 20, width = 250)
    ),
    br(),
    plotlyOutput("xy", width = 400, height = 400, inline = T),
    plotlyOutput("y", width = 250, height = 400, inline = T)
  )
)

server <- function(input, output, session) {
  # mechanism to access the 'plotly_selected' user event
  cv <- crosstalk::ClientValue$new("plotly_selected", group = "A")
  
  # convenience function for computing xbin/ybin object given a number of bins
  compute_bins <- function(x, n) {
    list(
      start = min(x),
      end = max(x),
      size = (max(x) - min(x)) / n
    )
  }
  
  # the 'x' histogram
  output$x <- renderPlotly({
    x <- iris$Petal.Width
    xbins <- compute_bins(x, input$xbins)
    p <- plot_ly(x = x, type = "histogram", autobinx = F, xbins = xbins)
    # obtain plotlyjs selection
    s <- cv$get()
    # if points are selected, subset the data, and highlight
    if (length(s$x) > 0) {
      p <- add_trace(p, x = s$x, type = "histogram", autobinx = F, xbins = xbins)
    }
    p %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(showlegend = F, barmode = "overlay", yaxis = list(title = "count"),
             xaxis = list(title = "", showticklabels = F))
  })
  
  # basically the same as 'x' histogram
  output$y <- renderPlotly({
    y <- iris$Sepal.Width
    ybins <- compute_bins(y, input$ybins)
    p <- plot_ly(y = y, type = "histogram", autobiny = F, ybins = ybins)
    s <- cv$get()
    if (length(s$y) > 0) {
      p <- add_trace(p, y = s$y, type = "histogram", autobiny = F, ybins = ybins)
    }
    p %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(showlegend = F, barmode = "overlay", xaxis = list(title = "count"),
             yaxis = list(title = "", showticklabels = F))
  })
  
  output$xy <- renderPlotly({
    iris %>% 
      plot_ly(x = Petal.Width, y = Sepal.Width, key = key, mode = "markers") %>%
      layout(dragmode = "select")
  })
  
}

shinyApp(ui, server)
