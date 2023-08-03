# Author: Lesley Duff
# Filename: cleaning.R
# Title: Clean Halloween Candy Data
# Date Created: 2023-07-31
# Description:
#   Data provided as three spreadsheet files to be combined into one dataset.
# boing-boing-candy-2015.xlxs, boing-boing-candy-2016.xlxs and
# boing-boing-candy-2017.xlxs
#

library(assertr)
library(readxl)
library(tidyverse)

# Year specific helper functions ----
# Code specific to wrangling individual years
source("data_cleaning_scripts/get_candy_ratings_2015.R")
source("data_cleaning_scripts/get_candy_ratings_2016.R")
source("data_cleaning_scripts/get_candy_ratings_2017.R")

# Combining and examining data structure functions ----
# Join all our spreadsheet dataframes together into a single large dataframe
# We are assuming that all ratings are dataframes with the same columns
combine_candy_ratings <- function(list_candy_ratings) {
  # Stop if a list has not been passed into the function
  stopifnot(
    is.list(list_candy_ratings)
  )

  # Append each dataframe in list
  combined_candy_ratings <- bind_rows(list_candy_ratings)
  return(combined_candy_ratings)
}

# Make sure columns contain expected values
check_ratings <- function(ratings) {
  ratings <- ratings %>%
    # Set age as NA if not reasonable age
    # Oldest known individual who ever lived
    # https://en.wikipedia.org/wiki/List_of_the_verified_oldest_people
    # As of 2023-01-02 we will suggest a maximum of 123
    # If we have an age is it age >2 <123
    # We assume entries for young children may have been added by parents
    mutate(
      age = if_else(age > 2 & age < 123, age, NA)
    ) %>%
    assert(in_set("No", "Yes"), trick_or_treating) %>%
    assert(in_set("Male", "Female", "Other", "I'd rather not say"), gender) %>%
    assert(in_set(2015:2017), year) %>%
    assert(in_set("DESPAIR", "JOY", "MEH"), candy_rating) %>%
    assert(in_set(-1, 0, 1), candy_popularity) #  %>%

  # print(sort(unique(ratings$country)))
  # View(ratings)
  return(ratings)
}

# Exploratory examination returning list of dataframes
# 1 - Candy names by popularity
# 2 - Candy names by alphabetical name
examine_candy_ratings <- function(candy_ratings) {
  popularity_candy_names <- candy_ratings %>%
    select(candy_name) %>%
    group_by(candy_name) %>%
    summarise(num_candy = n()) %>%
    arrange(desc(num_candy))

  # View(popularity_candy_names)

  alphabetical_candy_names <- candy_ratings %>%
    select(candy_name) %>%
    group_by(candy_name) %>%
    summarise(num_candy = n()) %>%
    arrange(candy_name)

  # View(alphabetical_candy_names)
  return(list(popularity_candy_names, alphabetical_candy_names))
}

# Process each year of data ----

# Process 2015 ----
raw_2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx")

candy_ratings_2015 <- get_candy_ratings_2015(raw_2015)
# dim(candy_ratings_2015)
# View(candy_ratings_2015)
rm(raw_2015)

# Process 2016 ----
raw_2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx")

candy_ratings_2016 <- get_candy_ratings_2016(raw_2016)
# dim(candy_ratings_2016)
# View(candy_ratings_2016)
rm(raw_2016)

# Process 2017 ----
raw_2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx")

candy_ratings_2017 <- get_candy_ratings_2017(raw_2017)
# dim(candy_ratings_2017)
# View(candy_ratings_2017)
rm(raw_2017)

# Generate combined data structure ----
# Create list of data frames for every year in the analysis
list_candy_ratings <- list(
  candy_ratings_2015,
  candy_ratings_2016,
  candy_ratings_2017
)

rm(candy_ratings_2015, candy_ratings_2016, candy_ratings_2017)
candy_ratings <- combine_candy_ratings(list_candy_ratings)
# dim (candy_ratings) #
# View(candy_ratings)

rm(list_candy_ratings)
candy_ratings <- check_ratings(candy_ratings)

# examined <- examine_candy_ratings(candy_ratings)
# examined[[1]]
# examined[[2]]

# Write out clean data
# The original .rds format is converted into CSV instead for wider usage.
# N.B. This approach takes considerably more disk space than the original
# spreadsheet versions but makes the analysis phases more straightforward.
path_clean_csv_data <- "clean_data/halloween_candy.csv"
write_csv(candy_ratings, path_clean_csv_data)
rm(candy_ratings)