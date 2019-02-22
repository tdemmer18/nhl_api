library(tidyverse)

source("~/rstats/hockey/nhl_api/nhl_schedule_20182019.R")
all_games_2019_02_22 <- read_csv("~/rstats/hockey/nhl_api/csv/all_games_through_2019-02-22.csv")

nhl_20182019_game_schedule <- nhl_20182019_game_schedule %>%
  rename(game_id = gamePk)

nhl_20182019_game_schedule

all_games_with_dates <- all_games_2019_02_22 %>%
  left_join(nhl_20182019_game_schedule, by = "game_id")

write_csv(all_games_with_dates, "~/rstats/hockey/nhl_api/csv/all_games_with_dates.csv")

View(all_games_with_dates)
