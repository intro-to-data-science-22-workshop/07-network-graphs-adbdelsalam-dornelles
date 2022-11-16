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

# It allow us to manipulate both nodes and edges at the same time using
# other {dplyr} verbs. The key to to this is the function called activate()

# First, lets see which mode is active:
active(dolphin_graph)

# Now we can change:
dolphin_graph |>
  activate(edges)

dolphin_graph |>
  activate(edges) |>
  group_by(from, to) |>
  summarise(
    weight = n()
  )


# analysis

# {ggraph} ----------------------------------------------------------------

#
create_ring(5) |>
  ggraph() +
  geom_edge_link() +
  geom_node_point()


