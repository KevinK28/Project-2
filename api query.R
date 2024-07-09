library(httr)
library(jsonlite)
library(tidyverse)

url <- "https://api.data.gov/ed/collegescorecard/v1/schools?api_key=GviCF3d5mO0uCg5YLODClkYoWNdMdU7fd4h6jGgg&school.state="
full_url <- paste0(url, "TX", "&per_page=50")
data <- httr::GET(full_url)
parsed <- fromJSON(rawToChar(data$content))
collegeData <- as_tibble(parsed$results$school) |>
  select(-c("endowment", "minority_serving", "title_iv", "degrees_awarded", "institutional_characteristics"))
  
colnames(collegeData)

URL_news <- "https://newsapi.org/v2/everything?q=tesla&from=2024-06-25&apiKey=de938e3dab06485f95610e066abe3773"

data <- httr::GET(URL_news)

parsed <- fromJSON(rawToChar(data$content))
data <- as_tibble(parsed$articles)
data
content(data)
summaryVars <- select(collegeData, c("ownership", "accreditor_code"))
numVars <- select(collegeData, c("faculty_salary", "tuition_revenue_per_fte"))

summary(summaryVars)
results <- as.data.frame(lapply(numVars, summary))
results

summaryVars[] <- lapply(summaryVars, as.factor)
table(summaryVars)
