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

halloween_candy_files <- c(
  halloween_candy_file_2015 = "boing-boing-candy-2015.xlxs",
  halloween_candy_file_2016 = "boing-boing-candy-2016.xlxs",
  halloween_candy_file_2017 = "boing-boing-candy-2017.xlxs"
)

raw_2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx")
raw_2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx")
raw_2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx")

# View(raw_2015)
# View(raw_2016)
# View(raw_2017)

# Get candy ratings from raw data for 2015
# Produce dataframe of found columns age, trick_or_treating, candy_name and 
# candy_rating
get_candy_ratings_2015 <- function(raw_data) {
  # Retrieve candy ratings columns
  candy_ratings <- raw_data %>%
    select(
      age = `How old are you?`,
      trick_or_treating = `Are you going actually going trick or treating yourself?`,
      "[Butterfinger]":"[York Peppermint Patties]",
      "[Sea-salt flavored stuff, probably chocolate, since this is the \"it\" flavor of the year]":"[Necco Wafers]"
    )
 
  candy_ratings <- candy_ratings %>% 
    # Clean up age field - non numeric become NA
    mutate(
      age = as.numeric(age),
      gender = NA)

  # Turn wide data into long, Analysis asks Don’t count missing values
  # So will drop NAs
  candy_ratings_2015_long <- candy_ratings %>%
    # ?pivot_longer
    pivot_longer(
      cols = c(
        "[Butterfinger]":"[York Peppermint Patties]",
        "[Sea-salt flavored stuff, probably chocolate, since this is the \"it\" flavor of the year]":"[Necco Wafers]"),
      names_to = "candy_name",
      # Remove leading and trailing square brackets
      names_pattern = "^\\[(.*)\\]$",
      values_to = "candy_rating",
      values_drop_na = TRUE
    ) %>%
    # Check that we don't have NAs in new columns
    verify(!is.na(candy_name)) %>%
    verify(!is.na(candy_rating))

  # View(candy_ratings_2015_long)

  return(candy_ratings_2015_long)
}

# Get candy ratings from raw data for 2016
# Produce dataframe of two columns candy_name and candy_rating
get_candy_ratings_2016 <- function(raw_data) {
  candy_ratings <- raw_data %>%
    select(
      age = `How old are you?`,
      trick_or_treating = `Are you going actually going trick or treating yourself?`,
      gender = `Your gender:`,
      "[100 Grand Bar]":"[York Peppermint Patties]")

  # Clean up age field - non numeric become NA
  candy_ratings <- candy_ratings %>% 
    mutate(age = as.numeric(age))
  
  # Turn wide data into long, Analysis asks Don’t count missing values
  # So will drop NAs
  candy_ratings_2016_long <- candy_ratings %>%
    pivot_longer("[100 Grand Bar]":"[York Peppermint Patties]",
      names_to = "candy_name",
      # Remove leading and trailing square brackets
      names_pattern = "^\\[(.*)\\]$",
      values_to = "candy_rating",
      values_drop_na = TRUE
    ) %>%
    # Check that we don't have NAs in new columns
    verify(!is.na(candy_name)) %>%
    verify(!is.na(candy_rating))

#  View(candy_ratings_2016_long)
  return(candy_ratings_2016_long)
}

# Get candy ratings from raw data for 2017
get_candy_ratings_2017 <- function(raw_data) {
#  view(raw_data)
  candy_ratings <- raw_data %>%
    select(
      age = `Q3: AGE`,
      trick_or_treating = `Q1: GOING OUT?`,
      gender = `Q2: GENDER`,
      "Q6 | 100 Grand Bar":"Q6 | York Peppermint Patties")

  # Clean up age field - non numeric become NA, field type becomes numeric
  candy_ratings <- candy_ratings %>% 
    mutate(age = as.numeric(age))
  
  candy_ratings_2017_long <- candy_ratings %>%
    pivot_longer("Q6 | 100 Grand Bar":"Q6 | York Peppermint Patties",
                 names_to = "candy_name",
                 names_prefix = "Q6 \\| ",
                 values_to = "candy_rating", 
                 values_drop_na = TRUE
    ) %>%
    # Check that we don't have NAs in new columns
    verify(!is.na(candy_name)) %>%
    verify(!is.na(candy_rating))
  
  return(candy_ratings_2017_long)
}

# We are assuming that all ratings are dataframes of two columns candy_name and
# candy_rating
combine_candy_ratings <- function(list_candy_ratings){
  stopifnot(
    is.list(list_candy_ratings)
  )
  
  combined_candy_ratings <- bind_rows(list_candy_ratings)
  return (combined_candy_ratings)
  #dim(result)
  #View(result)
  #str(result)
  # 762355
  # 468510, 118290, 175555
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
  
  #View(popularity_candy_names)
  
  alphabetical_candy_names <- candy_ratings %>% 
    select(candy_name) %>% 
    group_by(candy_name) %>% 
    summarise(num_candy = n()) %>% 
    arrange(candy_name)

  #View(alphabetical_candy_names)
  return(list(popularity_candy_names, alphabetical_candy_names))
}

candy_ratings_2015 <- get_candy_ratings_2015(raw_2015)
# dim(candy_ratings_2015) 
#View(candy_ratings_2015)

candy_ratings_2016 <- get_candy_ratings_2016(raw_2016)
#dim(candy_ratings_2016)
#View(candy_ratings_2016)

candy_ratings_2017 <- get_candy_ratings_2017(raw_2017)
#dim(candy_ratings_2017)
#View(candy_ratings_2017)

# Create list of data frames using list()
list_candy_ratings = list(candy_ratings_2015, 
                          candy_ratings_2016, 
                          candy_ratings_2017)

candy_ratings <- combine_candy_ratings(list_candy_ratings)
#dim (candy_ratings) # 
#View(candy_ratings)

examined <- examine_candy_ratings(candy_ratings)
#examined[[1]]
#examined[[2]]

# Write out clean data
# The original .rds format is converted into CSV instead for wider usage.

path_clean_csv_data <- "clean_data/halloween_candy.csv"
write_csv(candy_ratings, path_clean_csv_data)
