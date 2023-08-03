# Get candy ratings from raw data for 2015
# Produce dataframe of columns age, trick_or_treating, gender, year, country
# candy_name, candy_rating and candy_popularity
get_candy_ratings_2015 <- function(raw_data) {
  # Retrieve candy ratings columns
  candy_ratings <- raw_data %>%
    select(
      age = `How old are you?`,
      trick_or_treating =
        `Are you going actually going trick or treating yourself?`,
      "[Butterfinger]":"[York Peppermint Patties]",
      "[Sea-salt flavored stuff, probably chocolate, since this is the \"it\" flavor of the year]":"[Necco Wafers]"
    )
  
  candy_ratings <- candy_ratings %>%
    # Clean up age field - non numeric become NA
    mutate(
      # N.B. this age conversion may generate warning
      # "NAs introduced by coercion"
      age = as.numeric(age),
      gender = NA,
      year = 2015,
      country = NA
    )
  
  # Turn wide data into long, Analysis asks Don’t count missing values
  # So will drop NAs
  candy_ratings_2015_long <- candy_ratings %>%
    # ?pivot_longer
    pivot_longer(
      cols = c(
        "[Butterfinger]":"[York Peppermint Patties]",
        "[Sea-salt flavored stuff, probably chocolate, since this is the \"it\" flavor of the year]":"[Necco Wafers]"
      ),
      names_to = "candy_name",
      # Remove leading and trailing square brackets
      names_pattern = "^\\[(.*)\\]$",
      values_to = "candy_rating",
      values_drop_na = TRUE
    ) %>%
    mutate(candy_popularity = case_when(
      candy_rating == "DESPAIR" ~ -1,
      candy_rating == "JOY" ~ 1
    )) %>%
    # Check that we don't have NAs in pivoted columns
    verify(!is.na(candy_name)) %>%
    verify(!is.na(candy_rating))
  
  # View(candy_ratings_2015_long)
  return(candy_ratings_2015_long)
}
