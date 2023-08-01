# Author: Lesley Duff
# Filename: cleaning.R
# Title: Clean Halloween Candy Data
# Date Created: 2023-07-31
# Description:
#   Data provided as three spreadsheet files to be combined into one dataset.
# boing-boing-candy-2015.xlxs, boing-boing-candy-2016.xlxs and 
# boing-boing-candy-2017.xlxs
#

library(readxl)
library(tidyverse)

halloween_candy_files <- c(halloween_candy_file_2015 = "boing-boing-candy-2015.xlxs", 
                           halloween_candy_file_2016 = "boing-boing-candy-2016.xlxs", 
                           halloween_candy_file_2017 = "boing-boing-candy-2017.xlxs")

raw_2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx")
raw_2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx")
raw_2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx")

View(raw_2015)
View(raw_2016)
View(raw_2017)


names_raw_2017 <- names(raw_2015)
names_raw_2017

names_raw_2016 <- names(raw_2016)
names_raw_2016

names_raw_2017 <- names(raw_2017)
names_raw_2017 