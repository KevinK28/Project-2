#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("App for Exploring/Summarizing API Data"),

    # Sidebar with a slider input for number of bins
    tabsetPanel(
      tabPanel("State Selection",
               sidebarLayout(
                 sidebarPanel(
                   selectInput("state", h3("Select a State"),
                               choices = list("TX", "CA", "NY", "NC", "MA", "MI")),
                   actionButton("submit", "Choose State"),
                   downloadButton("downloadData", "Download CSV File")
                 ),
                 
                 # Show a plot of the generated distribution
                 mainPanel(
                   textOutput("State Selection")
                 )
               ),
               mainPanel(
                 textOutput("stateText"),
                 tableOutput("displayData"),
               )
    ),
    tabPanel("Data Exploration",
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput("numVariables", 
                                    "Choose Numeric Variables to Explore:",
                                    choices = list("faculty_salary",
                                                   "tuition_revenue_per_fte")),
                 actionButton("numSum", "Get Numerical summary"),
                 checkboxGroupInput("catVars", "Choose Categorical Variables for
                                    Contingency Table",
                                    choices = list("accreditor_code", "ownership", 
                                                   "open_admissions_policy")),
                 actionButton("contSum", "Generate Contingency Tables")
               ),
               mainPanel(
                 textOutput("Data Exploration")
               )
             ),
             mainPanel(
              textOutput("numText"),
              tableOutput("numTable"),
              tableOutput("contTableOutput")
             )
             
    )
  )
)
