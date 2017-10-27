library(shiny)
library(shinyRGL)

# This app assumes one already has PITCHf/x data available to visualize (or wants to use sample data)
shinyUI(pageWithSidebar(
  
  headerPanel("PITCHf/x Database Interface"),
  
  sidebarPanel(  
    helpText(HTML("<h3>Data Query</h3>")),
    selectInput("home_team", "Choose a home team", choices = c("Any team" = "any", home.teams),
                selected = c("Reds" = "CIN")),
    selectInput("away_team", "Choose an away team", choices = c("Any team" = "any", away.teams),
                selected = c("Reds" = "CIN")),
    checkboxGroupInput("year", "Select one (or more) years:", )
    conditionalPanel(
      condition = "input.tabs == '3D Scatterplot'",
      #helpText(HTML("<h3>Interactive View</h3>")),
      uiOutput("pitcher"),
      HTML("<hr />"),
      checkboxInput("avgby", "Average over pitch types", TRUE),
      HTML("<hr />"),
      sliderInput("alpha", "Transparency of points", min=0, max=1, value=.5),
      HTML("<hr />"),
      sliderInput("interval", "Time interval between 'snapshots'", min=0.001, max=.05, value=.01),
      HTML("<hr />"),
      checkboxInput("spheres", "Plot spheres?", TRUE)
    ),
    conditionalPanel(
      condition = "input.tabs == '2D Scatterplot'",
      #helpText(HTML("<h3>Strike-zone View</h3>")),
      
      helpText(HTML("<h3>Axis Settings</h3>")),
      numericInput("xmin", "x-axis minimum:", -3.5),
      numericInput("xmax", "x-axis maximum:", 3.5),
      numericInput("ymin", "y-axis minimum", 0),
      numericInput("ymax", "y-axis maximum", 7),
      checkboxInput("coord.equal", strong("Preserve Plotting Persepective"), TRUE),
      helpText(HTML("<h3>Facetting</h3>")),
      selectInput("facet1", "Column-wise Split:", 
                  choices = c("stand", "pitch_type", "pitcher_name", "top_inning", "No facet", "Enter my own")),
      conditionalPanel(
        condition = "input.facet1 == 'Enter my own'",
        textInput("facet1custom", "Type variable name here:", " ")
      ),
      selectInput("facet2", "Row-wise Split:", 
                  choices = c("No facet", "pitch_type", "pitcher_name", "top_inning", "Enter my own")),
      conditionalPanel(
        condition = "input.facet2 == 'Enter my own'",
        textInput("facet2custom", "Type variable name here:", " ")
      ),
      HTML("<hr />"),
      helpText(HTML("<h3>Plotting Geometries</h3>")),
      radioButtons("geom", "",
                   c("point" = "point", 
                     "tile" = "tile",
                     "hex" = "hex",
                     "bin" = "bin")),
      wellPanel(
        conditionalPanel(
          condition = "input.geom == 'point'",
          uiOutput("pointColor"),
          sliderInput("point_alpha", "Alpha (transparency):",
                      min = 0, max = 1, value = 0.5, step = 0.1),
          sliderInput("point_size", "Size:",
                      min = 0.5, max = 8, value = 5, step = 0.5),
          checkboxInput("point_contour", strong("Add contour lines"), FALSE),
          conditionalPanel(
            condition = "input.tabs == '2D Scatterplot'",
            checkboxInput("point_adjust", strong("Adjust vertical locations to aggregate strikezone"), TRUE)
          )
        ),
        conditionalPanel(
          condition = "input.tabs == '2D Scatterplot'",
          conditionalPanel(
            condition = "input.geom == 'tile'",
            checkboxInput("tile_contour", strong("Add contour lines"), FALSE),
            checkboxInput("tile_adjust", strong("Adjust vertical locations to aggregate strikezone"), TRUE)
          ),
          conditionalPanel(
            condition = "input.geom == 'hex'",
            checkboxInput("hex_contour", strong("Add contour lines"), FALSE),
            sliderInput("hex_xbin", "Hex Width:",
                        min = 0.1, max = 3, value = 0.25, step = 0.05),
            sliderInput("hex_ybin", "Hex Height:",
                        min = 0.1, max = 3, value = 0.25, step = 0.05),
            checkboxInput("hex_adjust", strong("Adjust vertical locations to aggregate strikezone"), TRUE)
          ),
          conditionalPanel(
            condition = "input.geom == 'bin'",
            checkboxInput("bin_contour", strong("Add contour lines"), FALSE),
            sliderInput("bin_xbin", "Bin Width:",
                        min = 0.1, max = 3, value = 0.25, step = 0.05),
            sliderInput("bin_ybin", "Bin Height:",
                        min = 0.1, max = 3, value = 0.25, step = 0.05),
            checkboxInput("bin_adjust", strong("Adjust vertical locations to aggregate strikezone"), TRUE)
          )
        ),
        #panel for density geometries
        conditionalPanel( 
          condition = "input.geom == 'bin' || input.geom == 'hex' || input.geom == 'tile'",
          helpText(HTML("<h3>Alter Density(ies)</h3>")),
          uiOutput("denVar1"),
          conditionalPanel(
            condition = "input.denVar1 != 'None'",
            uiOutput("vals1")
          ),
          uiOutput("denVar2"),
          conditionalPanel(
            condition = "input.denVar2 != 'None'",
            uiOutput("vals2")
          )
        )
      )
    )
  ),
  
  #Main panel with static (strikezone) plot and download button
  mainPanel(
    tabsetPanel(id="tabs",
                tabPanel("3D Scatterplot", webGLOutput("myWebGL")),
                tabPanel("2D Scatterplot", HTML("<div class=\"span8\">
                                                <a id=\"downloadPlot\" class=\"btn shiny-download-link\" target=\"_blank\">Download Current Plot</a>
                                                <div id=\"staticPlot\" class=\"shiny-plot-output\" style=\"position:fixed ; width: 60% ; height: 80%\">
                                                </div>
                                                </div>"))
                
                )
                )
  
  
  ))