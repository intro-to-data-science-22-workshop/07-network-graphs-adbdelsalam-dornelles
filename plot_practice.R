gr <- as_tbl_graph(df_nodes)

ggraph(gr, layout = 'kk') +
  geom_point(aes(x = x, y = y))

library(tidygraph)

graph |>
  activate(nodes)

graph

graph |>
  activate(edges) |>


    tibble::as_tibble()

only_hertie <- df_nodes |>
  dplyr::filter(from == "thehertieschool" | to == "thehertieschool")

as_tbl_graph(only_hertie)

create_complete(618) |>
  ggraph() +
  geom_edge_link() +
  geom_node_point()
