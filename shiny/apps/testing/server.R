library(shiny)
library(ggplot2)

plotAreaT <- function(section = "upper", q1 = -1.5, label.quantiles=TRUE, dist = "T", xlab=" ") {
  require(ggplot2)
  x <- seq(-4, 4, by  = 0.01)
  df <- 10
  data <- data.frame(x = x, density = dt(x, df))
  p <- ggplot(data, aes(x, y=density)) + geom_line() + xlab(xlab)
  quantile1 <- annotate("text", label = paste("t* =", q1), x = q1, y = 0, size = 8, colour = "black")
  quantile2 <- NULL
  if (section == "upper") {
    section <- subset(data, x > q1)
    area <- pt(q1, df, lower.tail = FALSE)
    p_value <- annotate("text", label = paste("P(", toupper(dist), ">", q1, ") = ", 
                                round(area, 4)), x = 2.9, y = 0.3, size = 8, colour = "black")
  } else if (section == "lower")  {
    section <- subset(data, x < q1)
    area <- pt(q1, df)
    p_value <- annotate("text", label = paste("P(", toupper(dist), "<", q1, ") = ", 
                                              round(area, 4)), x = 2.9, y = 0.3, size = 8, colour = "black")
  } else if (section == "both"){
    section1 <- subset(data, x > abs(q1))
    p <- p + geom_ribbon(data=section1, aes(ymin=0, ymax=density, fill="blue", alpha=.4))
    section <- subset(data, x < -abs(q1))
    area <- pt(abs(q1), df, lower.tail = FALSE) + pt(-abs(q1), df)
    p_value <- annotate("text", label = paste("2*P(", toupper(dist), ">", abs(q1), ") = ", 
                                              round(area, 4)), x = 2.9, y = 0.3, size = 8, colour = "black")
    quantile2 <- annotate("text", label = paste("t* =", -q1), x = -q1, y = 0, size = 8, colour = "black")
  } 
  p + p_value + quantile1 + quantile2 + #geom_vline(xintercept = 0, color = "blue") + annotate("text", label = "0", x = 0, y = 0, size = 5) +
    geom_ribbon(data=section, aes(ymin=0, ymax=density, fill="blue", alpha=.4))+theme(legend.position = "none")
}

shinyServer(function(input, output, session) {
  
  
  output$plot1 <- renderPlot({
    
    #Koshke is the man -- http://stackoverflow.com/questions/14313285/ggplot2-theme-with-no-axes-or-grid
    library(grid)
    p <- plotAreaT(section=input$type, q1=input$q1)
    p <- p + theme(line = element_blank(), 
          text = element_blank(),
          line = element_blank(),
          title = element_blank())
    gt <- ggplot_gtable(ggplot_build(p))
    ge <- subset(gt$layout, name == "panel")
    print(grid.draw(gt[ge$t:ge$b, ge$l:ge$r])) 
  })
  
})