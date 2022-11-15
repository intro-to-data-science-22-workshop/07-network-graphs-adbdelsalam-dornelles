# install.packages("rtweet")
# library(rtweet)
# library(tidyverse)
#
# auth_setup_default()

followers <- get_followers("thehertieschool", n=Inf)
following <- get_friends("thehertieschool", n=Inf)
mentions <- get_mentions("thehertieschool", n=Inf)
tweets <- search_tweets("data science and politics", n=Inf)
tweets_2 <- search_tweets("data science", n=Inf)
tweets_3 <- search_tweets("data science masters", n=Inf)
tweets_berlin <- search_tweets("data science berlin", n=Inf)

write_rds(followers, "data-raw/followers_data.rds")
write_rds(following, "data-raw/following_data.rds")
write_rds(tweets, "data-raw/tweets_data.rds")
write_rds(tweets_3, "data-raw/tweets_3_data.rds")
write_rds(tweets_berlin, "data-raw/tweets_berlin_data.rds")
write_rds(tweets_2, "data-raw/tweets_2_data.rds")

usernames_following <- lookup_users(following$to_id)
write_rds(usernames_following, "data-raw/usernames_following_data.rds",
          compress = "xz")
usernames_followers <- lookup_users(followers$from_id)
write_rds(usernames_followers, "data-raw/usernames_followers_data.rds",
          compress = "xz")
