#Functions Explained
#Carolyn McNabb

# http://swcarpentry.github.io/r-novice-gapminder/10-functions/index.html

# Questions
# How can I write a new function in R?

# Objectives
# Define a function that takes arguments.
# Return a value from a function.
# Check argument conditions with stopifnot() in functions.
# Test a function.
# Set default values for function arguments.
# Explain why we should divide programs into small, single-purpose functions.

##########
#WHAT IS A FUNCTION?
##########

function(input){
  output <- SomeCommandUsingOur(input)
  return(output)
}
#N.B. we can have more than one input argument and
#more than one output
#the return part is not essential but it cleaner

##########
#DEFINING A FUNCTION
##########
#First let's make a directory called functions

#Define a function to convert temperature 
#from Fahrenheit to Kelvin:
# fahr_to_kelvin <- function(temp) {
#   kelvin <- ((temp - 32) * (5 / 9)) + 273.15
#   return(kelvin)
# }

#let's test our function:
#fahr_to_kelvin(temp)

#CHALLENGE - Write a function called kelvin_to_celsius()
#that takes a temperature in Kelvin and returns that 
#temperature in Celsius.
#Hint: To convert from Kelvin to Celsius you 
#subtract 273.15

#kelvin_to_celsius <- 

#did it work? what is 0 degrees Kelvin in Celcius?
kelvin_to_celcius()
# kelvin_to_celsius(temp = )

##########
#COMBINING FUNCTIONS
##########
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}

#CHALLENGE - Write a function to convert Fehrenheit to 
#Celcius 


#Let's make some cookies!
fahr_to_celsius(temp = 100)


###############
#Defensive Programming
###############
#Preventing misuse of functions / ensuring 
#that functions only work for their intended use

#what if we try to use a character vector 
#instead of numeric value?
fahr_to_kelvin(c("30"))

fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

#CHALLENGE - Use defensive programming to ensure 
#that our fahr_to_celsius() function throws an 
#error immediately if the argument temp is specified 
#inappropriately.

fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

####################
#BACK TO COMBINING FUNCTIONS
####################
#First, let's load the gapminder data
library(gapminder)
gapminder <- gapminder
#or 
gapminder <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv", stringsAsFactors = TRUE)

#check it all looks good
View(gapminder)

#Define a function that calculates the 
#Gross Domestic Product of a nation
#i.e. Takes a dataset and multiply the population 
#column with the GDP per capita column.
calcGDP <- function(dat) {
  gdp <- dat$pop * dat$gdpPercap
  return(gdp)
}

calcGDP(gapminder)
#PRETTY UNHELPFUL!
#We can get more helpful information by including more
#input arguments in our function
#Maybe year and country will be helpful...

calcGDP <- function(dat, year=NULL, country=NULL) {
  #an if statement to tell the function what to do with
  #the year argument
  if(!is.null(year)) {
    dat <- dat[dat$year %in% year, ]
  }
  #an if statement to tell the function what to do with
  #the country argument
  if (!is.null(country)) {
    dat <- dat[dat$country %in% country,]
  }
  #our original calculation but this time incorporating
  #the subsetting that we defined using our year and 
  #country arguments
  gdp <- dat$pop * dat$gdpPercap
  # a new dataframe that concatenates the subsetted
  #gapminder data (dat) with the new gdp vector
  new <- cbind(dat, gdp=gdp)
  #return this output
  return(new)
}

calcGDP(dat = gapminder, country = "New Zealand")
calcGDP(dat = gapminder, year = 2002, country = "New Zealand")

# CHALLENGE - Test out your GDP function by calculating
# the GDP for New Zealand in 1987. 
# How does this differ from New Zealand’s GDP in 1952?

# CHALLENGE - Write a function called fence() that 
# takes two vectors as arguments, called text and 
#wrapper, and prints out the text wrapped with the 
#wrapper:

#fence(text=best_practice, wrapper="***")

########
#Documentation to go alongside your functions
########
#Useful packages: roxygen2, testthat

#############
# Key Points
#############

# Use function to define a new function in R.
# Use parameters to pass values into functions.
# Use stopifnot() to flexibly check function arguments in R.
# Load functions into programs using source().