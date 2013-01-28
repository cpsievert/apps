library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Function that generates a plot of the distribution. The function
  # is wrapped in a call to reactivePlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$distPlot <- reactivePlot(function() {
    
    if (input$dist == "norm") {
      dist <- rnorm(n=input$obs, mean=input$mean, sd=input$std)
      hist(dist)
    } else {
      dist <- rgamma(n=input$obs, shape=input$shape)
      hist(dist)
    }
    
  })
  
})
