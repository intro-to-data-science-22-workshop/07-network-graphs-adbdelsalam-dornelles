
# import data -------------------------------------------------------------

# hertie tweets

hertie_tweets <- readr::read_rds("data-raw/hertie_tweets.rds") |>
  tibble::as_tibble()

# hertie follows

hertie_following_users <- readr::read_rds(
  "data-raw/hertie_following_users.rds") |>
  tibble::as_tibble()

# tweets from who hertie follows

all_tweets <- readr::read_rds("data-raw/hertie_following_tweets.rds") |>
  tibble::as_tibble()

# who likes hertie's tweets

liked_hertie <- readr::read_rds("data-raw/liked_tweets.rds") |>
  tibble::as_tibble()

# who rt hertie's tweets
rt_hertie <- readr::read_rds("data-raw/rt_tweeets.rds") |>
  tibble::as_tibble()

# janitor::compare_df_cols_same(liked_hertie, rt_hertie, hertie_tweets)

names(all_tweets)

# get replies
df_replies <- all_tweets |>
  dplyr::select(author_id, in_reply_to_user_id) |>
  dplyr::filter(!is.na(in_reply_to_user_id)) |>
  dplyr::rename(from = author_id,
                to = in_reply_to_user_id)

# get all mentions
df_mentions <- all_tweets |>
  dplyr::select(author_id, entities) |>
  tidyr::unnest(entities) |>
  dplyr::select(author_id, mentions) |>
  tidyr::unnest(mentions) |>
  dplyr::select(author_id, username, id)

# get retweets
df_rt <- rt_hertie |>
  dplyr::select(username, id) |>
  dplyr::mutate(
    to = "252087644"
  )

# get likes
df_likes <- liked_hertie |>
  dplyr::select(username, id) |>
  na.omit() |>
  dplyr::mutate(
    to = "252087644"
  )

# user dictionary
users_dict <- dplyr::bind_rows(df_mentions, df_likes, df_rt) |>
  dplyr::select(id, username) |>
  unique() |>
  na.omit()

# merge all interactions

df_replies <- df_replies |>
  dplyr::select(from, to)

df_mentions <- df_mentions |>
  dplyr::select(from = author_id,
                to = id)
df_rt <- df_rt |>
  dplyr::select(from = id, to)

df_likes <- df_likes |>
  dplyr::select(from = id, to)

all_interactions <- dplyr::bind_rows(
  df_replies,
  df_mentions,
  df_rt,
  df_likes
)


# remove self interactions
all_interactions <- all_interactions |>
  dplyr::filter(from != to)


# bring names
all_interactions <- all_interactions |>
  dplyr::left_join(users_dict, by = c("from" = "id")) |>
  dplyr::select(from = username, to) |>
  dplyr::left_join(users_dict, by = c("to" = "id")) |>
  dplyr::select(from, to = username)

# vertices


df_nodes <- all_interactions |>
  dplyr::count(from, to, sort = TRUE, name = "weight")


# verticies


# merge with the usernames
all_tweets <- all_tweets |>
  dplyr::left_join(users_dict, by = c("author_id" = "id"))

all_tweets |>
  dplyr::filter(is.na(username))


# plot? -------------------------------------------------------------------

library(ggraph)
library(tidygraph)


graph <- as_tbl_graph(df_nodes)

# Not specifying the layout - defaults to "auto"
ggraph(graph) +
  geom_edge_link() +
  geom_node_point()

#
# users_dict <- dplyr::bind_rows(df_mentions, df_likes, df_rt) |>
#   dplyr::distinct(username, id)
#
#
# # merge with the usernames
# all_tweets <- all_tweets |>
#   dplyr::left_join(users_dict, by = c("author_id" = "id"))
#
# all_tweets |>
#   dplyr::filter(is.na(username))

# list_users_dict <- purrr::map_df(.x = users_list,
#               .f = purrr::safely(academictwitteR::get_user_profile))
#
# beepr::beep(8)
# beepr::beep(4)
#
# user_dictionary <- academictwitteR::get_user_profile()
