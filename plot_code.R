# plot? -------------------------------------------------------------------

library(ggraph)
library(tidygraph)

graph <- df_nodes |>
  dplyr::filter(from == "thehertieschool" | to == "thehertieschool") |>
  as_tbl_graph()

graph <- df_nodes |>
  dplyr::filter(weight > 1 ) |>
  as_tbl_graph()

graph <- as_tbl_graph(head(df_nodes, 100))



set_graph_style(plot_margin = margin(1,1,1,1))

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
# nodes_mainionary <- academictwitteR::get_user_profile()

#nodes_mainionary <- users_dict |>
#  dplyr::pull(id) |>
#  academictwitteR::get_user_profile()

#user_dictionary <- tibble::as_tibble(test)
#user_dictionary |> names()

#user_dictionary$location
#readr::write_rds(user_dictionary, "data-raw/users_profile_data.rds")
