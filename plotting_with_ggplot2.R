#Creating Publication-Quality Graphics with ggplot2
#Carolyn McNabb

#http://swcarpentry.github.io/r-novice-gapminder/08-plot-ggplot2/index.html

# Questions
# How can I create publication-quality graphics in R?
 
# Objectives
# To be able to use ggplot2 to generate publication quality graphics.
# To apply geometry, aesthetic, and statistics layers to a ggplot plot.
# To manipulate the aesthetics of a plot using different colors, shapes, and lines.
# To improve data visualization through transforming scales and paneling by group.
# To save a plot created with ggplot to disk.

#let's refresh our gapminder dataframe first
gapminder <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv", stringsAsFactors = TRUE)

#Now let's learn a little bit about ggplot2
#ggplot2 is built on the grammar of graphics, 
#the idea that any plot can be expressed from the 
#same set of components: a data set, a coordinate 
#system, and a set of geoms – the visual 
#representation of data points.

library(ggplot2)
#how to use ggplot...
#CHEATSHEET HERE:
# https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf

#The basic formula
ggplot(data = your_data, 
       mapping = aes(x=independent_variable,
                     y=dependent_variable)) +
  geom_something()

#let's try it:
ggplot(data = gapminder, 
       mapping = aes(x = gdpPercap, 
                     y = lifeExp)) +
  geom_point() # scatter plot of data
#The first part of the command doesn't plot any data
#it's the geom_* part that tells ggplot what to do 

# CHALLENGE - Modify the example so that the figure shows how life 
# expectancy has changed over time:
ggplot(data = gapminder, 
       mapping = aes(x = year, 
                     y = lifeExp)) + 
  geom_point()

#CHALLENGE - In the previous examples and challenge 
# we’ve used the aes function to tell the scatterplot 
# geom about the x and y locations of each point. 
# Another aesthetic property we can modify is the point 
# color. Modify the code from the previous challenge 
# to color the points by the “continent” column. What 
# trends do you see in the data? Are they what you 
# expected?

ggplot(data = gapminder, 
       mapping = aes(x = year, 
                     y = lifeExp,
                     colour = continent)) + 
  geom_point()

#########
#LAYERS
#########
#As well as geom_point,there are many other ways to layer
#your data
#Take a look at the cheatsheet
# https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf
#Let's try a few:
ggplot(data = gapminder, 
       mapping = aes(x=year, #our x axis
                     y=lifeExp, # our y axis
                     by = country, # by aesthetic, 
                     #tells ggplot to draw a line for each country
                     color=continent)) + # colour the data by continent
  geom_line() #draw the data as a line


#we can also layer these on top of one another (e.g. points and lines)
ggplot(data = gapminder, 
       mapping = aes(x=year, #our x axis
                     y=lifeExp, # our y axis
                     by = country, # by aesthetic, 
                     #tells ggplot to draw a line for each country
                     color=continent)) + # colour the data by continent
  geom_line() + #draw the data as a line
  geom_point() #also add points to my graph

#maybe we want to make our lines different colours but we want our points 
#to stay black... to do this, we can apply aes within our layers:
ggplot(data = gapminder, 
       mapping = aes(x=year, 
                     y=lifeExp, 
                     by=country
                     )) + #notice we've removed colour from our aes
  geom_line(mapping = aes(color=continent)) + #and we've added it to geom_line
  geom_point() #but there is nothing assigning colour to the points

#we could also make all of our geom_points blue if we wanted
ggplot(data = gapminder, 
       mapping = aes(x=year, 
                     y=lifeExp, 
                     by=country)) + #notice we've removed colour from our aes
  geom_line(mapping = aes(color=continent)) + #and we've added it to geom_line
  geom_point(colour = "navyblue") #but there is nothing assigning colour to the points

#ggplot can take colour arguments as character vectors (e.g. "darkblue") as well
#as hex code (e.g. #001E6C)

#Here are some cool places to find colour references for use with ggplot2
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
# https://colorhunt.co/
# https://color.hailpixel.com/ 

