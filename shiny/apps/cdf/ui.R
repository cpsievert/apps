shinyUI(bootstrapPage(  
  
  mainPanel(
    plotOutput("plot1"),
    textOutput("prob")
  ),
  
  sidebarPanel(
    sliderInput("q1", "z-score", min = -4, max = 4, value = 0, step = 0.01)
  )
))