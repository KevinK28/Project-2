#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)
library(jsonlite)
library(tidyverse)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  getData <- eventReactive(input$submit, {
    req(input$submit)
    url <- paste0("https://api.data.gov/ed/collegescorecard/v1/schools?api_key=GviCF3d5mO0uCg5YLODClkYoWNdMdU7fd4h6jGgg&school.state=", input$state, "&per_page=50")
    data <- httr::GET(url)
    parsed <- fromJSON(rawToChar(data$content))
    collegeData <- as_tibble(parsed$results$school) |>
      select(-c("endowment", "minority_serving", "title_iv", "degrees_awarded", "institutional_characteristics"))
    return(collegeData)
  })
  
  output$stateText <- renderText({
    req(input$submit)
    paste("You want to look at the data from the first 50 schools in", input$state)
  })
  
  output$displayData <- renderTable({
    req(input$submit)
    getData()
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste0(input$state, "_college_data.csv")
    },
    content = function(file) {
      write.csv(getData(), file)
    }
  )
  
  numSumdata <- eventReactive(input$numSum, {
    req(input$submit)
    req(input$numVariables)
    req(input$numSum)
    summaryVars <- select(getData(), all_of(input$numVariables))
    results <- sapply(summaryVars, summary)
    return(results)
  })

  output$numText <- renderText({
    req(input$numSum)
    paste("The numbers are as follows: Min, 1st Quartile, Median, Mean, 3rd Quartile,
          Max. and the Number of missing values")
  })
  
  output$numTable <- renderTable({
    req(input$numSum)
    numSumdata()
  })
  
  contingencyTables <- eventReactive(input$contSum, {
    req(input$catVars)
    req(input$contSum)
    
    variables <- select(getData(), all_of(input$catVars))
    variables[] <- lapply(variables, as.factor)
    tableData <- table(variables)
    
    return(tableData)
  })
  
  output$contTableOutput <- renderTable({
    req(input$contSum)
    contingencyTables()
  })
}
