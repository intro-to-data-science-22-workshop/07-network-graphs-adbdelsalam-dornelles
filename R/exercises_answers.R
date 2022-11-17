## Hertie School - Master of Data Science for Public Policy
## Intro to Data Science Workshop 2022

## Theme: Network analysis with {ggraph} and {tidygraph}
## Instructors: Radwa Abdelsalam (github.com/Radwa-Radwan)
##              Rodrigo Dornelles (github.com/rfdornelles)


# Practice Materials ------------------------------------------------------

#Loading required libraries
library(ggraph)
library(tidygraph)
library(tidyverse)


# 1) First graphs ---------------------------------------------------------

# Using the create_(*) family, build at least 2 different graphs and save it
# in tbl_graph objects

graph_create <- create_complete(4)

graph_tree <- create_tree(300, 3)


graph_create
graph_tree

# Now plot those objects using ggraph()

graph_create |>
  ggraph() +
  geom_node_point() +
  geom_edge_link()


graph_tree |>
  ggraph() +
  geom_node_point() +
  geom_edge_link()


# Using your ggplo2 skills, add the theme_graph() and also provide labels to
# your plot

graph_tree |>
  ggraph() +
  geom_node_point() +
  geom_edge_link() +
  theme_graph() +
  labs(
    title = "A Random Tree Graph Plot",
    subtitle = "It looks like a genealogical tree",
    caption = "Another clever comment")


# 2) Build a tbl_graph with real data --------------------------------------
# The exercises are inspired by: https://ona-book.org/using-twitter.html>

# Now, let's apply the theoretical knowledge to real data. Lets load data
# from Canadian Members of Parliament Twitter's account

mp_nodes <- read_csv("data-raw/mp_vertices.csv")
mp_edges <- read_csv("data-raw/mp_edgelist.csv")


# Please explain what are the nodes here. And what do you think the edges
# might be.

# Nodes are twitter users, in many cases here they are members of Canadian
# Parliament
# The edges are twitter interactions, such as likes, RT, replies and mentions

# Set the nodes and the edges in a tbl_graph object using a tidygraph function

mp_graph <- tbl_graph(
  nodes = mp_nodes,
  edges = mp_edges,
  directed = FALSE
)

class(mp_graph)

# Let's apply centrality measures (choose the compound or single measure)
# remember that there's a hole family of functions inside tidygraph

mp_centrality_tbl <- mp_graph |>
  mutate(
    closeness = centrality_closeness(),
    eigen = centrality_eigen()
  ) |>
  activate(nodes) |>
  as_tibble()

# Now, try at least 2 kinds of grouping

mp_clustering_graph_1 <- mp_graph |>
  mutate(
    cluster = group_infomap()
  ) |>
  activate(nodes) |>
  as_tibble()


mp_clustering_graph_2 <- mp_graph |>
  mutate(
    cluster = group_louvain()
  ) |>
  activate(nodes) |>
  as_tibble()
# 3) Ploting everything! --------------------------------------------------


# Plot now the clusters that you had in the last exercise

mp_graph |>
  mutate(
    cluster = group_infomap(),
    cluster = as_factor(cluster)
  ) |>
  ggraph() +
  geom_node_point(aes(color = cluster)) +
  geom_edge_link() +
  theme_graph()

mp_graph |>
  mutate(
    cluster = group_louvain(),
    cluster = as_factor(cluster)
  ) |>
  ggraph() +
  geom_node_point(aes(color = cluster)) +
  geom_edge_link() +
  theme_graph()



# Plot, also, the nodes in order to show the impact of the meaures of
# centrality.

mp_graph |>
  mutate(
    closeness = centrality_closeness()
  ) |>
  ggraph() +
  geom_node_point(aes(color = closeness, size = closeness)) +
  geom_edge_link() +
  theme_graph()

mp_graph |>
  mutate(
    eigen = centrality_eigen()
  ) |>
  ggraph() +
  geom_node_point(aes(color = eigen, size = eigen)) +
  geom_edge_link() +
  theme_graph()


# Do you think those measures make sense? What insights do you have?



