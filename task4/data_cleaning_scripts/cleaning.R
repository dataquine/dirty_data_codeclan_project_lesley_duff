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
# Produce dataframe of two columns candy_name and candy_rating
get_candy_ratings_2015 <- function(raw_data) {
  # Retrieve candy ratings columns
  candy_ratings <- raw_data %>%
    select("[Butterfinger]":"[York Peppermint Patties]")

  # Turn wide data into long, Analysis asks Don’t count missing values
  # So will drop NAs
  candy_ratings_2015_long <- candy_ratings %>%
    # ?pivot_longer
    pivot_longer("[Butterfinger]":"[York Peppermint Patties]",
      names_to = "candy_name",
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
    select("[100 Grand Bar]":"[York Peppermint Patties]")

  # Turn wide data into long, Analysis asks Don’t count missing values
  # So will drop NAs
  candy_ratings_2016_long <- candy_ratings %>%
    pivot_longer("[100 Grand Bar]":"[York Peppermint Patties]",
      names_to = "candy_name",
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
    select("Q6 | 100 Grand Bar":"Q6 | York Peppermint Patties")
  
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

df_candy_ratings_2015 <- get_candy_ratings_2015(raw_2015)
# dim(df_candy_ratings_2015)
 View(df_candy_ratings_2015)

#df_candy_ratings_2016 <- get_candy_ratings_2016(raw_2016)
# dim(df_candy_ratings_2016)
#View(df_candy_ratings_2016)

#df_candy_ratings_2017 <- get_candy_ratings_2017(raw_2017)
#View(df_candy_ratings_2017)



