

shinyServer(function(input, output, session) {
  
  output$table <- renderDataTable({
    # When input$query changes, this code will re-execute -- http://shiny.rstudio.com/gallery/isolate-demo.html
    input$query
    
    # isolate() means that when input$whatever changes, this code won't re-execute until input$query does
    isolate({
      # Both dplyr and shiny use non-standard evaluation -- https://groups.google.com/forum/#!topic/manipulatr/jESTCrOn7hI
      # For this reason, we create 'extra' objects for inputs
      start.date <- gsub("_", "-", as.character(input$dateRange[1]))
      end.date <- gsub("_", "-", as.character(input$dateRange[2]))
      pitcher.name <- input$pitcher
      batter.name <- input$batter
      home.team <- input$home_team
      away.team <- input$away_team
      field.names <- input$fields
      atbats <- tbl(db, "atbat")
      atbats <- filter(atbats, date >= start.date, date <= end.date)
      if (home.team != "any") atbats <- filter(atbats, home_team == home.team)
      if (away.team != "any") atbats <- filter(atbats, away_team == away.team)
      if (pitcher.name != "any") atbats <- filter(atbats, pitcher_name == pitcher.name)
      if (batter.name != "any") atbats <- filter(atbats, batter_name == batter.name)
      query <- inner_join(tbl(db, "pitch"), atbats, by = c('num', 'gameday_link'))
      queried <<- collect(query)
      queried[, field.names]
    })
  })
  
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste0("queried.csv")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      # Write to a file specified by the 'file' argument
      write.csv(queried, file, row.names = FALSE)
    }
  )
  
  
})

