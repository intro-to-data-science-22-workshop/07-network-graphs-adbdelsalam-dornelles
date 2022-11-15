
usernames_following_data <- readRDS("data-raw/usernames_following_data.rds")
#
# results1 <- rtweet::get_timeline(
#   user = usernames_following_data$screen_name
# )

results <- usernames_following$screen_name[1:100] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results, "data-raw/results.rds", compress = "xz")

beepr::beep()

results2 <- usernames_following_data$screen_name[101:300] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results2, "data-raw/results_2.rds", compress = "xz")

beepr::beep()

results3 <- usernames_following_data$screen_name[301:400] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results3, "data-raw/results_3.rds", compress = "xz")

beepr::beep()

results4 <- usernames_following_data$screen_name[401:500] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results4, "data-raw/results_4.rds", compress = "xz")

beepr::beep()

# results5 <- usernames_following_data$screen_name[501:600] |>
#   rtweet::get_timeline(verbose = TRUE)
#
#
# usernames_following_data$screen_name[501:600] |>
#   purrr::map_df()

results5a <- purrr::map(usernames_following_data$screen_name[501:600],
                       ~purrr::safely(rtweet::get_timeline)())

results5 <- results5a |>
  purrr::map_df(
    .f = ~{.x |>
        purrr::pluck("result")}
  )

readr::write_rds(results5, "data-raw/results_5.rds", compress = "xz")

beepr::beep()

results6 <- usernames_following_data$screen_name[601:700] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results6, "data-raw/results_6.rds", compress = "xz")

results7 <- usernames_following_data$screen_name[701:811] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results6, "data-raw/results_7.rds", compress = "xz")

beepr::beep(sound = 4)


# bind rows ---------------------------------------------------------------

df_all_tweets <- fs::dir_info(path = "data-raw", regexp = "results") |>
  dplyr::pull(path) |>
  purrr::map_df(~{print(.x)
    readr::read_rds(.x)})

readr::write_rds(df_all_tweets, "data-raw/all_tweets.rds", compress = "xz")

# results1 <- readr::read_rds("data-raw/results.rds")
# results2 <- readr::read_rds("data-raw/results_2.rds")
# results3 <- readr::read_rds("data-raw/results_3.rds")
# results4 <- readr::read_rds("data-raw/results_4.rds")
# results5 <- readr::read_rds("data-raw/results_5.rds")
# results6 <- readr::read_rds("data-raw/results_6.rds")
# results7 <- readr::read_rds("data-raw/results_7.rds")
#
# janitor::compare_df_cols_same(results1, results2, results3, results4, results5,
#                            results6, results7)
