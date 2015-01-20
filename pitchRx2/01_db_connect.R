library("dplyr")
# This app assumes you have a PITCHf/x database --
# https://baseballwithr.wordpress.com/2014/03/24/422/
# It also assumes you've sourced the other R scripts in this directory 
if (Sys.info()[["nodename"]] == "Carsons-MacBook-Pro.local") {
  db <- src_sqlite("~/pitchfx/pitchRx.sqlite3")
} else {
  db <- src_postgres(dbname = 'pitchfx',
                     user = 'postgres',
                     password = Sys.getenv("POSTGRES_PWD"),
                     port = '5432', host = "localhost")
}