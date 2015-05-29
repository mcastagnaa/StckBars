shinyUI(fluidPage(
  titlePanel("CEO report - core"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput("Date1",
                label = h3("Pick a date"),
                choices = AllDates$RefDate,
                #selected = max(AllDates$RefDate),
                multiple = FALSE,
                selectize = FALSE,
                width = NULL,
                size = 3
                )
      ), 
    mainPanel("Quartile percentages",
              plotOutput("quartPerc"))
    )
  ))

