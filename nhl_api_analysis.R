library(tidyverse)
library(readr)

my_data <- read_csv("~/rstats/hockey/nhl_api/csv/2018_2019/all_games_through_2019-02-15.csv")



eichel <- my_data %>%
  filter(playerName == "Jack Eichel")

View(eichel)


sum(eichel$goals)


player_summary <- my_data %>%
  group_by(playerName) %>%
  summarise(total_pts = sum(goals, assists)) %>%
  arrange(desc(total_pts)) %>%
  top_n(50) %>%
  View()
