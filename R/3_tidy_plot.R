## Hertie School - Master of Data Science for Public Policy
## Intro to Data Science Workshop 2022

## Theme: Network analysis with {ggraph} and {tidygraph}
## Instructors: Radwa Abdelsalam (github.com/Radwa-Radwan)
##              Rodrigo Dornelles (github.com/rfdornelles)


# The packages ------------------------------------------------------------

# Both packaged were created in order to easy our work to analyse/plot network
# graphs. Also, there are many possible applications to this. They rely over
# the already existent {igraph} package, which is very rich (and also complicated)
# adapting its concepts to the {tidyverse}.
# It allows to apply our already-friends {dplyr} verbs, and also uses the very
# powerful {ggplot2}.

# In our case, we'll focus in analyse social media, since it's a very important
# (and hot) topic in the public policy field.

# So, in the next lines we'll show the basic of the packages and, in the next
# script we'll show a real application to real Twitter data.

# NOTE: Please make sure that you already run the 0, 1 e 2 script before this


# Load packages -----------------------------------------------------------

# As the first step, we'll load both packages
library(tidygraph)
library(ggraph)

# Also, tidyverse to allows us use many data science useful tools
library(tidyverse)
# {tidygraph} -------------------------------------------------------------

# This is a very comprehensive package that allows us to both organize and
# analyse graph data. Also, it allows to easily produce example data to practice.
# There's good reference from the author's website:
# https://www.data-imaginist.com/2017/introducing-tidygraph/

# As we mentioned, the basic element is the tbl_graph object. We might either
# import it or transform our data into this class. It'll allow use the other
# verbs to manipulate, analyse and - with ggraph - plot it.

# If we don't have any data, it's possible to generate graphs. There's the
# create_(*) family

example_graph <- create_complete(10)
example_graph
class(example_graph)

# In our case, it'll be important to transform the data that we already have
# into the tbl_graph format. We only need the nodes and edges.

# We'll example with a resource from:
# http://users.dimi.uniud.it/~massimo.franceschet/ns/plugandplay/ggraph/ggraph.html

# Reading the .csv files
dolhpin_edges <- readr::read_csv(file = "data-raw/dolphin_edges.csv")
dolphin_nodes <- readr::read_csv(file = "data-raw/dolphin_nodes.csv")

dolphin_nodes

# Let's take a quick look:
dolphin_nodes

dolhpin_edges

# To transform it, we could:
dolphin_graph <- tbl_graph(
  nodes = dolphin_nodes,
  edges = dolhpin_edges
)

dolphin_graph

class(dolphin_graph)

# Although the package offers some functions to manipulate the date, probably
# it's more useful to do this operations before creating the tbl_graph object,
# using {dplyr} and {tidyr} that are well-known.

# The function activate() might be useful in many cases.


# Another useful feature allow us to analyse the data and uses centrality
# measures, clustering and other cool tools:

# A short explanation of each measure is at: <https://rpubs.com/TeraPutera/social_network_analysis>:

# Degree: For finding very connected individuals, popular individuals,
# individuals who are likely to hold most information or individuals who can
# quickly connect with the wider network.

# Betweenness: For finding the individuals who influence the flow around a
# system.

# Closeness: For finding the individuals who are best placed to influence the
# entire network most quickly.

# Eigen: measures a node’s influence based on the number of links it has to
# other nodes in the network, then goes a step further by also taking into
# account how well connected a node is, and how many links their connections
# have, and so on through the network.

# We should call the centrality_(*) family in the context of the tbl_graph:

dolphin_measures <- dolphin_graph |>
  mutate(degree = centrality_degree(), # Degree centrality
         between = centrality_betweenness(normalized = T), # Betweeness centrality
         closeness = centrality_closeness(), # Closeness centrality
         eigen = centrality_eigen() # Eigen centrality
  ) |>
  # tell that we want to work with the nodes part
  activate(nodes) |>
  # "export" as a tibble
  as_tibble()

# Order according to some criteria:
dolphin_measures |>
  arrange(-eigen)

dolphin_measures |>
  arrange(-degree)

# Also, it's possible to identify communities, groups, clusters. The family
# that helps us in this task is the group_(*):

dolphin_clust <- dolphin_graph |>
  mutate(
    community = group_infomap()
  ) |>
  activate(nodes) |>
  as_tibble()

dolphin_clust |>
  count(community)

# {ggraph} ----------------------------------------------------------------

# Now we can easily put all together and make some cool plots!
# ggraph works with ggplot2 to plot edges and nodes and use all ggplopt's
# resources to create useful visualizations.

# Just to warm up, we can create some random data and see how it behaves.
# the create_(*) family allows us to do so:
create_ring(5) |>
  ggraph() +
  geom_edge_link() +
  geom_node_point()

create_complete(10) |>
  ggraph() +
  geom_edge_link() +
  geom_node_point()

create_tree(n = 30, children = 2) |>
  ggraph() +
  geom_edge_link() +
  geom_node_point()

# But the most useful, of course, is to use with the data that we already
# prepared.

# Basically, we call the data and the main function ggraph()

dolphin_graph |>
  ggraph()

# Then, as we do with ggplot2, we add the elements with +

dolphin_graph |>
  ggraph() +
  geom_node_point()

# And, of course, we can add edges:

dolphin_graph |>
  ggraph() +
  geom_node_point() +
  geom_edge_link()


# Using the ggplot() power, we can make more useful the {tidygraph} features:

# It has some themes:
dolphin_graph |>
  ggraph() +
  geom_node_point() +
  geom_edge_link() +
  theme_graph()

# Centrality measures

dolphin_graph |>
  mutate(
    centrality = centrality_degree() # Degree centrality
  ) |>
  ggraph() +
  geom_edge_link() +
  geom_node_point(aes(size = centrality, color = centrality)) +
  theme_graph()

# Clustering

dolphin_graph |>
  mutate(
    community = as.factor(group_infomap())
  ) |>
  ggraph() +
  geom_edge_link() +
  geom_node_point(aes(color = community), size = 5) +
  #scale_color_viridis(discrete = TRUE) +
  theme_graph()

