library(shiny)
library(ggplot2)

plotArea <- function(section = "upper", q1 = -1.5, q2=NULL, mean=0, sd=1, label.quantiles=TRUE, dist = "z", xlab="z") {
  require(ggplot2)
  x <- seq(mean-4*sd, mean+4*sd, by  = 0.01)
  data <- data.frame(x = x, density = dnorm(x, mean=mean, sd=sd))
  q.upper <- NULL
  q.lower <- NULL
  q.min <- min(q1, q2)
  q.max <- max(q1, q2)
  p <- ggplot(data, aes(x, y=density)) + geom_line() + xlab(xlab)
  if (label.quantiles) {
    value1 <- paste(dist, q.min, sep = "=")
    value2 <- paste(dist, q.max, sep = "=")
  } else {
    value1 <- paste(dist, label.quantiles, sep = "=")
    value2 <- paste(dist, label.quantiles, sep = "=")
  }
  if (!is.null(q.min)) p <- p+annotate("text", label = value1, x = q.min, y = 0, size = 10, colour = "red")
  if (!is.null(q.max)) p <- p+annotate("text", label = value2, x = q.max, y = 0, size = 10, colour = "red")
  if (q.min == q.max) {
    if (section == "upper") {
      section <- subset(data, x > q.min)
      area <- 1-pnorm(q.min, mean=mean, sd=sd)
    } else {
      section <- subset(data, x < q.min)
      area <- pnorm(q.min, mean=mean, sd=sd)
    }
  } else { #two quantiles
    if (section == "outside"){
      section1 <- subset(data, x > q.max)
      p <- p + geom_ribbon(data=section1, aes(ymin=0, ymax=density, fill="blue", alpha=.4))
      section <- subset(data, x < q.min)
      area <- pnorm(q.max, mean=mean, sd=sd, lower.tail=TRUE) + pnorm(q.min, mean=mean, sd=sd)
    } else {
      section <- subset(data, x < q2 & x > q1)
      area <- pnorm(q.max, mean=mean, sd=sd) - pnorm(q.min, mean=mean, sd=sd)
    }
  }
  p + geom_ribbon(data=section, aes(ymin=0, ymax=density, fill="blue", alpha=.4))+theme(legend.position = "none") + 
    annotate("text", label = paste("shaded area = \n P(", toupper(dist), "<", q1, ") = ", round(area, 4)), x = mean+2.9*sd, y = 2*(max(data$density)-min(data$density))/3, size = 8, colour = "red")
}

shinyServer(function(input, output, session) {
  
  output$plot1 <- renderPlot({
     print(plotArea("lower", q1=input$q1))
  })
  
})