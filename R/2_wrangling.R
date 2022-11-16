## Hertie School - Master of Data Science for Public Policy
## Intro to Data Science Workshop 2022

## Theme: Network analysis with {ggraph} and {tidygraph}
## Instructors: Radwa Adbdelsalam (github.com/Radwa-Radwan)
##              Rodrigo Dornelles (github.com/rfdornelles)

# Load the data -----------------------------------------------------------

# Library {readr}, {tibble} and {dplyr}
library(readr)  # open files such as .rds
library(tibble) # better way to deal with data.frames-ish objects
library(dplyr, warn.conflicts = FALSE)  # manipulate objects very efficiently
library(tidyr)  # tools to manipulate data frames

# Wrangling data ----------------------------------------------------------

# To efficiently realize network analysis with the packages we need data about
# nodes and edges. Although we already have good data collected and it's pretty
# much in the tidy format (i.e, each observation in a row, each feature in a
# column), it's necessary some steps to have the data in the right format.

# In the few lines we'll extract all the information that we need and build
# a table containing "from" and "to" columns, where we'll be able to infer
# who (nodes) and how much (edges) each user interacted.

# NOTE: all data is supposed to be read with the 1_load_data.R script
# NOTE: although running over a specific dataset, the next steps might be
# adapted to any other analysis that you might have in the future


# Extracting the interactions about reply (i.e, when Hertie's tweets were
# replied)

df_replies <- all_tweets |> # contain all tweets from Herties' following
  # only the useful columns
  dplyr::select(author_id, in_reply_to_user_id) |>
  # only if it's a reply - if it's NA it doesn't matter
  dplyr::filter(!is.na(in_reply_to_user_id)) |>
  # renaming to have the "from" and "to" information
  dplyr::rename(from = author_id,
                to = in_reply_to_user_id) |>
  dplyr::select(from, to)

# Extracting all mentions (users that were mentioned in the tweets)

df_mentions <- all_tweets |> # again, we start from the all_tweets df
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

# Now using the retweets dataset, we'll get all users that RTed @thehertieschool
df_rt <- rt_hertie |>
  dplyr::select(username, id) |>
  # creating a new column "to", refering that the "receiver" of all those
  # interactions is the Hertie Scholl
  dplyr::mutate(
    to = "252087644" # @thehertieschool id
  ) |>
  dplyr::select(from = id, to)

# Now, getting all interactions when @thehertieschool tweets were liked
df_likes <- liked_hertie |>
  dplyr::select(username, id) |>
  # there are many NA's since it can come from closed accounts
  na.omit() |>
  dplyr::mutate(
    to = "252087644" # again, setting the "to" to Hertie's id
  ) |>
  dplyr::select(from = id, to)


# Building the edges and nodes datasets -----------------------------------

# Now that we have all the data that we would like to use in the right format
# is easy to build the edges (users) and nodes (interactions) datasets.
# Here, we used replies, RTs, likes, mentions, etc but of course you could use
# more data or even less data, is totally up to you.

# The main objective from now on is to merge two different datasets that'll
# become our {tidygraph} main input.

# Nodes:
# Those are the users that somehow are part of our network analysis. They could
# be mentioned, they liked, they RTed or are followed by @thehertieschool.
# We're not worried not how relevant they are (it's a matter for the analysis).

# To have them, we subset the user_profile dataset and select the identification
# column, but also useful features to us, such as the name, its location, etc

nodes_main <- users_profile |>
  select(username, id, location, verified) |>
  # make sure that there's no dupes
  unique()


# Edges: To build this we should merge all interactions dataset in one
# (binding its rows)

all_interactions <- dplyr::bind_rows(
  df_replies,
  df_mentions,
  df_rt,
  df_likes
)

# Removing self-interactions
all_interactions <- all_interactions |>
  dplyr::filter(from != to)

# Small adjusment: put the names in the ids:
# We are working in the interactions dataset with the id's only. Although it's
# perfectly possible, it'd bring always extra steps. So we'll change the ids for
# they

all_interactions <- all_interactions |>
  dplyr::left_join(nodes_main, by = c("from" = "id")) |>
  dplyr::select(from = username, to) |>
  dplyr::left_join(nodes_main, by = c("to" = "id")) |>
  dplyr::select(from, to = username)

# Edge data frame, with all the weights
df_edges <- all_interactions |>
  # counting how many interactions each pair of to/from has
  dplyr::count(from, to, sort = TRUE, name = "weight") |>
  na.omit()

# Tada! Now we have our date ready to be used with the packages!

