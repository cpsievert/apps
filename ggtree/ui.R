library(shiny)
library(shinyAce)

shinyUI(fluidPage(
  titlePanel("Visualizaing ggplot2 internals"),
  tags$h4('Made with love by', tags$a(href = "http://cpsievert.github.io/about.html", 'Carson Sievert'),
          tags$a(href = "", 'See here'), 'for source code'),
             
  tags$head(
    tags$script(type="text/javascript", src = "d3.v3.js"),
    tags$script(type="text/javascript", src ="d3.tip.js"),
    tags$script(type="text/javascript", src ="ggtree.js"),
    tags$link(rel = 'stylesheet', type = 'text/css', href = 'ggtree.css')
  ),
  
  fluidRow(
    column(width = 6,
           HTML("<div id=\"dat\" class=\"shiny-scatter-output\"><svg /></div>") 
    ),
    column(width = 6,
      aceEditor("code", 
                value="ggplot(mtcars, aes(mpg, wt)) + \n geom_point(colour='grey50', size = 4) + \n geom_point(aes(colour = cyl))",
                mode = "r", theme = "chrome", height = "50px", fontSize = 10),
      actionButton("send", "Send code"),
      plotOutput(outputId = "ggplot")
    )
  )
))