library(MASS)
library(ggplot2)
library(shiny)

N <- 100
n <- 21
mat <- mvrnorm(N, mu=rep(5,2), Sigma = matrix(c(1, .7, 1, .7), nrow=2, ncol=2), empirical=TRUE)
dat <- data.frame(x=mat[,1], y=mat[,2], sample=rep(FALSE, N))


# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    #set.seed(1)
    dat[sample(1:N, n),"sample"] <- TRUE
    lm_eqn = function(df, sample=FALSE){
      if (sample) {
        df <- subset(df, sample==TRUE)
      } 
      m <- lm(y ~ x, df)
      eq <- substitute(italic(y) == a + b %.% italic(x),
                       list(a = format(coef(m)[1], digits = 3), 
                            b = format(coef(m)[2], digits = 3)))
      #r2 = format(summary(m)$r.squared, digits = 3)))
      as.character(as.expression(eq));                 
    }
    p <- qplot(data=dat, x, y)#+geom_smooth(method="lm", se=FALSE) 
    sample_eq <- NULL
    colors <- NULL
    if (input$sample) {
      sample_eq <- geom_text(aes(x = 3, y = 5, label = lm_eqn(dat, sample=TRUE)), color="red", parse = TRUE)
      p <- qplot(data=dat, x, y, color=sample)
      colors <- scale_colour_manual(values = c(rgb(0,0,1,.25), rgb(1,0,0))) 
    }
    print(p + geom_text(aes(x = 3, y = 6, label = lm_eqn(dat)), color="blue", parse = TRUE) +
            sample_eq + colors + geom_smooth(method="lm", se=FALSE) +
            theme(legend.position="none") + xlim(2, 8)+ ylim(2, 8))
  })
})
