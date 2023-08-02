# What columns are needed?

Task 4 - Halloween Candy Data

We have three spreadsheet files. for 2015, 2016 qnd 2017. This document is to 
try and figure out which columns are necessary to answer the analysis questions.

## Analysis questions:

### Q1
1. What is the total number of candy ratings given across the three years. 
(Number of candy ratings, not the number of raters. Don’t count missing values)

#### 2015 Candy columns:

 * [4] "[Butterfinger]" ... [96] "[York Peppermint Patties]"
 * [114] "[Sea-salt flavored stuff, probably chocolate, since this is the \"it\" flavor of the year]" .. [115] "[Necco Wafers]"                                                              
 
 Questionable non-edilble/candy?
 
 * [18] "[Cash, or other forms of legal tender]"
 * [23] "[Dental paraphenalia]"
* [26] "[Generic Brand Acetaminophen]"                                            
 * [27] "[Glow sticks]"         
 * [28] "[Broken glow stick]"  
TODO ... mores∂
 
 These two columns do contain some candy mentions but a lot of non-candy items
 
 * [98] `"Please list any items not included above that give you JOY."`
 * [99] `"Please list any items not included above that give you DESPAIR."`
 
#### 2016 Candy columns:

* [7] `"[100 Grand Bar]"` ... [106] `"[York Peppermint Patties]"`  

The following column is full of NA values and has the word Ignore in title...
...so we will ignore it.
* `"[York Peppermint Patties] Ignore"`

 These two columns do contain some candy mentions but a lot of non-candy items
 
* [107] `"Please list any items not included above that give you JOY."`
* [108] `"Please list any items not included above that give you DESPAIR." `

#### 2017 Candy columns:

* [7] `"Q6 | 100 Grand Bar"` .. [109] `"Q6 | York Peppermint Patties"`

### Q2
2. What was the average age of people who are going out trick or treating?

#### 2015 Candy columns:

* [2] `"How old are you?"` -  character, contains NAs, text
* [3] `"Are you going actually going trick or treating yourself?"` - Yes/No

#### 2016 Candy columns:

* [4] `"How old are you?"`  -  character, contains NAs, text  
* [2] `"Are you going actually going trick or treating yourself?"` - Yes/No

#### 2017 Candy columns:

*  [4] `"Q3: AGE"`
*  [2] `"Q1: GOING OUT?"`


### Q3
3. What was the average age of people who are not going trick or treating?

#### 2015 Candy columns:

* [2] `"How old are you?"` -  character, contains NAs, text
* [3] `"Are you going actually going trick or treating yourself?"` - Yes/No

#### 2016 Candy columns:

* [4] `"How old are you?"`  -  character, contains NAs, text  
* [2] `"Are you going actually going trick or treating yourself?"` - Yes/No

#### 2017 Candy columns:

*  [4] `"Q3: AGE"`
*  [2] `"Q1: GOING OUT?"`


### Q4
4. For each of joy, despair and meh, which candy bar received the most of these ratings?

#### 2015 Candy columns:

* New columns `candy_name`, `candy_rating`

#### 2016 Candy columns:

* New columns `candy_name`, `candy_rating`

#### 2017 Candy columns:

* New columns `candy_name`, `candy_rating`

### Q5
5. How many people rated Starburst as despair?
For the next three questions, count despair as -1, joy as +1, and meh as 0.

#### 2015 Candy columns:

* New columns `candy_name`, `candy_rating`

#### 2016 Candy columns:

* New columns `candy_name`, `candy_rating`

#### 2017 Candy columns:

* New columns `candy_name`, `candy_rating`


### Q6
6. What was the most popular candy bar by this rating system for each gender in 
the dataset ?

#### 2015 Candy columns:

* New columns `candy_name`, `candy_rating`, `candy_popularity`, `gender`, 

#### 2016 Candy columns:

* New columns `candy_name`, `candy_rating`, `candy_popularity`, `gender` 
(from [3] `"Your gender:"` )

#### 2017 Candy columns:

* New columns `candy_name`, `candy_rating`, `candy_popularity`, `gender` 
(from [3] `"Q2: GENDER"`)

### Q7
7. What was the most popular candy bar in each year?

#### 2015 Candy columns:

* New column `year`, `candy_popularity`

#### 2016 Candy columns:

* New column `year`, `candy_popularity`

#### 2017 Candy columns:

* New column `year`, `candy_popularity`

### Q8
8. What was the most popular candy bar by this rating for people in US, Canada, UK, and all other countries?

#### 2015 Candy columns:

* New column `country`, `candy_popularity`

#### 2016 Candy columns:

* New column `country` (From [5] `"Which country do you live in?"`), 
`candy_popularity`

#### 2017 Candy columns:

* New column `country` (From [5] `"Q4: COUNTRY"`), `candy_popularity`

