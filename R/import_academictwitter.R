
hertie_following <- academictwitteR::get_user_id("thehertieschool") |>
  academictwitteR::get_user_following()

readr::write_rds(hertie_following, "data-raw/hertie_following_users.rds")

hertie_tweets <- academictwitteR::get_user_timeline(
  "252087644",
  start_tweets = "2022-08-01T00:00:00Z",
  end_tweets = "2022-11-14T00:00:00Z",
  n = Inf)

readr::write_rds(hertie_tweets, "data-raw/hertie_tweets.rds")

hertie_following_id <- tibble::tibble(hertie_following)$id

following_tweets <- academictwitteR::get_user_timeline(
  hertie_following_id,
  start_tweets = "2022-08-01T00:00:00Z",
  end_tweets = "2022-11-14T00:00:00Z",
  n = 200)

readr::write_rds(following_tweets, "data-raw/hertie_following_tweets.rds",
                 compress = "xz")

following_tweets <- tibble::as_tibble(following_tweets)

following_tweets

liked_tweets <- academictwitteR::get_liking_users(hertie_tweets$id)

rt_tweets <- academictwitteR::get_retweeted_by(hertie_tweets$id)

readr::write_rds(rt_tweets, "data-raw/rt_tweeets.rds")

liked_tweets |>
  tibble::as_tibble() |>
  tibble::view()

liked_tweets |> dplyr::count()

beepr::beep(sound = 8)


