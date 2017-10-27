library("dplyr")
library("DBI")
library("magrittr")

# connect to remote database
source("01_db_connect.R")

# From the default tables, create a table with 
# relevant attributes on both atbat/pitch level.
# This saves us the repeating the expensive operation of joining tables
if (!dbExistsTable(db$con, "pa_full")) {
  pa_full <- tbl(db, "pitch") %>% 
    left_join(tbl(db, "atbat"), by = c("num", "gameday_link"))
  compute(pa_full, name = "pa_full", temporary = FALSE)
}
if (!dbExistsTable(db$con, "pa")) {
  pa <- tbl(db, "pa_full") %>% 
    select(pitcher_name, batter_name, gameday_link, date, pitch_type, stand, x0:az) %>%
    na.omit
  compute(pa, name = "pa", temporary = FALSE)
}

# search parameters that need to be indexed
ind <- c("pitcher_name", "batter_name", "gameday_link", "date", "pitch_type", "stand")
create_index <- function(x) {
  y <- paste(x, collapse = "_")
  z <- paste(x, collapse = ", ")
  dbSendQuery(db$con, paste0('CREATE INDEX pa_', y, ' ON pa(', z, ')'))
}
# create all single column indexes
lapply(ind, create_index)
# create all possible multi-column indexes
for (i in seq.int(2, length(ind))) {
  apply(combn(ind, i), 2, create_index)
}
