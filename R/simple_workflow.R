## Hertie School - Master of Data Science for Public Policy
## Intro to Data Science Workshop 2022

## Theme: Network analysis with {ggraph} and {tidygraph}
## Instructors: Radwa Abdelsalam (github.com/Radwa-Radwan)
##              Rodrigo Dornelles (github.com/rfdornelles)



# Basic workflow ----------------------------------------------------------

# Read packages
library(readr)  # open files such as .rds
library(tibble) # better way to deal with data.frames-ish objects
library(dplyr, warn.conflicts = FALSE)  # manipulate objects very efficiently
library(tidygraph) # manipulate graphs
library(ggraph)    # plot graphs
library(tidyverse) # useful tools to work with data
library(academictwitteR)  # consume Twitter's academic API


# Import data -------------------------------------------------------------

# Fist step, autenthication:
vignette("academictwitteR-auth")
vignette("academictwitteR-build") # basics about twitter queries

# Among many possibilities, it's possible to gather users's timeline:
df_timeline <- get_user_timeline(
  "252087644", # Hertie School
  start_tweets = "2022-08-01T00:00:00Z",
  end_tweets = "2022-11-21T00:00:00Z",
  n = 10 # amount of tweets
  )


# Who liked that user's tweet:
liked_tweets <- get_liking_users(df_timeline$id)


# Tidy data ---------------------------------------------------------------

# It's necesary to end up with nodes and edges. In the edges, we need to have
# the interactions with colums "from" and "to". In the nodes, we need the
# features of each node (in this case, users)

df_replies <- df_timeline |> # contain all tweets from Herties' following
  # only the useful columns
  dplyr::select(author_id, in_reply_to_user_id) |>
  # only if it's a reply - if it's NA it doesn't matter
  dplyr::filter(!is.na(in_reply_to_user_id)) |>
  # renaming to have the "from" and "to" information
  dplyr::rename(from = author_id,
                to = in_reply_to_user_id) |>
  dplyr::select(from, to)

# Extracting all mentions (users that were mentioned in the tweets)

df_mentions <- df_timeline |> # again, we start from the all_tweets df
  dplyr::select(author_id, entities) |>
  # since entities is a list column, it's necessary to "open" with unnest
  tidyr::unnest(entities) |>
  dplyr::select(author_id, mentions) |>
  # the mentions columns is, itself, also nested. it's necessary un-nest again
  tidyr::unnest(mentions) |>
  # select the useful columns
  dplyr::select(author_id, username, id) |>
  dplyr::select(from = author_id,
                to = id)

# Tidy the likes:
df_likes <- liked_tweets |>
  dplyr::select(username, id) |>
  # there are many NA's since it can come from closed accounts
  na.omit() |>
  dplyr::mutate(
    to = "252087644" # again, setting the "to" to Hertie's id
  ) |>
  dplyr::select(from = id, to)

# Bind all dataframes in the edges:

df_edges <- bind_rows(df_likes, df_replies, df_mentions)

# Gather the information about users:

df_nodes <- df_edges |>
  unlist() |>
  unique() |>
  head(5) |>  # since it's only an example, gather only few data
  academictwitteR::get_user_profile() |>
  select(username, id, verified)


# Build graph df ----------------------------------------------------------


tweets_graph <- tidygraph::tbl_graph(
  # nodes = df_nodes, # real life issue: might be "lost" points
  edges = df_edges,
  directed = FALSE
)


# Analyse -----------------------------------------------------------------

tweets_measures <- tweets_graph |>
  mutate(degree = centrality_degree(), # Degree centrality
       between = centrality_betweenness(normalized = T), # Betweeness centrality
       closeness = centrality_closeness(), # Closeness centrality
       eigen = centrality_eigen() # Eigen centrality
) |>
  # tell that we want to work with the nodes part
  activate(nodes) |>
  # "export" as a tibble
  as_tibble()

# clustering

tweets_clust <- tweets_graph |>
  mutate(
    community = group_infomap()
  ) |>
  activate(nodes)

tweets_clust |>
  as_tibble() |>
  count(community)

# Plots -------------------------------------------------------------------
tweets_graph |>
  mutate(
  centrality = centrality_degree() # Degree centrality
)  |>
  ggraph() +
  geom_edge_link() +
  geom_node_point(aes(size = centrality, color = centrality)) +
  theme_graph()


# Clustering

tweets_graph |>
  mutate(
    community = as.factor(group_infomap())
  ) |>
  ggraph() +
  geom_edge_link() +
  geom_node_point(aes(color = community), size = 5) +
  scale_color_viridis(discrete = TRUE) +
  theme_graph()
