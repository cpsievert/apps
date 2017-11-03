library(plotly)
library(shiny)
d <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv")

# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

ui <- fluidPage(
  mainPanel(
    plotlyOutput("map"),
    plotlyOutput("hist")
  ),
  verbatimTextOutput("selection")
)

server <- function(input, output, session) {
  
  cv <- crosstalk::ClientValue$new("plotly_select", group = "A")
  
  output$map <- renderPlotly({
    s <- cv$get()
    if (length(s$x) > 0) {
      # ask Alex to return the extent of the brush?
      x <- d$cotton
      d <- d[min(s$x) <= x & x <= max(s$x), ]
    }
    plot_ly(d, z = total.exports, locations = code, type = 'choropleth',
            locationmode = 'USA-states', color = total.exports,
            marker = list(line = l), colorbar = list(title = "Millions USD")) %>%
      layout(geo = g)
  })
  
  output$hist <- renderPlotly({
    # plotly_select is currently only for markers :(
    plot_ly(d, x = cotton, type = 'histogram')
  })
  
  output$selection <- renderPrint({
    cv$get()
  })
  
}

shinyApp(ui, server)


