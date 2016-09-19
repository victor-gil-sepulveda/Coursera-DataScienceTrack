#-------------
# Question 1
#-------------
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
dateDownloaded <- format(Sys.time(), "%b.%d.%Y")
destFile <- paste("data/usa_comm_idaho",dateDownloaded,"csv",sep= ".")
download.file(fileUrl, destfile = destFile, method = "curl")
df <- read.csv(destFile)

#Apply strsplit() to split all the names of the data frame on the characters "wgtp".
# What is the value of the 123 element of the resulting list?
df_names <- names(df)
split_them <- function(x){strsplit(x,"wgtp")}
splitted_names <- lapply(df_names, split_them)
splitted_names[[123]]
# result
# [[1]]
# [1] ""   "15"

#-------------
# Question 2
#-------------
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
destFile <- paste("data/gdp",dateDownloaded,"csv",sep= ".")
download.file(fileUrl, destfile = destFile, method = "curl")
gdp <- read.csv(destFile)
# remove initial lines
gdp <- gdp[5:219,] #219, 235 #rbind()
gdp$X.3 <- as.numeric( gsub(",", "", gdp$X.3)) 
mean(gdp$X.3, na.rm = TRUE)
# result
# 377652.4

#-------------
# Question 3
#-------------
length(grep("^United", gdp$X.2))
# result
# grep("^United",countryNames), 3

#-------------
# Question 4
#-------------
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
destFile <- paste("data/education",dateDownloaded,"csv",sep= ".")
download.file(fileUrl, destfile = destFile, method = "curl")
edu <- read.csv(destFile)

merged <- merge(gdp, edu, by.x="X",by.y="CountryCode", sort = FALSE, all = FALSE)
grep_str <- "^Fiscal year end: June"
length(grep(grep_str, merged$Special.Notes))
# result 
# 13

#-------------
# Question 5
#-------------
#install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
# How many values were collected in 2012?
# How many values were collected on Mondays in 2012?
#-----
#a)
# Using dates
year_2012 = sampleTimes >= as.Date("2012-01-01") & sampleTimes < as.Date("2013-01-01")
sum(year_2012)
# result: 250
# Using string parsing
length(grep("^2012-", as.character(sampleTimes)))
# result: 250

#b)
days = weekdays(sampleTimes)[year_2012]
sum(days == "Monday")
# result: 47
#--- With lubridate
#install.packages("lubridate")
library(lubridate)
sum(year(sampleTimes) == 2012 & wday(sampleTimes, label=TRUE) == "Mon")
# result: 47
