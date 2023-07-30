# Author: Lesley Duff
# Filename: cleaning.R
# Title: Clean decathlon data
# Date Created: 2023-07-30
# Description:
#   Data provided as a file "decathlon.rds"

library(janitor)
library(tidyverse)

#?read_rds()

decathlon_data <- read_rds("raw_data/decathlon.rds")

# Check column names
head(decathlon_data)
names(decathlon_data)
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

spec(clean_decathlon_data)

# We notice that the javelin column appears to be slightly misnamed.
# I'll rename 'javeline' to 'javelin'  before more processing
clean_decathlon_data <- clean_decathlon_data %>% 
  rename("javelin" = "javeline")

# The data is in rows with row names indicating which competitor.
# Suggest moving these names into a column instead. They are also
# a mix of sentence case and UPPERCASE.

# Turn row names into a columns



