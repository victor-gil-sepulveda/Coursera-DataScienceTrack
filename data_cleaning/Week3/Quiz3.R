#-------------
# Question 1
#-------------
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
dateDownloaded <- format(Sys.time(), "%b.%d.%Y")
destFile <- paste("data/usa_comm_idaho",dateDownloaded,"csv",sep= ".")
download.file(fileUrl, destfile = destFile, method = "curl")

df <- read.csv(destFile)
head(df)
# Create a logical vector that identifies the households on greater than 10 
# acres who sold more than $10,000 worth of agriculture products. Assign that 
# logical vector to the variable agricultureLogical. Apply the which() function 
# like this to identify the rows of the data frame where the logical vector is 
# TRUE.
# > which(agricultureLogical)
# What are the first 3 values that result?

# From https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# ACR        1      
# Lot size            
# b .N/A (GQ/not a one-family house or mobile home)
# 1 .House on less than one acre
# 2 .House on one to less than ten acres 
# 3 .House on ten or more acres
# AGS        1         
# Sales of Agriculture Products
# b .N/A (less than 1 acre/GQ/vacant/
#             .2 or more units in structure)
# 1 .None
# 2 .$    1 - $  999
# 3 .$ 1000 - $ 2499
# 4 .$ 2500 - $ 4999
# 5 .$ 5000 - $ 9999
# 6 .$10000+  

# so, ACR == 3 and AGS == 6

#install.packages("dplyr")
library(dplyr)
df <- mutate(df, agricultureLogical = (ACR == 3 & AGS == 6))

which(df$agricultureLogical) 
# 125  238  262  470  555 ...


#-------------
# Question 2
#-------------
install.packages("jpeg")
library(jpeg)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
dateDownloaded <- format(Sys.time(), "%b.%d.%Y")
destFile <- paste("data/intr_image",dateDownloaded,"jpeg",sep= ".")
download.file(fileUrl, destfile = destFile, method = "curl")

image <- readJPEG(destFile, native=TRUE)
quantile(image, probs = c(0.3,0.8))
#result:-15258512 -10575416 ;answer : -15259150 -10575416

#-------------
# Question 3
#-------------
#Load the Gross Domestic Product data for the 190 ranked countries in this data set:
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

#Load the educational data from this data set:

#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is 
# last). What is the 13th country in the resulting data frame?
dateDownloaded <- format(Sys.time(), "%b.%d.%Y")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
destFile <- paste("data/gdp",dateDownloaded,"csv",sep= ".")
download.file(fileUrl, destfile = destFile, method = "curl")
gdp <- read.csv(destFile)
#gdp<- gdp[5:219,] # remove extra lines and final summary
gdp<- gdp[5:235,]
# if summary lines are kept this line converts them to NA if no gdp
gdp$Gross.domestic.product.2012 <- as.integer(as.character(gdp$Gross.domestic.product.2012))


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
destFile <- paste("data/education",dateDownloaded,"csv",sep= ".")
download.file(fileUrl, destfile = destFile, method = "curl")
edu <- read.csv(destFile)

merged <- merge(gdp, edu, by.x="X",by.y="CountryCode", sort = FALSE, all = FALSE)

sorted <- arrange(merged, desc(Gross.domestic.product.2012))
head(sorted, n= 13)
# St kitts and nevis
# We can eliminate the NA gdps in order to obtain the number of hits
sorted <- filter(sorted, !is.na(Gross.domestic.product.2012) )
#189 observations

#-------------
# Question 4
#-------------
# What is the average GDP ranking for the "High income: OECD" and "High income: 
# nonOECD" group?
summarize(group_by(sorted,Income.Group),mean(Gross.domestic.product.2012))
# High income: nonOECD                            91.91304
# High income: OECD                            32.96667

#-------------
# Question 5
#-------------
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?

q <- quantile(sorted$Gross.domestic.product.2012, na.rm = TRUE, prob = c(0, 0.2, 0.8, 1))
sorted$GDPGroups <- cut(sorted$Gross.domestic.product.2012,breaks=quantile(sorted$Gross.domestic.product.2012, prob = c(0,0.2, 0.8, 1.)))
table(sorted$GDPGroups, sorted$Income.Group)

#5
