function(input, output) {
  output$plot <- renderPlot({ 
    dat <- subset(topnames, name %in% input$name)
    ggplot(dat, aes(year, prop, colour = sex)) + 
      geom_line() + facet_wrap(~ name)
  })
}
