## Hertie School - Master of Data Science for Public Policy
## Intro to Data Science Workshop 2022

## Theme: Network analysis with {ggraph} and {tidygraph}
## Instructors: Radwa Abdelsalam (github.com/Radwa-Radwan)
##              Rodrigo Dornelles (github.com/rfdornelles)


# Package installation ----------------------------------------------------

# list the packages used in this presentation

packages <- c(
  "tidyverse", # data wrangle and visualization
  "academictwitteR", # consume Twitter's API
  "tidygraph", # manipulate objects and do graph analysis
  "ggraph" # plot graphs with ggplot2
)


# loop to install the needed package --------------------------------------

# check if the packages are installed

if(sum(as.numeric(!packages %in% installed.packages())) != 0){
  # if not, list those that aren't
  installer <- packages[!packages %in% installed.packages()]

  # then loop them to install
  for(i in 1:length(installer)) {
    install.packages(packages, dependencies = TRUE)
    break()}

}




