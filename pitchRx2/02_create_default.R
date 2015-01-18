library("dplyr")
library("DBI")
library("magrittr")

db <- src_postgres(dbname = 'pitchfx',
                   user = 'postgres',
                   password = Sys.getenv("POSTGRES_PWD"),
                   port = '5432', host = "localhost")
default <- tbl(db, "pa") %>% filter(date >= "2011-01-01", date <= "2012-01-01") %>%
  filter(pitcher_name == "Mariano Rivera") %>%
  filter(pitch_type %in% c("FF", "FC"))
saveRDS(default, file = "default.rds")