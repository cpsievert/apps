library(MASS)
library(ggplot2)
library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  output$dist <- renderPlot({
    mu <- input$mu
    sd <- input$sigma/sqrt(input$N)
    z <- qnorm(1 - (1 - input$coverage/100)/2)
    lq <- mu - z*sd
    uq <- mu + z*sd
    #max/min shouldn't change with sample size to keep prespective (20 seems like a reasonable value)
    xmin <- mu - 5*input$sigma/sqrt(5)
    xmax <- mu + 5*input$sigma/sqrt(5)
    ymin <- 0
    ymax <- dnorm(mu, mu, input$sigma/sqrt(30)) #maximum density
    x <- seq(xmin, xmax, length.out = 100)
    density <- dnorm(x, mu, sd)
    density <- ifelse(density >= ymax, ymax, density)
    dat <- data.frame(x, density)
    p <- ggplot(data=dat, aes(x=x, y=density)) + geom_line() +
      geom_vline(xintercept=mu, colour = "red") +
      geom_vline(xintercept=lq, colour = "blue", linetype = 2) +
      geom_vline(xintercept=uq, colour = "blue", linetype = 2) +
      xlim(xmin, xmax) + ylim(ymin, ymax) +
      ylab("") + xlab("") + 
      ggtitle(paste("Sampling Distribution of the Sample Mean when n =", input$N))
    print(p)
  })
  
  output$intervals <- renderPlot({
    mu <- input$mu
    sd <- input$sigma/sqrt(input$N)
    z <- qnorm(1 - (1 - input$coverage/100)/2)
    lq <- mu - z*sd
    uq <- mu + z*sd
    #max/min shouldn't change with sample size to keep prespective (20 seems like a reasonable value)
    xmin <- mu - 5*input$sigma/sqrt(5)
    xmax <- mu + 5*input$sigma/sqrt(5)
    ymin <- 1
    ymax <- 100
    # Sample all possible means and use some plotting trickery to only show a certain number
    set.seed(1)
    nmax <- 100 # This assumes the highest number of repeated sample to show is 100
    means <- rnorm(nmax, mu, sd) 
    lb <- means - z*sd
    lb <- ifelse(lb <= xmin, xmin, lb)
    ub <- means + z*sd
    ub <- ifelse(ub >= xmax, xmax, ub)
    outside <- ifelse(means >= uq | means <= lq, "Yes", "No")
    show <-ifelse(seq_len(nmax) <= input$n, "Yes", "No")
    colors <- factor(paste(show, outside, sep="-"), levels=c("No-No", "No-Yes", "Yes-No", "Yes-Yes"))
    color.vals <- c("white", "white", "black", "red") 
    df <- data.frame(n = seq_len(nmax), means, lb, ub, colors)
    p <- ggplot(df, aes(means, n)) + 
      xlim(xmin, xmax) + ylim(ymax, ymin) + scale_colour_manual(values = color.vals) +
      xlab("") + ylab("Sample Number")
    if (input$repeated) {
      p <- p + geom_point(aes(colour=colors)) + 
        geom_vline(xintercept = mu, colour = "red") +
        geom_errorbarh(aes(xmax = lb, xmin = ub, colour=colors)) +
        geom_vline(xintercept=lq, colour = "blue", linetype = 2) +
        geom_vline(xintercept=uq, colour = "blue", linetype = 2) +
        ggtitle(paste(round(100*sum(outside %in% "No" & show %in% "Yes")/input$n), "% of intervals capture the population mean"))
    } else {
      p <- p + geom_blank()
    }
    
    #blank theme
    blank <- theme(
      panel.background = element_rect(fill = "transparent",colour = NA), # or theme_blank()
      panel.grid.minor = element_blank(), 
      panel.grid.major = element_blank(),
      plot.background = element_rect(fill = "transparent",colour = NA),
      legend.position = "none"
    )
    
    print(p + blank)
  })
  
})