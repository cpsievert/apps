library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Visualizing Sampling Methods"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    radioButtons("samp_type", "Choose a sampling method", 
                 choices=c("No Sample" = "none",
                           "Simple Random Sample" = "srs", 
                           "Cluster Sampling" = "clust", 
                           "Stratified Random Sample" = "strat")),
    #submitButton("Take Sample!")
    actionButton("actionID", "Take Sample")
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("mainPlot"),
    plotOutput("splitPlot")
  )
))
