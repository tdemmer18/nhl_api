library(tidyverse)
library(jsonlite)
library(purrr)

########## FUNCTION TO GET ALL NHL BOX SCORES BASED ON SPECIFIED GAME RANGE ##########

nhlBoxScore <- function(game_id) {
  json_url <- paste0("https://statsapi.web.nhl.com/api/v1/game/", game_id,"/boxscore")
  game <- fromJSON(json_url, flatten = TRUE)
  game_boxscore_all <- data.frame()
  game_number <- as.data.frame(game_id)

  home_team_length <- 1:length(game$teams$home$players)

  home_team_df <- data.frame()
  for (i in 1:length(home_team_length)) {

    home_player_id <- as.data.frame(game$teams$home$players[[i]]$person$id) %>%
      rename(id = "game$teams$home$players[[i]]$person$id")
    home_player_name <- as.data.frame(game$teams$home$players[[i]]$person$fullName) %>%
      rename(playerName = "game$teams$home$players[[i]]$person$fullName")
    home_team <- as.data.frame(game$teams$home$team$name) %>%
      rename(team = "game$teams$home$team$name")
    home_team_opp <- as.data.frame(game$teams$away$team$name) %>%
      rename(opp = "game$teams$away$team$name")
    home_player_position <- as.data.frame(game$teams$home$players[[i]]$position$abbreviation) %>%
      rename(position = "game$teams$home$players[[i]]$position$abbreviation")
    home_players <- as.data.frame(game$teams$home$players[[i]]$stats$skaterStats)
    home_player_stats <- c(game_number, home_player_id, home_player_name, home_team, home_team_opp, home_player_position, home_players)
    home_team_df <- bind_rows(home_team_df, home_player_stats) %>%
      filter(!position %in% c("N/A", "G"))
  }

  away_team_length <- 1:length(game$teams$away$players)

  away_team_df <- data.frame()
  for (i in 1:length(away_team_length)) {
    away_player_id <- as.data.frame(game$teams$away$players[[i]]$person$id) %>%
      rename(id = "game$teams$away$players[[i]]$person$id")
    away_player_name <- as.data.frame(game$teams$away$players[[i]]$person$fullName) %>%
      rename(playerName = "game$teams$away$players[[i]]$person$fullName")
    away_team <- as.data.frame(game$teams$away$team$name) %>%
      rename(team = "game$teams$away$team$name")
    away_team_opp <- as.data.frame(game$teams$home$team$name) %>%
      rename(opp = "game$teams$home$team$name")
    away_player_position <- as.data.frame(game$teams$away$players[[i]]$position$abbreviation) %>%
      rename(position = "game$teams$away$players[[i]]$position$abbreviation")
    away_players <- as.data.frame(game$teams$away$players[[i]]$stats$skaterStats)
    away_player_stats <- c(game_number, away_player_id, away_player_name, away_team, away_team_opp, away_player_position, away_players)
    away_team_df <- bind_rows(away_team_df, away_player_stats) %>%
      filter(!position %in% c("N/A", "G"))
  }
  game_boxscore <- bind_rows(home_team_df, away_team_df)

  write_csv(game_boxscore, path = paste0("~/rstats/hockey/nhl_api/csv/2018_2019/", game_id, ".csv"))
}

########## USE THE FOLLOWING LINE TO DOWNLOAD A SELECTED GAME ##########
# nhlBoxScore(2018020823) # to get the sabres game on 2019-02-07


########## USE THIS TO DOWNLOAD GAMES FOR A RANGE OF GAMES ##########
game_range <- 2018020940:2018020961
all_games_20182019 <- lapply(game_range, nhlBoxScore)
#View(all_games_20182019)



########## THIS TAKES ALL THE CSV FILES AND COMBINES THEM INTO ONE ##########
today <- Sys.Date()
csv_files <- list.files(path = "~/rstats/hockey/nhl_api/csv/2018_2019/", pattern = "csv$", full.names = TRUE)
csv_list = lapply(csv_files, read_csv)
my_data = purrr::map_dfr(csv_files, read_csv)
write_csv(my_data, path = paste0("~/rstats/hockey/nhl_api/csv/all_games_through_", Sys.Date(),".csv"))

View(my_data)









