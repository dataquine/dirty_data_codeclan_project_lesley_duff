# Helper function for standardising messy country names
source("data_cleaning_scripts/clean_country.R")

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
