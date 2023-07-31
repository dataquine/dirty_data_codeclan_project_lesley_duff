# Author: Lesley Duff
# Filename: cleaning.R
# Title: Clean decathlon data
# Date Created: 2023-07-30
# Description:
#   Data provided as in RDS format is read in, cleaned and output as a CSV file.
#
# Assumptions:
#   Input: the data file is located at "raw_data/decathlon.rds"
#   Output: we assume a folder "clean_data" has already been created and
#     is writable.
#     The cleaned CSV file is output to "clean_data/decathlon.csv"

library(janitor)
library(tidyverse)

# ?read_rds()

# read original decathlon dataset
decathlon_data <- read_rds("raw_data/decathlon.rds")

# Path where cleaned CSV output will be written
decathlon_csv_path <- "clean_data/decathlon.csv"

dim(decathlon_data) # 41 rows, 13 columns
head(decathlon_data)
names(decathlon_data) # Check column names

# column names are mixed case and include full stops
# Suggest janitor

clean_decathlon_data <- decathlon_data %>%
  janitor::clean_names()

names(clean_decathlon_data)
# The names contain variables matching the 10 events listed
# 100 metres,x100m
# Long jump, long_jump
# Shot put, shot_put
# High jump, high_jump
# 400 metres, x400m
# 110 metres hurdles, x110m_hurdle
# Discus throw, discus
# Pole vault, pole_vault
# Javelin throw, javeline
# 1500 metres, x1500m

# extra fields are
# Rank, rank
# Points, points
# Competition, competition

str(clean_decathlon_data)
# All events are numeric
# rank and points are integers
# competition is Factor w/ 2 levels "Decastar","OlympicG"

# This dataset covers results for two separate competitions

# A couple of  column names appear to be slightly different from expected
# Rename 'javeline' to 'javelin'  and
# 'x110m_hurdle' -> 'x110m_hurdles' before more processing
clean_decathlon_data <- clean_decathlon_data %>%
  rename("javelin" = "javeline") %>%
  rename("x110m_hurdles" = "x110m_hurdle")

# The data is in rows with row names indicating which athlete
# Suggest moving these names into a column instead. They are also
# a mix of Title case for OlympicG and UPPERCASE for Decastar event.
decathlon_data <- clean_decathlon_data %>%
  # Turn row names into a column 'athlete'
  rownames_to_column(var = "athlete") %>%
  # Convert e.g. original to title case so they are all the same for consistency
  mutate(athlete = str_to_title(athlete))

length(unique(decathlon_data$athlete))
# There are 32 different athletes in the results

# Write out clean data
# The original .rds format is converted into CSV instead for wider usage.
write_csv(decathlon_data, decathlon_csv_path)
