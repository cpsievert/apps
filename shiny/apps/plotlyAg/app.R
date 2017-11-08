library(plotly)
library(shiny)
d <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv")
# useless vars
d <- d[!names(d) %in% "category"]

dmelt <- tidyr::gather(d[!names(d) %in% "code"], variable, value, -state)

# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

# TODO: a dropdown to select different variables...
ui <- fluidPage(
  fluidRow(plotlyOutput("map")),
  plotlyOutput("hist", width = "100%")
)

server <- function(input, output, session) {
  
  output$map <- renderPlotly({
    plot_geo(
      d, z = ~total.exports, key = ~state, type = "choropleth",
      locations = ~code, locationmode = 'USA-states', 
      color = ~total.exports, 
      # give state boundaries a white border
      marker = list(line = list(color = toRGB("white"), width = 2)),
      colorbar = list(title = "Total ag exports \n (millions USD)")
    ) %>%
      layout(
        title = "Click and drag to query state(s)",
        geo = g, dragmode = "lasso"
      )
  })
  
  output$hist <- renderPlotly({
    ed <- event_data("plotly_selected")
    p <- ggplot(dmelt, aes(value)) + 
      geom_density() + 
      facet_wrap(~variable, scales = "free") +
      labs(x = NULL, y = NULL) +
      theme_minimal() +
      theme(
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()
      )
    if (!is.null(ed)) p <- p + geom_density(data = dmelt[dmelt$state %in% ed$key, ], lty = 3)
    ggplotly(p, dynamicTicks = TRUE, height = 500)
  })
  
}

shinyApp(ui, server)


