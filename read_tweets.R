# inspired on: https://levelup.gitconnected.com/how-to-do-amazing-twitter-network-analysis-in-r-2c258537dd7d


# Import ------------------------------------------------------------------

# data from people followed by Hertie's profile
# Hertie follow this people
df_tweets <- results

results |>
  dplyr::left_join(usernames_following |>
                     dplyr::select(id, screen_name)) |>
  dplyr::pull(screen_name) |>
  na.omit()

usernames_following_data <- readr::read_rds("data-raw/usernames_following_data.rds")

# we write a function to generate the network for a given person

count_and_group <- function (df) {
  results |>
    dplyr::select(dplyr::contains("screen_name")) |>
    unlist() |>
    tibble::tibble(interacted_with = _) |>
    tidyr::drop_na() |>
    dplyr::group_by(interacted_with) |>
    dplyr::summarise(weight = dplyr::n()) |>
    dplyr::arrange(-weight) # |>
    # dplyr::filter(
    # # ensures that only people interactions are returned
    # interacted_with %in% substr(
    #   usernames_following_data$screen_name, 2,
    #   nchar(usernames_following_data$screen_name)
    #   ))
}


# function to generate edgelist across all following people
create_edgelist <- function(tweet_df) {

  tweet_df |>
    # CHANGE IT!!!!!!!!!!!!!!!!!!!!!!!!!1
    dplyr::rename(screen_name = id_str) |>
    dplyr::nest_by(screen_name) |>
    dplyr::summarise(count_and_group(data)) |>
    # ignore interactions with self
    dplyr::filter(screen_name != interacted_with) |>
    dplyr::rename(from = screen_name, to = interacted_with)
}

# create final edgelist
mp_edgelist <- create_edgelist(results)

mp_vertices <- results |>
  dplyr::select(id, followers_count) |>
  dplyr::distinct() |>
  dplyr::left_join(
    usernames_following_data |>
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
