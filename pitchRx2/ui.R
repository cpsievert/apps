data(gids, package = "pitchRx")
dates <- as.Date(substr(gids, 5, 14), format = "%Y_%m_%d")

shinyUI(fluidPage(
  column(4,
    wellPanel(
         dateRangeInput('dateRange',
                        label = 'Select a date range:',
                        start = '2011-01-01', end = '2012-01-01',
                        min = min(dates), max = max(dates),
                        startview = 'year'),
         selectizeInput("game", "Choose game(s):", 
                        choices = NULL, multiple = TRUE, 
                        options = list(placeholder = 'All games')),
         selectizeInput("pitcher", "Choose pitcher(s):", 
                        choices = c("Mariano Rivera" = "Mariano Rivera",
                                    "Phil Hughes" = "Phil Hughes"),
                        selected = c("Mariano Rivera", "Phil Hughes"), 
                        multiple = TRUE,
                        options = list(placeholder = 'All pitchers')),
         selectizeInput("batter", "Choose batter(s):", 
                        choices = NULL, multiple = TRUE, 
                        options = list(placeholder = 'All batters')),
         selectizeInput("type", "Choose pitch type(s):", 
                        choices = c("Four-Seam Fastball" = "FF",
                                    "Cutting Fastball" = "FC"),
                        selected = c("FF", "FC"), multiple = TRUE,
                        options = list(placeholder = 'All types')),
         br(),
         actionButton("query", "Send Query")
    )
  ),
  column(10, animint::animintOutput("series"))
))