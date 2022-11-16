#Load required libraries

token <- create_token(
  app = "YOUR_APP_NAME",
  consumer_key = "YOUR_API_KEY",
  consumer_secret = "YOUR_API_KEY_SECRET",
  access_token = "YOUR_ACCESS_TOKEN",
  access_secret = "YOUR_ACCESS_TOKEN_SECRET"
)

url <- "https://www.politics-social.com/api/list/csv/party"
mp_list <- read.csv(url)

results1 <- rtweet::get_timeline(
  user = mp_list$Screen.name[1:180],
  n = rep(500, 180)
)

# second batch (at least 15 mins since first batch)
results2 <- rtweet::get_timeline(
  user = mp_list$Screen.name[181:360],
  n = rep(500, 180)
)
# third batch (at least 15 mins since second batch)
results3 <- rtweet::get_timeline(
  user = mp_list$Screen.name[361:540],
  n = rep(500, 180)
)
# fourth batch (at least 15 mins since third batch)
results4 <- rtweet::get_timeline(
  user = mp_list$Screen.name[541:length(mp_list$Screen.name)],
  n = rep(500, length(mp_list$Screen.name) - 540)
)
# combine all results
results <- rbind(results1, results2, results3, results4)


# function to create edgelist for single MP
count_and_group <- function (df) {
  df |>
    dplyr::select(ends_with("screen_name")) |>
    unlist() |>
    tibble(interacted_with = _) |>
    tidyr::drop_na() |>
    dplyr::group_by(interacted_with) |>
    dplyr::summarise(weight = n()) |>
    dplyr::filter(
      # ensures that only MP interactions are returned
      interacted_with %in% substr(mp_list$Screen.name, 2, nchar(mp_list$Screen.name))
    )
}

# function to generate edgelist across all MPs
create_edgelist <- function(tweet_df) {
  tweet_df |>
    dplyr::nest_by(screen_name) |>
    dplyr::summarise(count_and_group(data)) |>
    # ignore interactions with self
    dplyr::filter(screen_name != interacted_with) |>
    dplyr::rename(from = screen_name, to = interacted_with)
}

# create final edgelist
mp_edgelist <- create_edgelist(results)

# create vertex dataframe
mp_vertices <- results %>%
  select(screen_name, profile_image_url, followers_count) %>%
  distinct() |>
  left_join(
    mp_list |>
      dplyr::mutate(
        screen_name = substr(Screen.name, 2, nchar(Screen.name))
      ) |>
      dplyr::select(
        screen_name,
        constituency = Constituency,
        party = Party,
        name = Name
      )
  )

#create a unique colour for each party. Hint: use unique() function

parties <- mp_vertices$party |> unique()
party_colours <- c("#000000", "#216a4d", "#008a49",
                   "#d3c200", "#3d8028", "#f5b52e",
                   "#dd0339", "#cccccc", "#66ab21",
                   "#c2282a", "#018fda", "#eec52e")

#transform the color set into a dataframe and bind it to the main dataframe using left_join()

color_df <- data.frame(
  party = parties,
  colour = party_colours
)

mp_vertices <- mp_vertices |>
  left_join(color_df)

#create a final edge list

mp_edgelist <- mp_edgelist |>
  dplyr::filter(to %in% mp_vertices$screen_name)


#set the nodes and the edges

mp_graph <- tbl_graph(nodes = mp_vertices,
                          edges = mp_edgelist,
                          directed = F)


#activate the nodes/vertices and edges. Create communities

mp_vertex_list <- mp_vertices %>%
  activate(nodes) %>%
  as_tibble()





