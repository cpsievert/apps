shinyUI(bootstrapPage(  
  
  tags$head(
    tags$style(type="text/css", ".jslider { max-width: 700px; }")
    #tags$script(src = 'https://c328740.ssl.cf1.rackcdn.com/mathjax/2.0-latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML', type = 'text/javascript')
  ),
  
  sidebarPanel(
    sliderInput("mu", "Claim for population mean", min = -10, max = 10, value = 3, step = 1),
    sliderInput("xbar", "Sample mean", min = -10, max = 10, value = 1, step = 1),
    sliderInput("n", "Sample size", min = 1, max = 100, value = 20, step = 1, animate = TRUE),
    sliderInput("se", "Sample standard deviation", min = 1, max = 100, value = 50, step = 1),
    HTML("<hr />"),
    radioButtons("type", "Choose an alternative hypothesis:", choices = c("Less than (one sided)" = "lower",
                                                               "Greater than (one sided)" = "upper",
                                                               "Not equal to (two-sided)" = "both")),
    HTML("<hr />"),
    checkboxInput("sig", "Set a significance level", value = FALSE),
    conditionalPanel(
      condition = "input.sig",
      HTML("<hr />"),
      sliderInput("alpha", "Level of significance", min = 0.01, max = 0.5, value = .05, step = .01)
    )
    
  ),
  
  mainPanel(
    plotOutput("plot1")
    #div(align = "center", sliderInput("q1", " ", min = -4, max = 4, value = 0, step = 0.01))
  )
))