## Hertie School - Master of Data Science for Public Policy
## Intro to Data Science Workshop 2022

## Theme: Network analysis with {ggraph} and {tidygraph}
## Instructors: Radwa Adbdelsalam (github.com/Radwa-Radwan)
##              Rodrigo Dornelles (github.com/rfdornelles)



# Fetch data thorough the API ---------------------------------------------
hertie_following <- academictwitteR::get_user_id("thehertieschool") |>
  academictwitteR::get_user_following()

hertie_tweets <- academictwitteR::get_user_timeline(
  "252087644",
  start_tweets = "2022-08-01T00:00:00Z",
  end_tweets = "2022-11-14T00:00:00Z",
  n = Inf)

hertie_following_id <- tibble::tibble(hertie_following)$id

following_tweets <- academictwitteR::get_user_timeline(
  hertie_following_id,
  start_tweets = "2022-08-01T00:00:00Z",
  end_tweets = "2022-11-14T00:00:00Z",
  n = 200)


following_tweets <- tibble::as_tibble(following_tweets)

liked_tweets <- academictwitteR::get_liking_users(hertie_tweets$id)

rt_tweets <- academictwitteR::get_retweeted_by(hertie_tweets$id)

user_dictionary <- users_dict |>
  dplyr::pull(id) |>
  academictwitteR::get_user_profile()

user_dictionary <- tibble::as_tibble(test)


# Export ------------------------------------------------------------------

readr::write_rds(hertie_tweets, "data-raw/hertie_tweets.rds")
readr::write_rds(user_dictionary, "data-raw/users_profile_data.rds")
readr::write_rds(hertie_following, "data-raw/hertie_following_users.rds")
readr::write_rds(following_tweets, "data-raw/hertie_following_tweets.rds",
                 compress = "xz")
readr::write_rds(rt_tweets, "data-raw/rt_tweeets.rds")

