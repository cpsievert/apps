data(gids, package = "pitchRx")
dates <- as.Date(substr(gids, 5, 14), format = "%Y_%m_%d")

shinyUI(fluidPage(
  column(2,
         dateRangeInput('dateRange',
                        label = 'Select a date range:',
                        start = '2014-06-01', end = '2014-06-02',
                        min = min(dates), max = max(dates),
                        startview = 'year'),
         selectizeInput("game", "Choose a game:", choices = NULL),
         selectizeInput("pitcher", "Choose a pitcher:", choices = NULL),
         selectizeInput("batter", "Choose a batter:", choices = NULL),
         br(),
         actionButton("query", "Send Query"), 
         br(),
         textOutput("summery")
  ),
  column(10, animint::animintOutput("series"))
))