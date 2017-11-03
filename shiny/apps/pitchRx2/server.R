library("dplyr")
library("tidyr")
library("animint")

# connect to remote database
source("01_db_connect.R")

# ----------------------------------------------------------------------------
# Convenience functions
# ----------------------------------------------------------------------------
source("getLocations.R")
# does the input have a valid value to search by?
is.valid <- function(x) length(nchar(x)) > 0

# ----------------------------------------------------------------------------
# "meta-data" used to populate input choices
# ----------------------------------------------------------------------------
data(players, package = "pitchRx")
player.names <- sort(players$full_name)
names(player.names) <- player.names

data(gids, package = "pitchRx")
dates <- as.Date(substr(gids, 5, 14), format = "%Y_%m_%d")
desc <- paste(toupper(substr(gids, 16, 18)), "@", toupper(substr(gids, 23, 25)))
names(gids) <- paste0(desc, " (", dates, ")")

# copy-pasted from pitchRx::strikeFX()
types <- c("SI", "FF", "IN", "SL", "CU", "CH", "FT", 
           "FC", "PO", "KN", "FS", "FA", NA, "FO")
names(types) <- c("Sinker", "Fastball (four-seam)", "Intentional Walk", "Slider", 
                  "Curveball", "Changeup", "Fastball (two-seam)", 
                  "Fastball (cutter)", "Pitchout", "Knuckleball", 
                  "Fastball (split-finger)", "Fastball", "Unknown", "Forkball")

# For drawing strikezones, let's just assume average batter height is 6 foot
# NOTE: could use pitchRx:::getStrikezones(), 
# but that would require the height variable and slow down the app
# From http://www.baseballprospectus.com/article.php?articleid=14572
# RHB zone: -1.03 < px < 1.00   AND
#   (0.92 + batter_height*0.136) < pz < (2.60 + batter_height*0.136)
# LHB zone: -1.20 < px < 0.81   AND 
# (0.35 + batter_height*0.229) < pz < (2.00 + batter_height*0.229)
zone <- data.frame(stand = c("R", "L"),
                   px_bottom = c(-1.03, -1.2),
                   px_top = c(1, 0.81),
                   pz_bottom = c(.92 + 6*0.136, .35 + 6*0.229),
                   pz_top = c(2.60 + 6*0.136, 2 + 6*0.229))

shinyServer(function(input, output, session) {
  
  # avoid sending *all* input choices to the client
  # http://shiny.rstudio.com/articles/selectize.html
  # http://stackoverflow.com/questions/19017219/update-selectinput-on-change-of-another-select-input
  observe({
    valid.gids <- gids[input$dateRange[1] <= dates & dates <= input$dateRange[2]]
    updateSelectizeInput(session, inputId = 'game', selected = input$game,
                         choices = valid.gids, server = TRUE)
    updateSelectizeInput(session, inputId = 'pitcher', selected = input$pitcher,
                         choices = player.names, server = TRUE)
    updateSelectizeInput(session, inputId = 'batter', selected = input$batter,
                         choices = player.names, server = TRUE)
    updateSelectizeInput(session, inputId = 'type', selected = input$type,
                         choices = types, server = TRUE)
  })
  
  retrieve <- reactive({
    # Filter data based on user criteria
    pa <- tbl(db, "pa") %>% filter(date >= input$dateRange[1], 
                                   date <= input$dateRange[2])
    # UGLYYYYY...I should report to Hadley
    if (is.valid(input$game)) {
      if (length(input$game) > 1) {
        pa <- filter(pa, gameday_link %in% input$game)
      } else {
        pa <- filter(pa, gameday_link == input$game)
      }
    }
    if (is.valid(input$pitcher)) {
      if (length(input$pitcher) > 1) {
        pa <- filter(pa, pitcher_name %in% input$pitcher)
      } else {
        pa <- filter(pa, pitcher_name == input$pitcher)
      }
    }
    if (is.valid(input$batter)) {
      if (length(input$batter) > 1) {
        pa <- filter(pa, batter_name %in% input$batter)
      } else {
        pa <- filter(pa, batter_name == input$batter)
      }
    }
    if (is.valid(input$type)) {
      if (length(input$type) > 1) {
        pa <- filter(pa, pitch_type %in% input$type)
      } else {
        pa <- filter(pa, pitch_type == input$type)
      }
    }
    N <- nrow(pa)
    # Throw informative error if query comes up empty
    validate(
      need(N > 0, "Your query returned no results. Please alter the criteria and try again."),
      need(N <= 5000, "You've requested too many records. Please add more criteria.")
    )
    pa
  })
  
  output$series <- renderAnimint({
    input$query
  
    isolate({
      withProgress({
        setProgress(message = "Building Query")
        pa <- retrieve()
        setProgress(value = 0.1, message = "Pulling Data into Memory")
        cpa <- collect(pa)
        setProgress(value = 0.5, message = "Computing pitch trajecories")
        dat <- getLocations(cpa, c("pitcher_name", "pitch_type"), summarise = TRUE)
        setProgress(value = 0.9, message = "Plotting results")
        
        # Build facet_grid expression and compute number of rows
        facet_pitcher <- length(input$pitcher) > 1
        facet_batter <- length(input$batter) > 1
        if (facet_pitcher && facet_batter) {
          facet_expr <- "pitcher_name + batter_name"
          nfacets <- cpa %>% select(pitcher_name, batter_name) %>% unique %>% nrow
        } else if (facet_pitcher) {
          facet_expr <- "pitcher_name"
          nfacets <- cpa %>% select(pitcher_name) %>% unique %>% nrow
        } else if (facet_batter) {
          facet_expr <- "batter_name"
          nfacets <- cpa %>% select(batter_name) %>% unique %>% nrow
        } else {
          facet_expr <- "."
          nfacets <- 1
        }
        facet_expr <- as.formula(paste0(facet_expr, "~stand"))
        # Finally, build plot
        p <- ggplot() + 
          geom_rect(data = zone, aes(xmin = px_bottom, xmax = px_top, 
                                     ymin = pz_bottom, ymax = pz_top), 
                    fill = "transparent", color = "black") +
          geom_point(aes(x = x, y = z, color = pitch_type, 
                         showSelected = frame), data = dat) + 
          facet_grid(facet_expr) + ylim(0, 7) + xlim(-3, 3) +
          coord_equal() + xlab("") + ylab("Height from ground") 
        plist <- list(strikezone = p + 
                        theme_animint(width = 1000, height = nfacets * 400),
                      # 'animate' over the frame variable
                      time = list(variable = "frame", ms = 100),
                      # use smooth transitions
                      duration = list(frame = 250))
        plist
      })
    })
  })
  
})