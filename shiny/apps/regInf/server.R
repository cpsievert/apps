library(MASS)
library(ggplot2)
library(shiny)



# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  getDat <- reactive({
    N <<- 100
    slope <<- input$slope 
    mat <<- mvrnorm(N, mu=rep(5,2), Sigma = matrix(c(1, slope, slope, 1), nrow=2, ncol=2), empirical=TRUE)
    dat <<- data.frame(x=mat[,1], y=mat[,2], sample=rep(FALSE, N))
    samples <<- NA
  })
  
  output$plot <- renderPlot({
    #set.seed(1)
    getDat()
    n <- as.numeric(input$n)
    dat[sample(1:N, n),"sample"] <- TRUE
    lm_eqn = function(df, sample=FALSE){
      if (sample) {
        df <- subset(df, sample==TRUE)
      }
      m <<- lm(y ~ x, df)
      eq <- substitute(italic(y) == a + b %.% italic(x),
                       list(a = format(round(coef(m)[1], 3), digits = 3),
                            b = format(round(coef(m)[2], 3), digits = 3)))
      #r2 = format(summary(m)$r.squared, digits = 3)))
      as.character(as.expression(eq));
      
    }
    p <- qplot(data=dat, x, y)#+geom_smooth(method="lm", se=FALSE)
    sample_eq <- NULL
    colors <- NULL
    if (input$sample | input$sampleid > 0) {
      sample_eq <- geom_text(aes(x = 3, y = 6, label = lm_eqn(dat, sample=TRUE)), color="red", parse = TRUE)
      p <- qplot(data=dat, x, y, color=sample)
      colors <- scale_colour_manual(values = c(rgb(0,0,1,.25), rgb(1,0,0)))
    }
    print(p + geom_text(aes(x = 3, y = 7, label = lm_eqn(dat)), color="blue", parse = TRUE) +
          sample_eq + colors + geom_smooth(method="lm", se=FALSE) + theme_bw() +
          theme(legend.position="none") + xlim(2, 8)+ ylim(2, 8))
  })
  
  output$hist <- renderPlot({
    getDat()
    if(input$sampleid == 0){
      return(NULL)
    }else{
      samples[input$sampleid] <<- coef(m)[2]
      hist(samples, main = "Histogram of sampled values of b1", xlab = "b1")
    }
  })
  
})