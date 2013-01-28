library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Hello Shiny!"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    selectInput("dist", "Select a distribution:", 
                choices=c("Normal" = "norm", "Gamma" = "gamma")),
    sliderInput("obs", "Number of observations:", 
                min = 0, max = 1000, value = 500),
    conditionalPanel(
      condition = "input.dist == 'norm'", #Javascript syntax
      numericInput("mean", "Mean of distribution:", value=0),
      numericInput("std", "Standard Deviation:", value=1)
    ),
    conditionalPanel(
      condition = "input.dist == 'gamma'", #Javascript syntax
      numericInput("shape", "Shape of distribution:", value=1)
    )
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))
