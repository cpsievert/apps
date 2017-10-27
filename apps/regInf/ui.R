library(shiny)

# Define UI for application that plots random distributions
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Regression Inference"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    numericInput("slope", label="Population Slope", min = -10, max = 10, value = 0.7),
    checkboxInput("sample",
                  "Collect Sample!",
                  value=FALSE),
    numericInput("n", label="n", min = 5, max = 100, value = 20),
    sliderInput("sampleid", "Sample id", min = 0, max = 100, value = 0, animate = TRUE)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("plot"),
    plotOutput("hist")
  )
))