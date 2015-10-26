bootstrapPage(
  selectizeInput(
    inputId = 'name', 
    label = 'Enter a name', 
    choices = unique(topnames$name),
    selected = "James",
    multiple = TRUE
  ),
  plotOutput('plot')
)
