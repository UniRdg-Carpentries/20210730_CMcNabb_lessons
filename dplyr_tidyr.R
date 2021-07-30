#Data Wrangling with dplyr and tidyr
#Carolyn McNabb

#https://datacarpentry.org/r-socialsci/03-dplyr-tidyr/index.html

# Questions
# How can I select specific rows and/or columns from a dataframe?
# How can I combine multiple commands into a single command?
# How can I create new columns or remove existing columns from a dataframe?
# How can I reformat a dataframe to meet my needs?
  
# Objectives
# Describe the purpose of an R package and the dplyr and tidyr packages.
# Select certain columns in a dataframe with the dplyr function select.
# Select certain rows in a dataframe according to filtering conditions with the dplyr function filter.
# Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
# Add new columns to a dataframe that are functions of existing columns with mutate.
# Use the split-apply-combine concept for data analysis.
# Use summarize, group_by, and count to split a dataframe into groups of observations, apply a summary statistics for each group, and then combine the results.
# Describe the concept of a wide and a long table format and for which purpose those formats are useful.
# Describe the roles of variable names and their associated values when a table is reshaped.
# Reshape a dataframe from long to wide format and back with the pivot_wider and pivot_longer commands from the tidyr package.
# Export a dataframe to a csv file.

########
#LOAD TIDYVERSE
########
#tidyverse contains dplyr, tidyr and ggplot2
library(tidyverse)
#if you don't have tidyverse,use 
#install.packages("tidyverse")
#then load again using library(tidyverse)

#dplyr can be used to extract and summarize information 
#from your data. 
#tidyr enables you to swiftly convert between different 
#data formats (long vs. wide) for plotting and analysis.
#ggplot2 makes beautiful plots

#Download the data we need for this lesson:
interviews <- read_csv("https://ndownloader.figshare.com/files/11492171", na="NULL")
View(interviews)

#######
#Selecting columns and filtering rows
#######
#Basically like subsetting!

#The select() function:
?select()
# to select columns throughout the dataframe
select(interviews, village, no_membrs, months_lack_food)
#is equivalent to:
interviews[c("village","no_membrs","months_lack_food")]

# to select a series of connected columns
select(interviews, village:respondent_wall_type)
#is equivalent to:
interviews[2:6]

#The filter() function
?dplyr::filter()
# filters observations where village name is "Chirodzo" 
filter(interviews, village == "Chirodzo")
#is equivalent to:
interviews[interviews$village == "Chirodzo",]

#FILTERING BY MULTIPLE CONDITIONS
# To form “and” statements within dplyr, 
# we can pass our desired conditions as 
# arguments in the filter() function, separated by commas:
filter(interviews, village == "Chirodzo", 
       rooms > 1, 
       no_meals > 2)
#alternatively:
filter(interviews, village == "Chirodzo" &
       rooms > 1 &
       no_meals > 2)
#is equivalent to:
interviews[interviews$village== "Chirodzo" &
             interviews$rooms > 1 &
             interviews$no_meals > 2,]

#To form "or" statements, we use | operator
filter(interviews, village == "Chirodzo" | village == "Ruaca")
#is equivalent to:
interviews[interviews$village == "Chirodzo" | 
             interviews$village == "Ruaca",]

#########
#PIPES (a blessing and a curse)
#Use in moderation
#########
#Combines steps to make your code more compact
#WARNING: compact doesn't mean easily interpretable
#ANOTHER WARNING: lots of piping = hard to debug

#Let's say we want to filter and select some data
interviews2 <- filter(interviews, village == "Chirodzo")
interviews_ch <- select(interviews2, village:respondent_wall_type)

#we could nest these two commands
#instead of using "interviews2" as our row input, 
#we replace it with the command we used to calculate
#interviews2
interviews_ch <- select(filter(interviews, village == "Chirodzo"),
                        village:respondent_wall_type)

#PIPING! An alternative to nesting
# uses %>% (ctrl + shift + M) or (cmd + shift + M)
#from magrittr() package, installed with dplyr

#so... instead of:

output_a <- function1(input,arguments1)
output_b <- function2(output_a,arguments2)

#we can use:
output <-  input %>% 
  function1(arguments) %>% 
  function2(arguments)

#this is great! but be careful of

output <-  input %>% 
  function1(arguments) %>% 
  function2(arguments) %>% 
  function3(arguments) %>% 
  function4(arguments) %>% 
  function5(arguments) %>% 
  function6(arguments) 

#let's give it a go!
interviews2 <- filter(interviews, village == "Chirodzo")
interviews_ch <- select(interviews2, village:respondent_wall_type)

# interviews_ch <- interviews %>%
#   filter(village == "Chirodzo") %>%
#   select(village:respondent_wall_type)

# CHALLENGE - Using pipes, subset the interviews data to include 
# interviews where respondents were members of an irrigation 
# association (memb_assoc) and retain only the columns 
# affect_conflicts, liv_count, and no_meals.


