
hertie_following <- academictwitteR::get_user_id("thehertieschool") |>
  academictwitteR::get_user_following()

hertie_tweets <- academictwitteR::get_user_timeline(
  "252087644",
  start_tweets = "2022-08-01T00:00:00Z",
  end_tweets = "2022-11-14T00:00:00Z",
  n = Inf)

readr::write_rds(hertie_tweets, "data-raw/hertie_tweets.rds")

hertie_following_id <- tibble::tibble(hertie_following)$id

following_tweets <- academictwitteR::get_user_timeline(
  hertie_following_id,
  start_tweets = "2022-08-01T00:00:00Z",
  end_tweets = "2022-11-14T00:00:00Z",
  n = 200)

readr::write_rds(following_tweets, "data-raw/hertie_following_tweets.rds",
                 compress = "xz")

following_tweets <- tibble::as_tibble(following_tweets)

following_tweets

liked_tweets <- academictwitteR::get_liking_users(hertie_tweets$id)

rt_tweets <- academictwitteR::get_retweeted_by(hertie_tweets$id)

readr::write_rds(rt_tweets, "data-raw/rt_tweeets.rds")

liked_tweets |>
  tibble::as_tibble() |>
  tibble::view()

liked_tweets |> dplyr::count()

beepr::beep(sound = 8)


# apply blog post ---------------------------------------------------------

count_and_group <- function (df) {

  df |>
    dplyr::select(in_reply_to_user_id) |>
    unlist() |>
    tibble::tibble(interacted_with = _) |>
    tidyr::drop_na() |>
    dplyr::group_by(interacted_with) |>
    dplyr::summarise(weight = dplyr::n()) #|>
    # dplyr::filter(
    #   # ensures that only MP interactions are returned
    #   interacted_with %in% substr(hertie_following_id, 2, nchar(hertie_following_id))
    # )

}

create_edgelist <- function(df) {
  df |>
    dplyr::nest_by(author_id) |>
    dplyr::summarise(count_and_group(data)) |>
    # ignore interactions with self
    dplyr::filter(author_id != interacted_with) |>
    dplyr::rename(from = author_id, to = interacted_with)

  }

mp_edgelist <- create_edgelist(df)

mp_edgelist |>
  dplyr::arrange(-weight)

library(tidygraph)
library(ggraph)

library(igraph)
(mp_graph_undirected <- igraph::graph_from_data_frame(
  dplyr::filter(mp_edgelist, weight > 1),
  #vertices = mp_vertices,
  directed = FALSE
))

ggraph(mp_graph_undirected, layout = "fr") +
  geom_edge_link(color = "grey", alpha = 0.7) +
  geom_node_point() +
  theme_void()


  scale_colour_manual(limits = party_colours$party,
                      values = party_colours$colour, name = "Party")

graph <- as_tbl_graph(mp_edgelist)

ggraph(graph) +
  geom_edge_link() +
  geom_node_point()
