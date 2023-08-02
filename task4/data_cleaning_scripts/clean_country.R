# Author: Lesley Duff
# Filename: clean_country.R
# Title: Clean messy country names
# Date Created: 2023-08-02
# Description:
#  The countries come from free text entry fields and people filling in the 
# survey have given many various, often humourous representations of country 
# names, or have e.g. given American state names instead of the country.
# This helper function relies on some hard coding to standardise

# Take a dataframe with a user supplied country column and adjust to make sure
# that the main countries in question 8 of the analysis US, Canada, UK are 
# represented as accurately as possible
# Particularly for US many references are jokey as if being chanted.
# Some users have entered the name of US states instead of their country.
# For Canada there are some punctuation typos
# For UK there are misspellings of United Kingdom and individual countries such
# as Scotland and England.
clean_country <- function (raw_data){
  cleaned_data <- raw_data %>% 
    mutate(
          # case change to make string compares simpler
           country = str_to_upper(country),
           country = str_replace(country, "USA", "US"),
           country = str_replace(country, "ALASKA", "US"),
           country = str_replace(country, "CALIFORNIA", "US"),
           country = str_replace(country, "NORTH CAROLINA", "US"),
           country = str_replace(country, "NEW JERSEY", "US"),
           country = str_replace(country, "NEW YORK", "US"),
           country = str_replace(country, "PITTSBURGH", "US"),
           country = str_replace(country, "THE YOO ESS OF AAAYYYYYY", "US"),
           country = str_replace(country, "TRUMPISTAN", "US"),
  
           country = str_replace(country, "ENGLAND", "UK"),
           country = str_replace(country, "SCOTLAND", "UK"),
           country = str_replace(country, "UNITED KINGDOM", "UK"),
           
           country = if_else(str_detect(country, "AMER"), "US", country),
           country = if_else(str_detect(country, "MERICA"), "US", country),
           country = if_else(str_detect(country, "MURICA"), "US", country),
           country = if_else(str_detect(country, "MURRIKA"), "US", country),
           country = if_else(str_detect(country, " US$"), "US", country),
           country = if_else(str_detect(country, "^U S"), "US", country),
           country = if_else(str_detect(country, "^US.*"), "US", country),
           country = if_else(str_detect(country, "^U.S.*"), "US", country),
           country = if_else(str_detect(country, "UNIT.* S"), "US", country),
           
           country = if_else(str_detect(country, "CANADA"), "CANADA", country),
           
           country = if_else(str_detect(country, "UNITED KIN"), "UK", country),

           # 3 letters or less usually Acronmym           
           country = if_else(str_length(country) < 4, country, 
                             str_to_title(country)),
           )
  return (cleaned_data)
}

# Test data/code
#df_test <- data.frame(
#  country <-  c("New York", "Canada'", "United Kingdom")
#)

#clean_country(df_test)