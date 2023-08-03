
# Helper function for standardising messy country names
source("data_cleaning_scripts/clean_country.R")

# Get candy ratings from raw data for 2016
# Produce dataframe of columns age, trick_or_treating, gender, year, country
# candy_name, candy_rating and candy_popularity
get_candy_ratings_2016 <- function(raw_data) {
  candy_ratings <- raw_data %>%
    select(
      age = `How old are you?`,
      trick_or_treating =
        `Are you going actually going trick or treating yourself?`,
      gender = `Your gender:`,
      country = `Which country do you live in?`,
      "[100 Grand Bar]":"[York Peppermint Patties]"
    )
  
  # Do search and replace on country column
  candy_ratings <- clean_country(candy_ratings)
  
  # Clean up age field - non numeric become NA
  candy_ratings <- candy_ratings %>%
    mutate(
      # N.B. this age conversion may generate warning
      # "NAs introduced by coercion"
      age = as.numeric(age),
      year = 2016
    ) %>%
    # Move column to same order as 2015
    relocate(country, .after = year)
  
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
    mutate(candy_popularity = case_when(
      candy_rating == "DESPAIR" ~ -1,
      candy_rating == "JOY" ~ 1,
      candy_rating == "MEH" ~ 0
    )) %>%
    # Check that we don't have NAs in pivoted columns
    verify(!is.na(candy_name)) %>%
    verify(!is.na(candy_rating))
  
  # View(candy_ratings_2016_long)
  return(candy_ratings_2016_long)
}