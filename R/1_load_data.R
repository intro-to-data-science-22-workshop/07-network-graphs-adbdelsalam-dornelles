## Hertie School - Master of Data Science for Public Policy
## Intro to Data Science Workshop 2022

## Theme: Network analysis with {ggraph} and {tidygraph}
## Instructors: Radwa Abdelsalam (github.com/Radwa-Radwan)
##              Rodrigo Dornelles (github.com/rfdornelles)

# Load the data -----------------------------------------------------------

# Library {readr}, {tibble} and {dplyr}
library(readr)  # open files such as .rds
library(tibble) # better way to deal with data.frames-ish objects
library(dplyr, warn.conflicts = FALSE)  # manipulate objects very efficiently

# Twitter data ------------------------------------------------------------

# We prepared several datasets containing data collected from Hertie's
# Twitter account. In the extra script we provided all the code necessary to
# manage the {academictwitteR} package and download the data yourself.

# Here, to save time and processing, we'll read the .Rds files in the repo

# FYI, we gathered all tweets from @thehertieschool from 01/08/22 to 14/11/22,
# all its followers and all the accounts that Hertie follows.
# Also, we downloaded up to the 200 most recent tweets of every account
# followed by Hertie in the same period.
# We also downloaded all retweets, likes and replies to @thehertieschool
# Finally, we looked up all users' public profile information (username,
# location, if is a verified account, etc)


# Open .rds files ---------------------------------------------------------

# We're reading all the proper .rds files and transforming it in a tibble
# NOTE: Due its sizes, all the .rds files are compressed. It might cause a
# larger time to read it

# All tweets fom @thehertieschool in the period
hertie_tweets <- read_rds("data-raw/hertie_tweets.rds") |>
  as_tibble()

# Users followed by @thehertieschool
hertie_following_users <- read_rds(
  "data-raw/hertie_following_users.rds") |>
  as_tibble()

# Up to 200 tweets from each account followed by @thehertieschool in the period
all_tweets <- read_rds("data-raw/hertie_following_tweets.rds") |>
  as_tibble()

# Who liked @thehertieschool tweets
liked_hertie <- read_rds("data-raw/liked_tweets.rds") |>
  as_tibble()

# Who retweeted @thehertieschool tweets
rt_hertie <- read_rds("data-raw/rt_tweeets.rds") |>
  as_tibble()

# Data about all users involed (everyone who is followed, rtweeed, liked, etc)
users_profile <- read_rds("data-raw/users_profile_data.rds") |>
  as_tibble()

