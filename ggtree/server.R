library(shiny)
library(ggplot2)
library(shinyAce)

# recursive approach! http://stackoverflow.com/questions/12818864/how-to-write-to-json-with-children-from-r
makeList <- function(x) {
  idx <- is.na(x[,2])
  if (ncol(x) > 2 && sum(idx) != nrow(x)){
    listSplit <- split(x[-1], x[1], drop=T)
    lapply(names(listSplit), function(y){list(name = y, children = makeList(listSplit[[y]]))})
  } else {
    nms <- x[,1]
    lapply(seq_along(nms), function(y){list(name = nms[y], value = x[,"value"][y])})
  }
}

# thanks Jeroen http://stackoverflow.com/questions/19734412/flatten-nested-list-into-1-deep-list
renquote <- function(l) if (is.list(l)) lapply(l, renquote) else enquote(l)

gg2tree <- function(gg) {
  la <- lapply(unlist(renquote(gg)), eval)
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
      print(eval(parse(text = input$code)))
    })
  })
  
  output$d3 <- reactive({
    input$send
    isolate({
      p <- eval(parse(text = input$code))
    })
    return(list(root = gg2tree(p), layout = input$d3layout))
  })
  
  
  output$console <- renderPrint({
    input$send
    
    isolate({
      p <- eval(parse(text = input$code))
      return(gg2tree(p))
    })
    
  })
  
})