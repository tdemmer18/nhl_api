library(tidyverse)
library(jsonlite)


nhl_api_schedule_url <- "https://statsapi.web.nhl.com/api/v1/schedule"
schedule <- fromJSON(nhl_api_schedule_url, flatten = TRUE)
nhl_todays_schedule <- schedule$dates$games[[1]]

today <- Sys.Date()

#write_csv(nhl_todays_schedule, path = paste0("~/rstats/hockey/nhl_api/csv/schedule/", today,"_nhl_schedule.csv"))
