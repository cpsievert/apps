library(MASS)
library(ggplot2)
library(shiny)

#http://stackoverflow.com/questions/6528180/ggplot2-plot-without-axes-legends-etc
stripped <- theme(axis.line=element_blank(),
                  axis.text.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks=element_blank(),
                  axis.title.x=element_blank(),
                  axis.title.y=element_blank(),
                  legend.position="none",
                  panel.grid.major=element_blank(),
                  panel.grid.minor=element_blank(),
                  plot.background=element_blank(),
                  plot.title = element_text(lineheight=2, face="bold"))

N <- 9*3 #number of population
set.seed(300)
dat <- data.frame(mvrnorm(N, mu=c(0,0), Sigma=diag(1, nrow=2)))
shape.nms <- c("Circles", "Triangles", "Squares")
n.strata <- N/length(shape.nms)
dat$shapes <- factor(rep(shape.nms, n.strata), levels=shape.nms)
p <- ggplot(data=dat, aes(x=X1, y=X2, shape=shapes, col=shapes)) + geom_point(size=10) + stripped

shinyServer(function(input, output) {
  
  takeSample <- reactive({
    val <- input$actionID
    if (input$samp_type %in% "none") dat2 <- dat
    if (input$samp_type %in% "srs"){
      n.srs <- 9
      idx <- sample(N, N - n.srs)
      dat2 <- dat[idx,]
    }
    if (input$samp_type %in% "clust"){
      dat2 <- subset(dat, shapes != sample(shape.nms, 1))
    }
    if (input$samp_type %in% "strat"){
      # Hardcoded n.srs so let's just hardcode the
      # stratified sampling... I don't think it was truly
      # stratified before...
      id.1 <- sample(0:8, 6)*3 + 1
      id.2 <- sample(0:8, 6)*3 + 2
      id.3 <- sample(0:8, 6)*3 + 3
      idx <- c(id.1, id.2, id.3)
      dat2 <- dat[idx, ]
    }
    return(dat2)
  })
  
  output$mainPlot <- renderPlot({
    dat2 <- takeSample()
    print(p + ggtitle("Population of circles, triangles, and squares!") + 
            geom_point(data=dat2, aes(x=X1, y=X2, shape=shapes), colour="grey90", size=8))
  })
  
  output$splitPlot <- renderPlot({
    dat2 <- takeSample()
    print(p + facet_grid(.~shapes) + ggtitle("Population divided into strata") +
            geom_point(data=dat2, aes(x=X1, y=X2, shape=shapes), colour="grey90", size=8))
  })
  
  
})
