atbat_fields <- dbListFields(db$con, "atbat")
pitch_fields <- dbListFields(db$con, "pitch")
selected_fields <- c("pitcher_name", "p_throws", "batter_name", "stand", 
                     "pitch_type", "end_speed", "count", "px", "pz", "x0", 
                     "y0", "z0", "vx0", "vy0", "vz0", "ax", "ay", "az",
                     "gameday_link", "num")
home_teams <- readRDS(file = "home_teams.rds")
away_teams <- readRDS(file = "away_teams.rds")

shinyUI(fluidPage(
  titlePanel("PITCHf/x Database Interface"),
  
  column(4, wellPanel(
    dateRangeInput('dateRange',
                   label = 'Select a date range:',
                   start = '2014-06-01', end = '2014-06-02',
                   min = min(dates), max = max(dates),
                   startview = 'year'),
    selectInput("home_team", "Choose a home team:", choices = c("Any team" = "any", home_teams)),
    selectInput("away_team", "Choose an away team:", choices = c("Any team" = "any", away_teams)),
    selectInput("pitcher", "Choose a pitcher:", choices = c("Any pitcher" = "any", player.names),
                selected = "Mariano Rivera"),
    selectInput("batter", "Choose a batter:", choices = c("Any batter" = "any", player.names)),
    br(),
    checkboxGroupInput("fields", "Select variables of interest:", 
                       choices = c(pitch_fields, atbat_fields), 
                       selected = selected_fields),
    br(),
    actionButton("query", "Send Query"), 
    br(),
    downloadButton('downloadData', 'Download')
    )
  ),
  
  column(8,
         dataTableOutput("table")
  )
))

