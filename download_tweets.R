
usernames_following_data <- readRDS("data-raw/usernames_following_data.rds")
#
# results1 <- rtweet::get_timeline(
#   user = usernames_following_data$screen_name
# )

results <- usernames_following_data$screen_name[1:100] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results, "data-raw/results.rds")

beepr::beep()

results2 <- usernames_following_data$screen_name[101:300] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results2, "data-raw/results_2.rds")

beepr::beep()

results3 <- usernames_following_data$screen_name[301:400] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results3, "data-raw/results_3.rds")

beepr::beep()

results4 <- usernames_following_data$screen_name[401:500] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results4, "data-raw/results_4.rds")

beepr::beep()

results5 <- usernames_following_data$screen_name[501:600] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results5, "data-raw/results_5.rds")

beepr::beep()

results6 <- usernames_following_data$screen_name[601:700] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results6, "data-raw/results_6.rds")

results7 <- usernames_following_data$screen_name[701:811] |>
  rtweet::get_timeline(verbose = TRUE)

readr::write_rds(results6, "data-raw/results_7.rds")

beepr::beep(sound = 4)

# dplyr::bind_rows(r)
