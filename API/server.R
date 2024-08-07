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
    results <- summary(summaryVars)
    return(results)
  })
  
  output$numTable <- renderTable({
    req(input$numSum)
    numSumdata()
  })
  
  plotNumVars <- reactive({
    req(input$numPlotSum)
    req(input$plotNum)
    data <- getData()
    plotData <- data |>
      select("name", !!sym(input$plotNum)) |>
      arrange(!!sym(input$plotNum)) |>
      na.omit()
    
    return(plotData)
  })
  
  output$scatterPlots <- renderPlot({
    req(plotNumVars())
    scatterData <- plotNumVars()
    yVar <- as.character(input$plotNum)
    ggplot(scatterData, aes_string(x = "name", y = yVar)) +
      geom_point() +
      labs(x= "School Name", y = input$plotNum, title = paste("Scatter Plot for",
                                                             input$plotNum) ) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
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
  
  plotCatVars <- reactive({
    req(input$catPlots)
    req(input$barPlotSum)
    data <- getData() |>
      select(!!sym(input$catPlots)) |>
      na.omit() |>
      mutate(across(everything(), as.factor))
  })
  
  output$barPlots <- renderPlot({
    req(plotCatVars())
    barData <- plotCatVars()
    xVar <- colnames(barData)
    xlab <- as.character(input$catPlots)
    ggplot(barData, aes_string(x = xVar)) +
      geom_bar() +
      labs(x = xlab, y = "Count", title = paste("Bar Plot for", input$catPlots))
  })
}
