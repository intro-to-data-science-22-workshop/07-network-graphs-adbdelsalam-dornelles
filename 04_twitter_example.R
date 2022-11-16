## Hertie School - Master of Data Science for Public Policy
## Intro to Data Science Workshop 2022

## Theme: Network analysis with {ggraph} and {tidygraph}
## Instructors: Radwa Abdelsalam (github.com/Radwa-Radwan)
##              Rodrigo Dornelles (github.com/rfdornelles)


# Twitter example ---------------------------------------------------------
library(tidygraph)
library(ggraph)
library(tidyverse)


graph_tweets <- tbl_graph(nodes = nodes_main,
                          edges = df_edges,
                          directed = FALSE)


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

pop_username <- data.frame(
  network_act_df %>% arrange(-degree) %>% select(username),
  network_act_df %>% arrange(-between) %>% select(username),
  network_act_df %>% arrange(-closeness) %>% select(username),
  network_act_df %>% arrange(-eigen) %>% select(username)
) %>% setNames(c("Degree","Betweenness","Closeness","Eigen")) |>
  tibble::as_tibble()

pop_username


set.seed(123)
graph_tweets <- graph_tweets %>% select(-2:-4) |>
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
    arrange(desc(values))

  return(name_person)
}


important_person <-
  graph_tweets %>%
  activate(nodes) %>%
  important_user() %>%
  slice(1:10) %>%
  ungroup() %>%
  distinct(username) %>%
  pull(username)


set.seed(123)

hertie_graph <- graph_tweets %>%
  activate(nodes) %>%
  mutate(ids = row_number(),
         community = as.character(community)) %>%
  filter(community %in% 1:7) %>% # number of community.
  arrange(community,ids) %>%
  mutate(node_label = ifelse(username %in% important_person, username,NA)) %>%
  ggraph(layout = "fr") +
  geom_edge_link(alpha = 0.3) +
  geom_node_point(aes(size = degree, fill = community), shape = 21, alpha = 0.7, color = "grey30") +
  geom_node_label(aes(label = node_label), repel = T, alpha = 0.8 ) +
  guides(size = "none") +
  labs(title = "Top Communities in the #HertieVerse",
       color = "Interaction",
       fill = "Community") +
  theme_void() +
  theme(legend.position = "top")




