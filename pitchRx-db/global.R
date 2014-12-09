library(pitchRx)
library(dplyr)
library(DBI)

data(gids, package = "pitchRx")
data(players, package = "pitchRx")
player.names <- sort(players$full_name)
dates <- as.Date(substr(gids, 5, 14), format = "%Y_%m_%d")
# IDEA: Have the app update the database as a nightly CRON job!
# Then, determine 'valid' games based on Sys.Date()
# For now, we'll just restrict to anything before 2014
valid.dates <- dates[dates <= as.Date("2014/01/01")]
#valid.years <- substr(valid.dates, 0, 4)
#valid.months <- substr(valid.dates, 6, 7)
#valid.days <- substr(valid.dates, 9, 10)

# Used to subset game IDs after user picks a team
#team.away <- substr(gids, 16, 18)
#league.away <- substr(gids, 19, 21)
#team.home <- substr(gids, 23, 25)
#league.home <- substr(gids, 26, 28)



# Grab unique, non-NA records from a table
unique_cases <- function(tbl, ...) {
  tb <- collect(select(tbl, ...))
  utb <- unique(tb)
  utb[complete.cases(utb), ]
}

# These will be used to help populate selectInput() for choosing home/away teams
db <- src_sqlite("pitchRx.sqlite3")
games <- tbl(db, "game")
home.teams <- unique_cases(games, home_name_abbrev, home_team_name)
away.teams <- unique_cases(games, away_name_abbrev, away_team_name)

# selectInput's choices argument takes named character vector
home.teams <- setNames(home.teams$home_name_abbrev, home.teams$home_team_name)
away.teams <- setNames(away.teams$away_name_abbrev, away.teams$away_team_name)

# create new columns to make it easier to subset by home/away team
atbats <- tbl(db, "atbat")
atbat.fields <- dbListFields(db$con, "atbat")
atbats <- mutate(atbats, away_team = substr(gameday_link, 19L, -3L),
                      home_team = substr(gameday_link, 26L, -3L))

pitches <- tbl(db, "pitch")
pitch.fields <- dbListFields(db$con, "pitch")