#CHALLENGE - Switch the order of the point and line layers from the previous example. 
#What happened?

#########
#ADDING STATS LAYERS
#########
#ggplot2 also makes it easy to overlay statistical models over the data
#Back to our initial plot:
#Notice that I've simplified the code (but it will still work the same)
ggplot(gapminder, 
       aes(gdpPercap, lifeExp)) +
  geom_point()

#Let's say we want to display the log of our data instead
ggplot(gapminder, 
       aes(gdpPercap, lifeExp)) +
  geom_point(alpha = 0.2) + 
  scale_x_log10()
#we saw how geom_smooth() added a smooth line and standard error
#let's add it again here:
ggplot(gapminder, 
       aes(gdpPercap, lifeExp)) +
  geom_point(alpha = 0.5) + 
  scale_x_log10() +
  geom_smooth(method = "lm", size=1.5)#method is linear, size changes thickness

# CHALLENGE - Modify the color and size of the points on the point layer in the 
# previous example.
# Hint: do not use the aes function.
ggplot(gapminder, 
       aes(gdpPercap, lifeExp)) +
  geom_point(alpha = 0.5,
             size = 4, 
             colour="magenta") + 
  scale_x_log10() +
  geom_smooth(method = "lm", size=1.5)

#CHALLENGE - Modify your solution to Challenge 4a so that the points are now a 
#different **shape** and are colored by continent with new trendlines. 
#Hint: The color argument can be used inside the aesthetic.
ggplot(gapminder, 
       aes(gdpPercap, lifeExp)) +
  geom_point(shape = 21,
             colour = "green") + 
  scale_x_log10() +
  geom_smooth(method = "lm", size=1.5)

#BONUS CAROLYN TIPS!!!
#ggplots look way nicer if you change the theme!
#Let's try a couple (e.g. theme_classic(), and 
#theme_minimal())
#Let's also choose the colours ourselves using a fancy
#colour palette
library(viridis)
?viridis
our_palette <- viridis(5)

ggplot(gapminder, 
       aes(gdpPercap, lifeExp, 
           colour = continent)) +
  geom_point(shape = 17) + 
  scale_x_log10() +
  geom_smooth(method = "lm", se=TRUE, size=1.5) +
  theme_classic() + 
  scale_color_manual(values = our_palette)

########
#MULTIPANEL FIGURES
########
#What if we want a different plot for each country?
#For this we can use facet_wrap()
americas <- gapminder[gapminder$continent == "Americas",]
americas %>% ggplot( 
       mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme(axis.text.x = element_text(angle = 90)) 
#The facet_wrap layer took a “formula” as its argument, 
#denoted by the tilde (~). This tells R to draw a panel 
#for each unique value in the country column of the 
#gapminder dataset.

#########
#MODIFYING TEXT
#########
#Our axes haven't been very pretty so far, we can fix that
#using labs
asia_and_oceania <- gapminder[
  gapminder$continent == "Asia" | 
    gapminder$continent == "Oceania",]

#plot our data for Asia and Oceania
life_exp_plot <- 
  ggplot(data = asia_and_oceania, 
       mapping = aes(x = year, 
                     y = lifeExp, 
                     color=continent)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Life expectancy by country",      # main title of figure
    color = "Continent"      # title of legend
  ) 

life_exp_plot <- life_exp_plot +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


#save our plot
ggsave(filename = "graphs/lifeExp.png", 
       plot = life_exp_plot, 
       width = 12, 
       height = 10, 
       dpi = 300, 
       units = "cm")

#GGPLOT CAN DO SO SO MUCH MORE! THIS IS JUST THE BEGINNING
#Dan Brady's bumber list of ggplot resources:
# R graph gallery: https://www.r-graph-gallery.com/
# ggplot2tor: https://ggplot2tor.com/
# data visualisation course: https://datavizs21.classes.andrewheiss.com/content/
# A ggplot2 tutorial for beautiful plotting: https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/
# R graphics cookbook: https://r-graphics.org/
# ggplot2 online book: https://ggplot2-book.org/