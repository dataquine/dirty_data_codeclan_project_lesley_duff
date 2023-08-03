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
library(janitor)
library(readxl)
library(tidyverse)

raw_2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx")
raw_2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx")
raw_2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx")

# View(raw_2015)
# View(raw_2016)
# View(raw_2017)

# Helper function for standardising messy country names
source("data_cleaning_scripts/clean_country.R")

# Code specific to the structure of individual years
source("data_cleaning_scripts/get_candy_ratings_2015.R")
source("data_cleaning_scripts/get_candy_ratings_2016.R")




# Get candy ratings from raw data for 2017
# Produce dataframe of columns age, trick_or_treating, gender, year, country
# candy_name, candy_rating and candy_popularity
get_candy_ratings_2017 <- function(raw_data) {
  #  view(raw_data)
  candy_ratings <- raw_data %>%
    select(
      age = `Q3: AGE`,
      trick_or_treating = `Q1: GOING OUT?`,
      gender = `Q2: GENDER`,
      country = `Q4: COUNTRY`,
      "Q6 | 100 Grand Bar":"Q6 | York Peppermint Patties"
    )

  # Clean up age field - non numeric become NA, field type becomes numeric
  candy_ratings <- candy_ratings %>%
    mutate(
      age = as.numeric(age),
      year = 2017
    ) %>%
    # Move column to same order as 2015
    relocate(country, .after = year)

  # Do search and replace on country column
  candy_ratings <- clean_country(candy_ratings)

  candy_ratings_2017_long <- candy_ratings %>%
    pivot_longer("Q6 | 100 Grand Bar":"Q6 | York Peppermint Patties",
      names_to = "candy_name",
      names_prefix = "Q6 \\| ",
      values_to = "candy_rating",
      values_drop_na = TRUE
    ) %>%
    mutate(candy_popularity = case_when(
      candy_rating == "DESPAIR" ~ -1,
      candy_rating == "JOY" ~ 1,
      candy_rating == "MEH" ~ 0
    )) %>%
    # Check that we don't have NAs in pivoted columns
    verify(!is.na(candy_name)) %>%
    verify(!is.na(candy_rating))

  return(candy_ratings_2017_long)
}

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

candy_ratings_2015 <- get_candy_ratings_2015(raw_2015)
# dim(candy_ratings_2015)
# View(candy_ratings_2015)

candy_ratings_2016 <- get_candy_ratings_2016(raw_2016)
# dim(candy_ratings_2016)
# View(candy_ratings_2016)

candy_ratings_2017 <- get_candy_ratings_2017(raw_2017)
# dim(candy_ratings_2017)
# View(candy_ratings_2017)

# Create list of data frames using list()
list_candy_ratings <- list(
  candy_ratings_2015,
  candy_ratings_2016,
  candy_ratings_2017
)

candy_ratings <- combine_candy_ratings(list_candy_ratings)
# dim (candy_ratings) #
# View(candy_ratings)

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
