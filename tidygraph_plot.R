library(tidygraph)
library(ggraph)


graph_tweets <- tbl_graph(nodes = head(nodes_main, n=1000),
                          edges = head(df_edges),
                          directed = F)

graph_tweets <- graph_tweets %>%
  activate(nodes) %>%
  mutate(degree = centrality_degree(), # Degree centrality
         between = centrality_betweenness(normalized = T), # Betweeness centrality
         closeness = centrality_closeness(), # Closeness centrality
         eigen = centrality_eigen() # Eigen centrality
  )
