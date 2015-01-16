atbats <- tbl(db, "atbat")
pitches <- tbl(db, "pitch")

shinyServer(function(input, output, session) {
  
  retrieve <- reactive({
    # Both dplyr and shiny use non-standard evaluation -- https://groups.google.com/forum/#!topic/manipulatr/jESTCrOn7hI
    # For this reason, we create 'extra' objects for inputs
    start.date <- gsub("_", "-", as.character(input$dateRange[1]))
    end.date <- gsub("_", "-", as.character(input$dateRange[2]))
    pitcher.name <- input$pitcher
    batter.name <- input$batter
    home.team <- input$home_team
    away.team <- input$away_team
    atbats <- tbl(db, "atbat")
    atbats <- filter(atbats, date >= start.date, date <= end.date)
    if (home.team != "any") atbats <- filter(atbats, home_team == home.team)
    if (away.team != "any") atbats <- filter(atbats, away_team == away.team)
    if (pitcher.name != "any") atbats <- filter(atbats, pitcher_name == pitcher.name)
    if (batter.name != "any") atbats <- filter(atbats, batter_name == batter.name)
    return(inner_join(pitches, atbats, ))
  })
  
  output$table <- renderDataTable({
    # When input$query changes, this code will re-execute -- http://shiny.rstudio.com/gallery/isolate-demo.html
    input$query
    
    # isolate() means that when input$whatever changes, this code won't re-execute until input$query does
    isolate({
      # Retrieve just the first 50 records to expedite display of large queries
      table.dat <- head(retrieve(), 50L)
      field.names <- input$fields
      table.dat[, field.names]
    })
  }, options = list(iDisplayLength = 50))
  
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste0("pitchRx_", format(Sys.time(), "%Y-%m-%d_%H:%M:%S"), ".csv")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      # This might take awhile depending on the query
      # Is there a better solution than this? http://stackoverflow.com/questions/21425662/is-there-a-way-to-prevent-the-download-page-from-opening-in-r-shiny
      write.csv(collect(retrieve()), file, row.names = FALSE)
    }
  )
  
  
})

