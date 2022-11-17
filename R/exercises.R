#Load required libraries


# create final edgelist
mp_edgelist <- create_edgelist(results)

# create vertex dataframe
mp_vertices <- results %>%
  select(screen_name, profile_image_url, followers_count) %>%
  distinct() |>
  left_join(
    mp_list |>
      dplyr::mutate(
        screen_name = substr(Screen.name, 2, nchar(Screen.name))
      ) |>
      dplyr::select(
        screen_name,
        constituency = Constituency,
        party = Party,
        name = Name
      )
  )

#create a unique colour for each party. Hint: use unique() function

parties <- mp_vertices$party |> unique()
party_colours <- c("#000000", "#216a4d", "#008a49",
                   "#d3c200", "#3d8028", "#f5b52e",
                   "#dd0339", "#cccccc", "#66ab21",
                   "#c2282a", "#018fda", "#eec52e")

#transform the color set into a dataframe and bind it to the main dataframe using left_join()

color_df <- data.frame(
  party = parties,
  colour = party_colours
)

mp_vertices <- mp_vertices |>
  left_join(color_df)

#create a final edge list

mp_edgelist <- mp_edgelist |>
  dplyr::filter(to %in% mp_vertices$screen_name)


#set the nodes and the edges

mp_graph <- tbl_graph(nodes = mp_vertices,
                          edges = mp_edgelist,
                          directed = F)


#activate the nodes/vertices and edges. Create communities

mp_vertex_list <- mp_vertices %>%
  activate(nodes) %>%
  as_tibble()





