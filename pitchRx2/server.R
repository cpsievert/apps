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

# https://gist.github.com/cpsievert/da555f08f3c9ba2c0b8e
getLocations <- function(dat, ..., summarise = TRUE) {
  # select and group by columns specified in ...
  tb <- dat %>%
    select(..., x0:az) %>%
    group_by(...)
  vars <- as.character(attr(tb, "vars"))
  if (summarise) {
    # average the PITCHf/x parameters over variables specified in ...
    labs <- attr(tb, "labels")
    tb <- tb %>% summarise_each(funs(mean))
  } else {
    # another (more complex way to get variables names)
    # vars <- as.character(as.list(match.call(expand.dots = FALSE))$...)
    dat$pitch_id <- seq_len(dim(dat)[1])
    vars <- c(vars, "pitch_id")
    labs <- dat[vars]
  }
  # returns 3D array of locations of pitches over time
  value <- getSnapshots(as.data.frame(tb))
  idx <- labs %>% unite(id, ..., sep = "@&")
  dimnames(value) <- list(idx = idx[, 1],
                          frame = seq_len(dim(value)[2]),
                          coordinate = c("x", "y", "z"))
  # tidy things up in a format that ggplot would expect
  value %>% as.tbl_cube %>% as.data.frame %>% rename_(value = ".") %>%
    separate(idx, vars, sep = "@&") %>%
    spread(coordinate, value)
} 

shinyServer(function(input, output, session) {
  
  retrieve <- isolate({
    # Both dplyr and shiny use non-standard evaluation -- https://groups.google.com/forum/#!topic/manipulatr/jESTCrOn7hI
    # For this reason, we create 'extra' objects for inputs
    start.date <- gsub("_", "-", as.character(input$dateRange[1]))
    end.date <- gsub("_", "-", as.character(input$dateRange[2]))
    pitcher.name <- input$pitcher
    batter.name <- input$batter
    batter.name <- input$batter
    pa <- tbl(db, "pa") %>% filter(date >= start.date, date <= end.date)
    if (game != "any") pa <- filter(pa, gameday_link %in% game)
    if (pitcher.name != "any") pa <- filter(pa, pitcher_name %in% pitcher.name)
    if (batter.name != "any") pa <- filter(pa, batter_name %in% batter.name)
    pa
  })
  
  # maximum allowed # of records
  threshold <- 5000
  pa <- retrieve() 
  restricted <- nrow(pa) >= threshold
  pa <- pa %>% top_n(threshold)
  # add a progress bar for this?
  cpa <- collect(pa)
  
  output$summery <- renderPrint({
    if (restricted) {
      warning(paste0("You've requested more than", threshold, " records.
               Only the first 5000 records will be returned."))
    }
    summary(cpa)
  })
  
  output$series <- renderAnimint({
    p <- ggplot() + 
      geom_point(aes(x = x, y = z, color = pitch_type, 
                     showSelected = frame), data = cpa) + 
      facet_grid(. ~ pitcher_name) + ylim(0, 7) + xlim(-3, 3) +
      coord_equal() + xlab("") + ylab("Height from ground") 
    plist <- list(strikezone = p + theme_animint(width = 800),            
                  # 'animate' over the frame variable
                  time = list(variable = "frame", ms = 100),
                  # use smooth transitions
                  duration = list(frame = 250))
    plist
  })
  
})