library("pitchRx")
# Field names are passed to ui.R so the user can pick which ones they want
data(gids, package = "pitchRx")
data(players, package = "pitchRx")
player.names <- sort(players$full_name)
dates <- as.Date(substr(gids, 5, 14), format = "%Y_%m_%d")

shinyUI(fluidPage(
  tabsetPanel(id = "tabs",
    wellPanel(
      dateRangeInput('dateRange',
                     label = 'Select a date range:',
                     start = '2014-06-01', end = '2014-06-02',
                     min = min(dates), max = max(dates),
                     startview = 'year'),
      selectizeInput("game", "Choose a game:", 
                  choices = c("Any game" = "any", gids)),
      selectizeInput("pitcher", "Choose a pitcher:", 
                  choices = c("Any pitcher" = "any", player.names),
                  selected = "Mariano Rivera"),
      selectizeInput("batter", "Choose a batter:",
                  choices = c("Any batter" = "any", player.names)),
      br(),
      actionButton("query", "Send Query"), 
      br(),
      downloadButton('downloadData', 'Download')
    ),
    animintOutput("series")
  )
))

