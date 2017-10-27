library("dplyr")
library("DBI")
library("magrittr")

# connect to remote database
source("01_db_connect.R")

default <- tbl(db, "pa") %>% filter(date >= "2011-01-01", date <= "2012-01-01") %>%
  filter(pitcher_name == "Mariano Rivera") %>%
  filter(pitch_type %in% c("FF", "FC")) %>% 
saveRDS(default, file = "default.rds")