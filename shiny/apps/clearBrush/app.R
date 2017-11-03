library(shiny)
library(shinyjs)
library(ggplot2)

ui <- fluidPage(
  useShinyjs(),
  actionButton("clear", "Clear brush"),
  fluidRow(
    column(
      width = 6,
      plotOutput("p1", brush = brushOpts("b1"))
    ),
    column(
      width = 6,
      plotOutput("p2", brush = brushOpts("b2"))
    )
  ),
  fluidRow(
    column(
      width = 6,
      verbatimTextOutput("brush1")
    ),
    column(
      width = 6,
      verbatimTextOutput("brush2")
    )
  )
)

server <- function(input, output) {
  
  values <- reactiveValues(
    brush1 = NULL,
    brush2 = NULL
  )
  
  # update reactive values when input values change
  observe({
    values$brush1 <- input$b1
    values$brush2 <- input$b2
  })
  
  # display brush details
  output$brush1 <- renderPrint({
    values$brush1
  })
  
  output$brush2 <- renderPrint({
    values$brush2
  })
  
  # clear brush values and remove the div from the page
  observeEvent(input$clear, {
    values$brush1 <- NULL
    values$brush2 <- NULL
    runjs("document.getElementById('p1_brush').remove()")
    runjs("document.getElementById('p2_brush').remove()")
  })
  
  output$p1 <- renderPlot({
    input$clear
    m <- brushedPoints(mtcars, values$brush1, allRows = TRUE)
    qplot(data = m, wt, mpg, colour = selected_) + 
      theme(legend.position = "none")
  })
  
  output$p2 <- renderPlot({
    input$clear
    m <- brushedPoints(mtcars, values$brush2, allRows = TRUE)
    qplot(data = m, wt, mpg, colour = selected_) +
      theme(legend.position = "none")
  })
  
}

shinyApp(ui, server)