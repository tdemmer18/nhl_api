library(tidyverse)
library(jsonlite)
library(purrr)

########## TEAM INFO FROM NHL API ##########

# Obtain all team information from NHL API
json_url <- "https://statsapi.web.nhl.com/api/v1/teams"
teams <- fromJSON(json_url, flatten = TRUE)
teams_df <- teams$teams

# view teams dataframe
View(teams_df)
#write_csv(teams_df, path = "~/Desktop/teams_df_20182019.csv")


########## ALL ROSTER PLAYERS FROM ALL TEAMS FROM NHL API ##########

# get all franchise_id's for
franchise_id <- teams_df$franchise.franchiseId

# paste all roster url's together for our lapply function  below
rosters_url <- paste0("https://statsapi.web.nhl.com/api/v1/teams/",franchise_id, "/?expand=team.roster")

#create a function to flatten the JSON so we can get all the rosters
myfun <- function(x) {
  fromJSON(x, flatten = TRUE)
}

# use lapply on all the roster url's with our function we created to flatten the json
all_rosters <- lapply(rosters_url, myfun)

# check to make sure we have 31 lists of team rosters
View(all_rosters)

# create a vector of team numbers so we can loop through it below
team_nums <- 1:length(all_rosters)
class(team_nums)
# check see what it looks like when we look at team #1
all_rosters[[1]]$teams$roster.roster[[1]]


# create an empty dataframe for which we are going to put all the players in from our for loop below
all_players_df <- data.frame()

# for loop to add all players from everyteam into our dataframe
for (i in 1:length(team_nums)) {
  players <- all_rosters[[i]]$teams$roster.roster[[1]]
  all_players_df <- rbind(all_players_df, players)
}

# view all players dataframe
View(all_players_df)

#write_csv(all_players_df, path = "~/Desktop/nhl_player_20182019.csv")


########### GET ALL PLAYER DETAIL FROM NHL API ##########
player_url <- all_players_df$person.link
class(player_url)

all_players_urls <- paste0("https://statsapi.web.nhl.com", player_url)
all_players_urls
class(all_players_urls)

all_players_detail <- lapply(all_players_urls, myfun)
View(all_players_detail[[1]]$people)
ncol(all_players_detail[[1]]$people)

View(all_players_detail[[1]]$people)
View(all_players_detail[[2]]$people)


View(all_players_detail)

player_length <- 1:length(all_players_detail)
player_length


all_players_detail_df <- data.frame()
for (i in 1:length(player_length)) {
  players_detail <- ncol(all_players_detail[[i]]$people)  # using ncol here because found out not all rows have the same # of columns
  all_players_detail_df <- rbind(all_players_detail_df, players_detail)
}

unique(all_players_detail_df) # 25 columns at row 396
View(all_players_detail[[396]]$people)  # Landon Bow - nationality is missing and shootsCatches is missing

all_players_detail_df %>%
  group_by(X26L) %>%
  tally()

# adding an index number so I can pull out the row numbers for all persons with 25, 26 and 27 columns
# and put into separate dataframes to loop through before we re-combine them.
all_players_detail_df_modified <- all_players_df %>%
  mutate(index = player_length)

View(all_players_detail_df_modified)

# adding index to all_players_detail_df so we can then join the column to show number of columns,
# then we can filter/subset our data
df_to_join <- all_players_detail_df %>%
  mutate(index = player_length)

View(df_to_join)


nhl_players_df <- all_players_detail_df_modified %>%
  left_join(df_to_join, by = "index")
View(nhl_players_df)

all_players_detail_df_modified_27 <- nhl_players_df %>%
  filter(X26L == 27)

all_players_detail_df_modified_27 <- all_players_detail_df_modified_27$person.link

View(all_players_detail_df_modified_27)

class(all_players_detail_df_modified_27)



player_27_links <- paste0("https://statsapi.web.nhl.com", all_players_detail_df_modified_27)
player_27_links

all_players_detail_27 <- lapply(player_27_links, myfun)

player_27_length <- 1:length(all_players_detail_27)
player_27_length


all_players_detail_df_27 <- data.frame()
for (i in 1:length(player_27_length)) {
  players_detail_27 <- all_players_detail_27[[i]]$people  # using ncol here because found out not all rows have the same # of columns
  all_players_detail_df_27 <- rbind(all_players_detail_df_27, players_detail_27)
}
View(all_players_detail_df_27) ##********** row_bind later


##### NEED TO REPEAT LINES 110 to 135

all_players_detail_df_modified_26 <- nhl_players_df %>%
  filter(X26L == 26)

all_players_detail_df_modified_26 <- all_players_detail_df_modified_26$person.link

View(all_players_detail_df_modified_26)

class(all_players_detail_df_modified_26)



player_26_links <- paste0("https://statsapi.web.nhl.com", all_players_detail_df_modified_26)
player_26_links

all_players_detail_26 <- lapply(player_26_links, myfun)

player_26_length <- 1:length(all_players_detail_26)
player_26_length


all_players_detail_df_26 <- data.frame()
for (i in 1:length(player_26_length)) {
  players_detail_26 <- all_players_detail_26[[i]]$people  # using ncol here because found out not all rows have the same # of columns
  all_players_detail_df_26 <- rbind(all_players_detail_df_26, players_detail_26)
}
View(all_players_detail_df_26)

all_players_detail_df_26 <- all_players_detail_df_26 %>%
  add_column(birthStateProvince = "NA", .after = "birthCity")
View(all_players_detail_df_26) ##********* row_bind later


###### NEED TO REPEAT LINES 140 to 169
all_players_detail_df_modified_25 <- nhl_players_df %>%
  filter(X26L == 25)

all_players_detail_df_modified_25 <- all_players_detail_df_modified_25$person.link

View(all_players_detail_df_modified_25)

class(all_players_detail_df_modified_25)



player_25_links <- paste0("https://statsapi.web.nhl.com", all_players_detail_df_modified_25)
player_25_links

all_players_detail_25 <- lapply(player_25_links, myfun)

player_25_length <- 1:length(all_players_detail_25)
player_25_length


all_players_detail_df_25 <- data.frame()
for (i in 1:length(player_25_length)) {
  players_detail_25 <- all_players_detail_25[[i]]$people  # using ncol here because found out not all rows have the same # of columns
  all_players_detail_df_25 <- rbind(all_players_detail_df_25, players_detail_25)
}
View(all_players_detail_df_25)




### FIX THIS FOR 25 to 27
all_players_detail_df_25 <- all_players_detail_df_25 %>%
  add_column(nationality = "CAN", .after = "birthCountry")

all_players_detail_df_25 <- all_players_detail_df_25 %>%
  add_column(shootsCatches = "L", .after = "rookie")


View(all_players_detail_df_25) ##********* rbind later

nhl_player_pool_df <- data.frame()
nhl_player_pool_df <- rbind(nhl_player_pool_df, all_players_detail_df_27)
nhl_player_pool_df <- rbind(nhl_player_pool_df, all_players_detail_df_26)
nhl_player_pool_df <- rbind(nhl_player_pool_df, all_players_detail_df_25)
View(nhl_player_pool_df)

nhl_players_df_to_join <- nhl_players_df %>%
  select(person.fullName, index)

nhl_player_pool_df_final <- nhl_player_pool_df %>%
  left_join(nhl_players_df_to_join, by = c("fullName" = "person.fullName")) %>%
  arrange(index)

View(nhl_player_pool_df_final)

#write_csv(nhl_player_pool_df_final, path = "~/Desktop/nhl_player_detail_20182019.csv")
