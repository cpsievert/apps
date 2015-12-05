library(shiny)
library(ggplot2)
library(ggvis)
library(tourr)

# @param d a nx2 data frame with columns 'x' and 'y' for the static plot
# @param m a nxp numeric matrix for touring in 2 dimensions
# @param labels optional a character/factor vector of labels (classes) for each obervation.
run_tour <- function(d, m, labels = NULL) {
  
  # ensure labels are actually color codes so we can apply identity scaling
  # (useful for brush)
  if (!is.null(labels)) 
    labels <- scales::col_factor("Dark2", levels = unique(labels))(labels)
  
  # transition controls
  aps <- 2
  fps <- 30
  
  # initiate tour
  mat <- rescale(m)
  tour <- new_tour(mat, grand_tour(), NULL)
  step <- tour(aps / fps)
  
  cols <- setdiff(RColorBrewer::brewer.pal(8, "Dark2"), labels)
  
  # mechanism for maintaining brush state
  initSelection <- function(labels = NULL) {
    color <- if (is.null(labels)) rep("black", nrow(m)) else labels
    # x is a logical vector, y is a color
    function(x, y) {
      if (missing(x) || missing(y)) return(color)
      color[x] <<- y
      color
    }
  }
  
  selection <- initSelection(labels)
  
  ui <- bootstrapPage(
    # controls
    sidebarPanel(
      plotOutput("scatter1", brush = brushOpts("brush", direction = "xy")),
      br(),
      checkboxInput("step", "Step through tour", FALSE),
      br(),
      selectInput("color", "Paint brush color", choices = cols),
      div(style = "display:inline-block", actionButton("clearBrush", "Clear Brush")),
      div(style = "display:inline-block", checkboxInput("persistent", "Persistent Brush", FALSE)),
      width = 4
    ),
    # views
    mainPanel(
      ggvisOutput("tour")
    )
  )
  
  server <- function(input, output, session) {
    
    # standing on the shoulders of giants, as they say
    # https://github.com/rstudio/ggvis/blob/master/demo/tourr.r
    tourDat <- reactive({
      if (input$step) {
        invalidateLater(1000 / fps, NULL)
        step <<- tour(aps / fps)
      }
      df <- data.frame(center(mat %*% step$proj))
      df <- cbind(df, updateSelection())
      setNames(df, c("x", "y", "color"))
    })
    
    observeEvent(input$clearBrush, {
      selection <- initSelection(labels)
    })
    
    updateSelection <- reactive({
      br <- input$brush
      # pay attention to brush when paused
      if (!is.null(br)) {
        if (!input$persistent) selection <- initSelection(labels)
        x <- br$xmin <= d$x & d$x <= br$xmax
        y <- br$ymin <= d$y & d$y <= br$ymax
        selection(x & y, input$color)
      } else {
        selection()
      }
    })
    
    output$scatter1 <- renderPlot({
      d$color <- updateSelection()
      ggplot(d, aes(x, y, color = color)) + 
        geom_point(size = 5) + scale_color_identity() + theme_bw() + 
        xlab("") + ylab("")
    }, width = 400)
    
    # collect all the colors to use a identity scale in ggvis
    colz <- c("black", cols)
    if (!is.null(labels)) colz <- c(colz, unique(labels))
    
    tourDat %>%
      ggvis(~x, ~y, fill = ~color) %>%
      layer_points() %>%
      scale_ordinal("fill", domain = colz, range = colz) %>%
      scale_numeric("x", domain = c(-1, 1), label = "") %>%
      scale_numeric("y", domain = c(-1, 1), label = "") %>%
      hide_legend("fill") %>%
      set_options(width = 400, height = 400, keep_aspect = TRUE, duration = 0) %>%
      bind_shiny("tour")
  }
  shinyApp(ui, server)
}
