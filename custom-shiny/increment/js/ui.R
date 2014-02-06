incrementButton <- function(inputId, value = 0) {
  tagList(
    singleton(tags$head(tags$script(src = "js/increment.js"))),
    tags$button(id = inputId,
                class = "increment",
                type = "button",
                as.character(value))
  )
}

shinyUI(bootstrapPage(
	incrementButton("increment", 5)
))