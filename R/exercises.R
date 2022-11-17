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


# Now plot those objects using ggraph()


# Using your ggplo2 skills, add the theme_graph() and also provide labels to
# your plot



# 2) Build a tbl_graph with real data --------------------------------------
# The exercises are inspired by: https://ona-book.org/using-twitter.html>

# Now, let's apply the theoretical knowledge to real data. Lets load data
# from Canadian Members of Parliament Twitter's account

mp_nodes <- read_csv("data-raw/mp_vertices.csv")
mp_edges <- read_csv("data-raw/mp_edgelist.csv")


# Please explain what are the nodes here. And what do you think the edges
# might be.



# Set the nodes and the edges in a tbl_graph object using a tidygraph function



# Let's apply centrality measures (choose the compound or single measure)
# remember that there's a hole family of functions inside tidygraph



# Now, try at least 2 kinds of grouping



# 3) Ploting everything! --------------------------------------------------


# Plot now the clusters that you had in the last exercise






# Plot, also, the nodes in order to show the impact of the meaures of
# centrality.



# Do you think those measures make sense? What insights do you have?



