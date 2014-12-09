library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Intro to Sampling Distributions and CLT"),
  
  sidebarPanel(
    helpText(HTML("<h3>Data source</h3>")),
    selectInput("data", "",
                c("Summer 2014 Midterm" = "Summer 2014 Midterm",
                  "Spring 2014 Sec E Final" = "Spring 2014 Final",
                  "Spring 2014 Sec E Exam 2" = "Spring 2014 Exam 2E",
                  "Spring 2014 Sec E Exam 1" = "Spring 2014 Exam 1E",
                  "Fall 2013 Sec D Exam 2" = "Fall 2013 Exam 2D",
                  "Fall 2013 Sec D Exam 1" = "Fall 2013 Exam 1D",
                  "Individual Birthdays" = "individual birthdays",
                  "Average Birthdays" = "average birthdays",
                  "Length of Rivers" = "rivers")),
    checkboxInput("sample", "Sample from 'Population'", value = FALSE),
    conditionalPanel(
      condition = "input.sample == true",
      HTML("<hr />"),
      sliderInput("n", "Sample size (n)", min=1, max=80, value=1, step=1, ticks=TRUE, animate=TRUE),
      HTML("<hr />"),
      HTML("x-axis limits"),
      uiOutput("xmin"),
      uiOutput("xmax"),
      HTML("<hr />"),
      HTML("binwidth"),
      numericInput("bin", "", 5)
    )
  ),
  
  mainPanel(
    plotOutput("sampDist", height = "600px"),
    HTML("<h3>Summary of Distribution:</h3>"),
    verbatimTextOutput("summary")
  )
  
))