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
      tabPanel("About",
               tags$div(
                 h2("College API Shiny App"),
                 p("Welcome to my R shiny app that I have created for ST-558 at NCSU.
                   This app will allow you to explore and summarize college data across
                   6 different states (Texas, California, New York, North Carolina,
                   Massachusetts, and Michigan"),
                 p("The data comes from the College Scorecard API, and for this app, we
                   will look at their school-specific data. This includes many variables
                   related to location, faculty, ownership, etc. If you would like to
                   look more into this data, here is a link to the API's website ",
                   a(href = "https://collegescorecard.ed.gov/data/api/", "College
                     Scorecard"), "."),
                 p("In the State Selection tab, this will be where you select which
                   state's data you would like to look at. There will be a drop down tab
                   where you can select one of the six states. After selecting a state
                   and clicking the Select State button, you will be able to see not only
                   the data from that state, but you can also download the data as a csv
                   file."),
                 p("In the Data Exploration tab, this is where you will get the chance to
                   look at some of the numerical/categorical variables in the dataset.
                   For the numerical variables, you will get to see numerical summeries
                   as well as scatter plots detailing that varaible for each school. For
                   the categorical variables, you will see contingency tables and bar
                   plots. You will also be able to look at combinations of numerical and
                   categorical varibles to do more deep diving exploration"),
                 p("I hope you enjoy this app, and start exploring!")
               )),
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
                 selectInput("plotNum", "Choose Numeric Variable to Plot",
                             choices = list("faculty_salary", 
                                            "tuition_revenue_per_fte")),
                 actionButton("numPlotSum", "Plot Numerical Variable"),
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
              plotOutput("scatterPlots"),
              tableOutput("contTableOutput")
            )
             
    )
  )
)
