shinyUI(bootstrapPage(  
  
  tags$head(
    tags$style(type="text/css", ".jslider { max-width: 700px; }"),
    tags$script(src = 'https://c328740.ssl.cf1.rackcdn.com/mathjax/2.0-latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML', type = 'text/javascript')
  ),
  
  sidebarPanel(
    radioButtons("type", "Choose an alternative hypothesis:", choices = c("Less than (one sided)" = "lower",
                                                               "Greater than (one sided)" = "upper",
                                                               "Not equal to (two-sided)" = "both"))
  ),
  
  mainPanel(
    plotOutput("plot1"),
    div(align = "center", sliderInput("q1", " ", min = -4, max = 4, value = 0, step = 0.01))
  )
))