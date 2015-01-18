library("dplyr")
library("DBI")
library("pitchRx")
library("animint")

# This app is meant to run on Carson Sievert's machine,
# but you _could_ run this locally by changing this bit to connect
# to your own database. For instance: db <- src_sqlite("~/pitchRx.sqlite3")
db <- src_postgres(dbname = 'pitchfx',
                  user = 'postgres',
                  password = Sys.getenv("POSTGRES_PWD"),
                  port = '5432', host = "localhost")

# Field names are passed to ui.R so the user can pick which ones they want
data(gids, package = "pitchRx")
data(players, package = "pitchRx")
player.names <- sort(players$full_name)
# NOTE TO SELF: Have the app update the database as a nightly CRON job!
dates <- as.Date(substr(gids, 5, 14), format = "%Y_%m_%d")

# --------------------------------------------------------
# Most of the code below is an effort to 'cache' some computations 
# in effort to speed up the app. First , I added a few new fields 
# that don't come standard in the atbat table
# --------------------------------------------------------
# atbat <- tbl(db, "atbat")
# atbat2 <- mutate(atbat, away_team = substr(gameday_link, 16L, 3L),
#                  away_league = substr(gameday_link, 19L, 3L),
#                  home_team = substr(gameday_link, 23L, 3L),
#                  home_league = substr(gameday_link, 26L, 3L))
# compute(atbat2, name = "atbat2", temporary = FALSE)
# dbRemoveTable(db$con, name = 'atbat')
# dbSendQuery(db$con, 'ALTER TABLE atbat2 RENAME TO atbat')

# --------------------------------------------------------
# Add appropriate indicies to the db
# --------------------------------------------------------
# db_create_index(db$con, "pitch", "num", "pitch_num")
# db_create_index(db$con, "pitch", "gameday_link", "pitch_gameday_link")
# db_create_index(db$con, "atbat", "num", "atbat_num")
# db_create_index(db$con, "atbat", "gameday_link", "atbat_gameday_link")
# db_create_index(db$con, "atbat", "date", "atbat_date")
# db_create_index(db$con, "atbat", "batter_name", "atbat_batter_name")
# db_create_index(db$con, "atbat", "pitcher_name", "atbat_pitcher_name")
# db_create_index(db$con, "atbat", "away_team", "atbat_away_team")
# db_create_index(db$con, "atbat", "home_team", "atbat_home_team")
# db_create_index(db$con, "atbat", "away_league", "atbat_away_league")
# db_create_index(db$con, "atbat", "home_league", "atbat_home_league")


# --------------------------------------------------------
# Save team/player names
# --------------------------------------------------------
# home.teams <- dbGetQuery(db$con, "SELECT DISTINCT home_name_abbrev,home_team_name 
#                                   FROM game
#                                   WHERE home_team_name != 'NA'")
# home_teams <- with(home.teams, setNames(home_team_name, home_name_abbrev))
# saveRDS(home_teams, file = "home_teams.rds") # note you should be in the pitchRx-db directory!
# away.teams <- dbGetQuery(db$con, "SELECT DISTINCT away_name_abbrev,away_team_name 
#                                   FROM game
#                                   WHERE away_team_name != 'NA'")
# away_teams <- with(away.teams, setNames(away_team_name, away_name_abbrev))
# saveRDS(away_teams, file = "away_teams.rds")

# should I update gids to include playoff games?
# pitcher_names <- dbGetQuery(db$con, "SELECT DISTINCT pitcher_name
#                                   FROM atbat
#                                   WHERE pitcher_name != 'NA'")[,1]
# saveRDS(pitcher_names, file = "away_teams.rds")