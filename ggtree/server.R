library(shiny)
library(ggplot2)
library(shinyAce)

# recursive approach! http://stackoverflow.com/questions/12818864/how-to-write-to-json-with-children-from-r
makeList <- function(x){
  if (ncol(x) > 2){
    listSplit <- split(x[-1], x[1], drop=T)
    lapply(names(listSplit), function(y){list(name = y, children = makeList(listSplit[[y]]))})
  } else{
    lapply(seq(nrow(x[1])), function(y){list(name = x[,1][y], value = x[,2][y])})
  }
}


gg2tree <- function(gg) {
  built <- ggplot_build(gg)
  # thanks Jeroen http://stackoverflow.com/questions/19734412/flatten-nested-list-into-1-deep-list
  renquote <- function(l) if (is.list(l)) lapply(l, renquote) else enquote(l)
  la <- lapply(unlist(renquote(built)), eval)
  # capture the output of the list values as one long character string
  vals <- lapply(la, function(x) paste(utils::capture.output(x), collapse = "<br>"))
  #names(vals) <- gsub("\\.", "_", names(vals))
  # preallocate matrix
  lvls <- strsplit(names(vals), "\\.")
  d <- max(sapply(lvls, length)) #maximum depth of the list
  m <- matrix(NA, nrow = length(lvls), ncol = d)
  for (i in seq_len(d)) m[,i]  <- sapply(lvls, function(x) x[i])
  m <- data.frame(m, value = as.character(vals))
  list(name = "ggplot", children = makeList(m))
}

shinyServer(function(input, output, session) {
  
  output$ggplot <- renderPlot({
    input$send
    
    isolate({
      p <- eval(parse(text = input$code))
      print(p)
    })
    
  })
  
  output$dat <- reactive({
    input$send
    
    isolate({
      p <- eval(parse(text = input$code))
      return(gg2tree(p))
    })
    
  })
  
  output$console <- renderPrint({
    input$send
    
    isolate({
      p <- eval(parse(text = input$code))
      return(gg2tree(p))
    })
    
  })
  
})