##########
#MUTATE
##########
?mutate()

#let's say we want to add a variable to our interviews
#dataframe telling us the ration of number of household 
#members to rooms used for sleeping

interviews <- interviews %>%
  mutate(people_per_room = no_membrs / rooms)
#equivalent to:
interviews$people_per_room <- interviews$no_membrs/interviews$rooms

#PUTTING IT ALL TOGETHER
#investigate whether being a member of an irrigation 
#association had any effect on the ratio of household 
#members to rooms

irrigation <- interviews %>%
  filter(!is.na(memb_assoc)) %>%
  mutate(people_per_room = no_membrs / rooms)
View(irrigation)

#CHALLENGE - Create a new dataframe from the interviews 
#data that meets the following criteria: contains only 
#the village column and a new column called total_meals 
#containing a value that is equal to the total number of 
#meals served in the household per day on average 
#(no_membrs times no_meals). Only the rows where 
#total_meals is greater than 20 should be shown in the 
#final dataframe.

#Hint: think about how the commands should be ordered to 
#produce this data frame!

##########
#Split-apply-combine and summarize()
##########
# using
?group_by()
# and 
?summarize()

# if we want to compute the average household size by village:
interviews %>% 
  group_by(village) %>% #here we are grouping by village
  summarize(mean_no_membrs = mean(no_membrs))#here we are 
  #getting the mean number of household members **per group**

#we can also group by multiple columns:
interviews %>%
  group_by(village, memb_assoc) %>% #here we specify groups by 
  #village & member_assoc
  summarize(mean_no_membrs = mean(no_membrs))#and then get the 
  #mean for each subgroup

#we can ungroup the tibble by using ungroup()

#we have some people that didn't specify if they were part of
#a member association - we can filter these people out before
#we do our grouping to make our data cleaner

interviews %>%
  filter(!is.na(memb_assoc)) %>% #exclude rows where memb_assoc is NA
  group_by(village, memb_assoc) %>% #group by village and memb_assoc
  summarize(mean_no_membrs = mean(no_membrs), 
            min_membrs = min(no_membrs))#get mean and min for 
  #each of these subgroups

#we can also sort our output using arrange()
interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs),
            min_membrs = min(no_membrs)) %>%
  arrange(desc(min_membrs)) #sort by descending order of min_members

#we can also count the number of observations for each factor
#or combination of factors
interviews %>%
  count(village)


#CHALLENGE - How many households in the survey have an average of 
#two meals per day? Three meals per day? Are there any other numbers 
#of meals represented?
# Use group_by() and summarize() to find the mean, min, and max 
# number of household members for each village. Also add the number 
# of observations (hint: see ?n).
# What was the largest household interviewed in each month?

##########
#RESHAPING
##########
# Three rules that define a “tidy” dataset:
# 1. Each variable has its own column
# 2. Each observation has its own row
# 3. Each value must have its own cell
# But we may want to move our data round depending on the type of 
# analysis we want to run.
View(interviews)

# Wide and long data formats
my_wide_data <- as.data.frame(list(x=c(10,15,20), 
                              y1=c(2,0,1),
                              y2=c(3,4,4),
                              y3=c(4,6,5)))
print(my_wide_data)

#wide data is easy for us humans to read but not so much for computers
#Computers prefer long data formats

my_long_data <- pivot_longer(my_wide_data, cols = y1:y3, 
                             names_to = "Variable", 
                             values_to = "Response")
my_long_data$Variable <- as.factor(my_long_data$Variable)
print(my_long_data)

#every now and then, R might want your data in wide format
#so it's good to know how to change it back
back_to_wide <- pivot_wider(my_long_data,
                            names_from = Variable,
                            values_from = Response)

print(back_to_wide)

#let's quickly try it on some of our data from yesterday
#First let's make it simpler to work with - let's say we 
#are only interested in country, year and gdpPercap
little_gap <- gapminder %>% select(country,
                                   year,
                                   gdpPercap)
View(little_gap)

wide_gap <- pivot_wider(little_gap, 
           names_from = year,
           values_from = gdpPercap)
View(wide_gap)


#For more on pivot_long and pivot_wide, see these websites:
#https://datacarpentry.org/r-socialsci/03-dplyr-tidyr/index.html 
#https://medium.com/the-codehub/beginners-guide-to-pivoting-data-frames-in-r-1de608e914b6
#https://cmdlinetips.com/2020/11/reshape-tidy-data-to-wide-data-with-pivot_wider-from-tidyr/

##########
# Exporting datadata
##########
#sometimes we want to export our data so that it can be used
#by others, e.g. if we have used R to de-identify and clean
#a dataset and we want to make it available on the OSF.

#There are lots of ways to export data (e.g. plots can be saved
#as pdfs, or we might want to save a dataframe or a list). For 
#now, let's just export a csv file

write_csv(my_long_data,
          path = "data/play_data.csv")
