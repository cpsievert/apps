library("dplyr")
library("DBI")
library("magrittr")

# This script assumes a PITCHf/x database created using this method --
# https://baseballwithr.wordpress.com/2014/03/24/422/
db <- src_postgres(dbname = 'pitchfx',
                  user = 'postgres',
                  password = Sys.getenv("POSTGRES_PWD"),
                  port = '5432', host = "localhost")

# From the default tables, create a table with attributes on both atbat/pitch level
# This saves us the repeating the expensive operation of joining tables
pa_full <- tbl(db, "pitch") %>% 
  left_join(tbl(db, "atbat"), by = c("num", "gameday_link"))
compute(pa_full, name = "pa_full", temporary = FALSE)
pa <- pa_full %>% 
  select(pitcher_name, batter_name, gameday_link, date, pitch_type, x0:az) %>%
  na.omit
compute(pa, name = "pa", temporary = FALSE)

fields <- dbListFields(db$con, "pa")
for (i in fields) {
  dbSendQuery(db$con, paste0('CREATE INDEX pa', i, '_date ON pa(', i, ')'))
}