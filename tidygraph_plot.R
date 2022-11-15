library(tidygraph)
library(ggraph)
library(tidyverse)


graph_tweets <- tbl_graph(nodes = nodes_main,
                          edges = df_edges,
                          directed = F)

graph_tweets <- graph_tweets %>%
  activate(nodes) %>%
  mutate(degree = centrality_degree(), # Degree centrality
         between = centrality_betweenness(normalized = T), # Betweeness centrality
         closeness = centrality_closeness(), # Closeness centrality
         eigen = centrality_eigen() # Eigen centrality
  )

network_act_df <- graph_tweets %>%
  activate(nodes) %>% select(-2:-4)  %>%
  as_tibble()

pop_username <- as_tibble(
  network_act_df %>% arrange(-degree) %>% select(username) %>% head(),
  network_act_df %>% arrange(-between) %>% select(username) %>% head(),
  network_act_df %>% arrange(-closeness) %>% select(username) %>% head(),
  network_act_df %>% arrange(-eigen) %>% select(username) %>% head()
) %>% setNames(c("Degree","Betweenness","Closeness","Eigen"))

pop_username


set.seed(123)
graph_tweets <- graph_tweets %>%
  activate(nodes) %>%
  mutate(community = group_louvain()) %>% # clustering
  activate(edges) %>%
  filter(!edge_is_loop())

graph_tweets %>%
  activate(nodes) %>%
  as.data.frame() %>%
  count(community)

important_user <- function(data) {
  name_person <- data %>%
    as.data.frame() %>%
    filter(community %in% 1:5) %>%
    select(-community) %>%
    pivot_longer(-username, names_to = "measures", values_to = "values") %>%
    group_by(measures) %>%
    arrange(desc(values)) %>%
    slice(1:6) %>%
    ungroup() %>%
    distinct(username) %>%
    pull(username)

  return(name_person)
}

important_person <-
  graph_tweets %>%
  activate(nodes) %>%
  important_user()
