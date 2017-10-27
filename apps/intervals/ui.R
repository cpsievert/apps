library(shiny)

# Define UI for application that plots random distributions
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Law of Large Numbers and Repeated Sampling"),
  
  sidebarPanel(
    numericInput("mu", label="Population Mean", min = 0, max = 100, value = 20),
    numericInput("sigma", label="Population Standard Devation", min = 1, max = 20, value = 5),
    conditionalPanel(
      condition = "!input.repeated",
      sliderInput("N", "Sample Size (n)", min = 1, max = 1000, value = 1, animate=TRUE)
    ),
    HTML("<hr />"),
    checkboxInput("repeated", "Conduct repeated sampling?", value = FALSE),
    HTML("<hr />"),
    conditionalPanel(
      condition = "input.repeated",
      sliderInput("n", "Repeated Samples", min = 1, max = 100, value = 1, animate=TRUE),
      sliderInput("coverage", "Coverage", min = 1, max = 100, value = 95)
    )
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("dist"),
    plotOutput("intervals", height = "1200px")
    #verbatimTextOutput("dat")
  )
))