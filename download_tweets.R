
usernames_following_data <- readRDS("data-raw/usernames_following_data.rds")
#
# results1 <- rtweet::get_timeline(
#   user = usernames_following_data$screen_name
# )

results <- usernames_following_data$screen_name[1:100] |>
  rtweet::get_timeline(verbose = TRUE)

beepr::beep()

results2 <- usernames_following_data$screen_name[101:300] |>
  rtweet::get_timeline(verbose = TRUE)

beepr::beep()

results3 <- usernames_following_data$screen_name[301:600] |>
  rtweet::get_timeline(verbose = TRUE)

beepr::beep()

results4 <- usernames_following_data$screen_name[601:811] |>
  rtweet::get_timeline(verbose = TRUE)

beepr::beep(sound = 4)

