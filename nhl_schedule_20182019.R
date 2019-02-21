library(tidyverse)
library(jsonlite)



json_url <- "https://statsapi.web.nhl.com/api/v1/teams"
teams <- fromJSON(json_url, flatten = TRUE)
teams_df <- teams$teams

# view teams dataframe
team_id <- teams_df$id
team_id
# get all team schedule url's
game_schedule_url <- paste0("https://statsapi.web.nhl.com/api/v1/schedule?teamId=", team_id,"&startDate=2018-10-03&endDate=2019-04-10")


# created a function to flatten each url
myfun <- function(x) {
  fromJSON(x, flatten = TRUE)
}

# loop through each schedule
all_schedules <- lapply(game_schedule_url, myfun)
team_schedule <- all_schedules[[1]]
View(team_schedule)

# create ranges and data.frame to put results into
game_range <- 1:82
team_range <- 1:31
all_games <- data.frame()



# lop through all 31 teams and then all 82 games and add rows to all_games data.frame
for(j in 1:length(team_range)) {
  for (i in 1:length(game_range)) {
    games <- as.data.frame(all_schedules[[j]]$dates$games[[i]])
    all_games <- bind_rows(all_games, games)
  }
}

# filter out pre-season and arrange in order then remove duplicates
all_games_ordered <- all_games %>%
  filter(gameType != "PR") %>%
  arrange(gamePk) %>%
  unique()


#write_csv(all_games_ordered, path = "~/rstats/hockey/nhl_api/csv/schedule/nhl_schedule_20182019.csv")

# to get a specific team's schedule
for (i in team_id){
  each_teams_schedule <- all_games_ordered %>% filter(teams.home.team.id == i | teams.away.team.id == i) %>%
    rowid_to_column()

  write_csv(each_teams_schedule, path = paste0("~/rstats/hockey/nhl_api/csv/schedule/each_teams_schedule_csv/nhl_", i, "_schedule_20182019.csv"))
}




csv_files <- list.files(path = "~/rstats/hockey/nhl_api/csv/schedule/each_teams_schedule_csv/", pattern = "csv$", full.names = TRUE)
csv_list = lapply(csv_files, read_csv)
my_data = purrr::map_dfr(csv_files, read_csv)

schedule_date_order <- my_data %>%
  select(rowid, gamePk, gameDate, teams.away.team.id, teams.home.team.id)

#write_csv(schedule_date_order, path = paste0("~/rstats/hockey/nhl_api/csv/schedule/game_id_schedule.csv"))


View(schedule_date_order)
