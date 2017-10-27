library(shiny)
library(shinyAce)
library(plotly)
library(listviewer)


ui <- fluidPage(
  
  fluidRow(
    plotlyOutput("plot")
  ),
  
  fluidRow(
    column(
      width = 6,
      aceEditor(
        outputId = "code",
        "# Enter a ggplot2 or plotly graph, for example: \n\nqplot(1:10)",
        mode = "r", 
        theme = "chrome", 
        height = "300px", 
        fontSize = 12
      ),
      actionButton("send", "Send code"),
      bookmarkButton()
    ),
    column(
      width = 6,
      jsoneditOutput("spec")
    )
  )
  
)


server <- function(input, output) {
  
  getPlot <- reactive({
    eval(parse(text = input$code))
  })
  
  output$plot <- renderPlotly({
    input$send
    isolate(getPlot())
  })
  
  # basically the same as plotly_json()
  output$spec <- renderJsonedit({
    input$send

    isolate({
      plotlyJSON <- plotly:::to_JSON(
        plotly_build(getPlot())$x
      )
      jsonedit(plotlyJSON, mode = "form")
    })
  })

}

shinyApp(ui, server, enableBookmarking = "url")
