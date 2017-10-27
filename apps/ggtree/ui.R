library(shiny)
library(shinyAce)

shinyUI(fluidPage(
  titlePanel("Visualizing ggplot2 internals"),
  tags$h4('See', tags$a(href = "http://cpsievert.github.io/", 'here'), 'for accompanying post and',
          tags$a(href = "https://github.com/cpsievert/shiny_apps/tree/master/ggtree", 'here'), 
          'for source code'),
             
  tags$head(
    tags$script(type="text/javascript", src = "d3.v3.js"),
    tags$script(type="text/javascript", src ="d3.tip.js"),
    tags$script(type="text/javascript", src ="ggtree.js"),
    tags$link(rel = 'stylesheet', type = 'text/css', href = 'ggtree.css')
  ),
  
  fluidRow(
    column(width = 6,
           selectInput("d3layout", "Choose a layout:", 
                       choices = c("Radial" = "radial",
                                   "Collapsed" = "collapse",
                                   "Cartesian" = "cartesian")),
           HTML("<div id=\"d3\" class=\"d3plot\"><svg /></div>")
    ),
    column(width = 6,
      aceEditor("code", 
                value="# Enter code to generate a ggplot here \n# Then click 'Send Code' when ready
p <- ggplot(mtcars, aes(mpg, wt)) + \n geom_point(colour='grey50', size = 4) + \n geom_point(aes(colour = cyl)) + facet_wrap(~am, nrow = 2)
# Visualize the 'built' version -- this is optional\nggplot_build(p)",
                mode = "r", theme = "chrome", height = "100px", fontSize = 10),
      actionButton("send", "Send code"),
      plotOutput(outputId = "ggplot")
    )
  )
))