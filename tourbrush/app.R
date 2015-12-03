library(shiny)
library(ggplot2)
library(ggvis)
library(tourr)

# transition controls
aps <- 2
fps <- 30

# initiate tour
mat <- rescale(as.matrix(subset(iris, select = Sepal.Length:Petal.Width)))
tour <- new_tour(mat, grand_tour(), NULL)
step <- tour(aps / fps)

cols <- RColorBrewer::brewer.pal(9, "Pastel1")

# mechanism for maintaining brush state
initSelection <- function() {
  color <- rep("black", nrow(iris))
  # x is a logical vector, y is a color
  function(x, y) {
    if (missing(x) || missing(y)) return(color)
    color[x] <<- y
    color
  }
}

selection <- initSelection()

ui <- bootstrapPage(
  # controls
  sidebarPanel(
    selectInput("color", "Paint brush color", choices = cols),
    checkboxInput("step", "Step through tour", FALSE),
    actionButton("clearBrush", "Clear Brush")
  ),
  # views
  mainPanel(
    ggvisOutput("tour"),
    plotOutput("scatter1", brush = brushOpts("brush", direction = "xy"))
  )
)

server <- function(input, output, session) {
  
  # standing on the shoulders of giants, as they say
  # https://github.com/rstudio/ggvis/blob/master/demo/tourr.r
  tourDat <- reactive({
    if (input$step) {
      invalidateLater(1000 / fps, NULL)
    }
    step <- tour(aps / fps)
    df <- data.frame(center(mat %*% step$proj))
    setNames(df, c("x", "y"))
  })
  
  observeEvent(input$clearBrush, {
    selection(TRUE, "black")
  })
  
  updateSelection <- reactive({
    br <- input$brush
    d <- tourDat()
    # pay attention to brush when paused
    d$color <- if (!input$step && !is.null(br)) {
      x <- br$xmin <= d$x & d$x <= br$xmax
      y <- br$ymin <= d$y & d$y <= br$ymax
      selection(x & y, input$color)
    } else {
      selection()
    }
    d
  })
  
  output$scatter1 <- renderPlot({
    if (!input$step) {
      ggplot(updateSelection(), aes(x, y, color = color)) + 
        geom_point() + scale_color_identity() + theme_bw() + 
        xlim(-1, 1) + ylim(-1, 1) + xlab("") + ylab("")
    } else {
      NULL
    }
  }, width = 400)
  
  updateSelection %>%
    ggvis(~x, ~y, fill = ~color) %>%
    layer_points() %>%
    scale_ordinal("fill", domain = c("black", cols), range = c("black", cols)) %>%
    scale_numeric("x", domain = c(-1, 1), label = "") %>%
    scale_numeric("y", domain = c(-1, 1), label = "") %>%
    hide_legend("fill") %>%
    set_options(width = 400, height = 400, keep_aspect = TRUE, duration = 0) %>%
    bind_shiny("tour")
  
}

shinyApp(ui, server)

