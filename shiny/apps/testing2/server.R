library(shiny)
library(ggplot2)
library(grid)

shinyServer(function(input, output, session) {
  
  
  output$plot1 <- renderPlot({
    
    plotAreaT <- function(type = "upper", critical = -1.5, test = -1, xlab=" ") {
      x <- seq(-4, 4, by  = 0.01)
      over <- FALSE
      #Is test statistic over the acceptable amount?
      if (test > max(x) || test < min(x)) over <- TRUE
      df <- input$n - 1
      data <- data.frame(x = x, density = dt(x, df))
      p <- ggplot(data, aes(x, y=density)) + geom_line() + xlab(xlab) #+ xlim(-4, 4)
      test1 <- annotate("text", label = paste("t =", test), x = test, y = -0.02, size = 8, colour = "black")
      test2 <- NULL
      if (type == "upper") {
        if (!over) section <- subset(data, x > test)
        area <- pt(test, df, lower.tail = FALSE)
        p_value <- annotate("text", label = paste("P(T >", test, ") = ", 
                                                  round(area, 4)), x = -2.5, y = 0.35, size = 8, colour = "black")
      } else if (type == "lower")  {
        if (!over) section <- subset(data, x < test)
        area <- pt(test, df)
        p_value <- annotate("text", label = paste("P(T <", test, ") = ", 
                                                  round(area, 4)), x = -2.5, y = 0.35, size = 8, colour = "black")
      } else if (type == "both"){
        if (!over) {
          section1 <- subset(data, x > abs(test))
          p <- p + geom_ribbon(data=section1, aes(ymin=0, ymax=density, fill="black", alpha=.4))
          section <- subset(data, x < -abs(test))
        }
        area <- pt(abs(test), df, lower.tail = FALSE) + pt(-abs(test), df)
        p_value <- annotate("text", label = paste("2*P(T >", abs(test), ") = ", 
                                                  round(area, 4)), x = -2.5, y = 0.35, size = 8, colour = "black")
        test2 <- annotate("text", label = paste("t =", -test), x = -test, y = -0.02, size = 8, colour = "black")
      } 
      crit1 <- NULL
      crit2 <- NULL
      line1 <- NULL
      line2 <- NULL
      msg <- NULL
      if (!is.null(critical)) {
        line1 <- geom_vline(xintercept=critical, color = "blue")
        if (type == "both") line2 <- geom_vline(xintercept = -critical, color = "blue")
        #Thank you yihui -- http://vis.supstat.com/2013/04/mathematical-annotation-in-r/
        #crit1 <- annotate("text", label = "group('|', t[list(frac(alpha, 2), n-1)], '|')", parse = TRUE, x = 2.5, y = 0.35, size = 8, colour = "blue")
        #crit2 <- annotate("text", label = paste(" = ", abs(critical)), x = 3.4, y = 0.35, size = 8, colour = "blue")
        if (area < pt(critical, df)) {
          msg <- annotate("text", label = "Reject the null", x = 3, y = 0.3, size = 8, colour = "blue")
        } else {
          msg <- annotate("text", label = "Fail to reject the null", x = 3, y = 0.3, size = 8, colour = "blue")
        }
      }
      if (!over) p <- p + geom_ribbon(data=section, aes(ymin=0, ymax=density, fill="black", alpha=.4))
      p + p_value + test1 + test2 + line1 + line2 + crit1 + crit2 + msg + theme(legend.position = "none")
    }
    
    # Critical value for hypothesis test
    if (input$type == "upper") {
      crit <- qt(input$alpha, df = input$n - 1, lower.tail = FALSE)
    } else  if (input$type == "lower") {
      crit <- qt(input$alpha, df = input$n - 1)
    } else { #two-sided test
      crit <- qt(input$alpha/2, df = input$n - 1)
    } 
    crit <- round(crit, 2)
    #Show the critical value?
    if (!input$sig) crit <- NULL
    
    #test statistic
    stat <- round((input$xbar - input$mu)/(input$se/input$n), 2)
    
    #Koshke is the man -- http://stackoverflow.com/questions/14313285/ggplot2-theme-with-no-axes-or-grid
    p <- plotAreaT(type=input$type, critical = crit, test = stat)
    p <- p + theme(line = element_blank(), 
          text = element_blank(),
          line = element_blank(),
          title = element_blank())
    gt <- ggplot_gtable(ggplot_build(p))
    ge <- subset(gt$layout, name == "panel")
    print(grid.draw(gt[ge$t:ge$b, ge$l:ge$r])) 
  })
  
})