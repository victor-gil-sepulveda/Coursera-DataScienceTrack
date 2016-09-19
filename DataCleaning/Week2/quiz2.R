#-------------
# Question 1
#-------------

# 2013-11-07T13:25:07Z

#-------------
# Question 2
#-------------

if(!file.exists("data")){
    dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
dateDownloaded <- format(Sys.time(), "%b.%d.%Y")
destFile <- paste("data/acs",dateDownloaded,"csv",sep= ".")

download.file(fileUrl, destfile = destFile, method = "curl")

acs <- read.csv(destFile)

#install.packages("sqldf", dependencies=TRUE)
library(sqldf)
sqldf("select pwgtp1 from acs where AGEP < 50")

#-------------
# Question 3
#-------------
library(sqldf)
sqldf("select distinct AGEP from acs")

#-------------
# Question 4
#-------------
site <- "http://biostat.jhsph.edu/~jleek/contact.html"
con <- url(site)
htmlCode <- readLines(con)
indices <- c(10,20,30,100)
nchar(htmlCode)[indices]
# 45 31  7 25

#-------------
# Question 5
#-------------
#install.packages("readr", dependencies=TRUE)
#library(readr)
site <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"

# This one does not work
# con <- url(site)
# lines <- readLines(con)
# head(lines)
# data = read.fortran(con, skip = 4, format=c("1A10","1X52"))
data <- read.fwf(
    file=site,   
    skip=4,
    widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4))

sum(data[4])
#32426.7