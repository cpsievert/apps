library(ggvis)
library(shiny)
library(dplyr)
library(htmltools)
data(WorldBank, package = "animint")

# remove extraneous text in region labels
WorldBank$region <- sub("\\s+$", "", sub("\\(.*", "", WorldBank$region))
WorldBank <- WorldBank %>% 
  filter(!is.na(life.expectancy) & !is.na(fertility.rate))
years <- data.frame(year = unique(WorldBank$year))

# user interface
ui <- shinyUI(bootstrapPage(
  tagList(
    tags$span(style = "display: inline-block;", ggvisOutput("plot1")),
    tags$span(style = "display: inline-block;", ggvisOutput("plot2"))
  ),
  sliderInput(
    "year", "Year", min = min(years), max = max(years), value = min(years),
    step = 1, sep = "", animate = TRUE
  ),
  selectizeInput(
    "country", "Select a country", choices = unique(WorldBank$country),
    selected = c("United States", "Thailand"), multiple = TRUE
  ),
  selectizeInput(
    "region", "Select a region", choices = unique(WorldBank$region),
    selected = c("East Asia & Pacific", "North America"), multiple = TRUE
  )
))

server <- shinyServer(function(input, output, session) {
  # initiate some reactive values
  #rv <- reactiveValues(
  #  year = input$year,
  #  country = input$country,
  #  region = unique(WorldBank$region)
  #)
  
  # similar to showSelected=region
  WorldBank1 <- reactive({
    if (!is.null(input$region)) {
      WorldBank <- WorldBank[WorldBank$region %in% input$region, ]
    }
    WorldBank
  })
  currentYear <- reactive({
    data.frame(year = input$year)
  })
  rng <- range(WorldBank$life.expectancy)
  
  # MISSING: 
  # (1) a clickable layer of rects that can modify the selected year
  # (2) handling click on a line to annotate points in the scatterplot
  WorldBank1 %>%
    ggvis(x = ~year) %>%
    group_by(country) %>%
    layer_lines(
      x = ~year, y = ~life.expectancy, stroke = ~region, opacity := 0.5, 
      opacity.hover := 1, strokeWidth := 3
    ) %>%
    add_data(currentYear) %>%
    layer_rects(
      x = ~year - 0.5, x2 = ~year + 0.5, y = rng[1], y2 = rng[2]
    ) %>%
    add_axis("x", title = "year", format = ".0") %>%
    hide_legend("stroke") %>%
    set_options(width = 400, height = 300) %>%
    bind_shiny("plot1")
  
  # similar to showSelected=country,region,year
  WorldBank2 <- reactive({
    # year input is always defined
    WorldBank <- WorldBank[WorldBank$year %in% input$year, ]
    # region may be undefined which means all regions
    if (!is.null(input$region)) {
      WorldBank <- WorldBank[WorldBank$region %in% input$region, ]
    }
    WorldBank
  })
  
  countryText <- reactive({
    d <- WorldBank[WorldBank$year == input$year, ]
    if (!is.null(input$country)) {
      d <- d[d$country %in% input$country, ]
    }
    d
  })
  
  WorldBank2 %>%
    ggvis(~fertility.rate, ~life.expectancy) %>%
    layer_points(
      fill = ~region, size = ~population, opacity := 0.5, opacity.hover := 1
    ) %>%
    add_data(countryText) %>%
    layer_text(text := ~country) %>%
    add_data(currentYear) %>%
    mutate(year = paste("Year:", year)) %>%
    layer_text(x = 4.5, y = 85, text := ~year) %>%
    scale_numeric(
      "x", domain = range(WorldBank$fertility.rate), nice = FALSE, clamp = TRUE
    ) %>%
    scale_numeric(
      "y", domain = range(WorldBank$life.expectancy), nice = FALSE, clamp = TRUE
    ) %>%
    scale_numeric(
      "size", range = c(10, 1000)
    ) %>%
    hide_legend("size") %>%
    set_options(width = 600, height = 300) %>%
    bind_shiny("plot2")
  
})

shinyApp(ui, server)
