library("dplyr")
library("DBI")
library("magrittr")

db <- src_postgres(dbname = 'pitchfx',
                  user = 'postgres',
                  password = Sys.getenv("POSTGRES_PWD"),
                  port = '5432', host = "localhost")

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