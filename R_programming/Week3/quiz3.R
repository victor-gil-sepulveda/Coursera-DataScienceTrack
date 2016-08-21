#------------
# Question 1
#------------
library(datasets)
data(iris)
?iris
#I will try a solution with split and $ indexing
s <- split(iris, iris$Species)
m <- mean(s$virginica$Sepal.Length)
round(m)

#------------
# Question 2
#------------
apply(iris[, 1:4], 2, mean)

#------------
# Question 3
#------------
library(datasets)
data(mtcars)
?mtcars
# by number of cilinders
s<-split(mtcars, mtcars$cyl)
# options
with(mtcars, tapply(mpg, cyl, mean))
sapply(split(mtcars$mpg, mtcars$cyl), mean)
tapply(mtcars$mpg, mtcars$cyl, mean)

#------------
# Question 4
#------------
# what is the absolute difference between the average horsepower 
# of 4-cylinder cars and the average horsepower of 8-cylinder cars?
r<- sapply(split(mtcars$hp, mtcars$cyl), mean)
round(abs(r["4"] - r["8"]))

#------------
# Question 5
#------------
# It looks not to work as in the videos
debug(ls)
ls