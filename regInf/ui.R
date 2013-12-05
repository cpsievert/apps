library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Regression Inference"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    checkboxInput("sample", 
                  "Collect Sample!", 
                  value=FALSE)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))