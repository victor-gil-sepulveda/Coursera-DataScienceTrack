
if(!file.exists("data")){
    dir.create("data")
}

##----------------
## Question 1
##----------------

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

dateDownloaded <- format(Sys.time(), "%b.%d.%Y")
destFile <- paste("data/idaho_housing",dateDownloaded,"csv",sep= ".")

download.file(fileUrl, destfile = destFile, method = "curl")

data <- read.csv(destFile)

#data$VAL
# codebook says 24 means > 1kk
length(data$VAL[data$VAL ==24 & complete.cases(data$VAL)])
# result 53

# x Tidy data has variable values that are internally consistent
# x Each variable in a tidy data set has been transformed to be interpretable.
# OK Tidy data has one variable per column
##----------------
## Question 3
##----------------

install.packages("xlsx", dependencies=TRUE)
library(xlsx)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

dateDownloaded <- format(Sys.time(), "%b.%d.%Y")
destFile <- paste("data/natural_gas",dateDownloaded,"xlxs",sep= ".")

download.file(fileUrl, destfile = destFile, method = "curl")

data <- read.xlsx(destFile, 
                  sheetIndex = 1, 
                  colIndex=7:15, 
                  rowIndex = 18:23)

sum(data$Zip*data$Ext,na.rm=T)
#[1] 36534720

##----------------
## Question 4
##----------------
#install.packages("XML", dependencies=TRUE)
library(XML)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
dateDownloaded <- format(Sys.time(), "%b.%d.%Y")
destFile <- paste("data/balti_restaurants",dateDownloaded,"xml",sep= ".")

download.file(fileUrl, destfile = destFile, method = "curl")

doc <-xmlTreeParse(destFile, useInternal=TRUE)

rootNode <- xmlRoot(doc)

codes <- xpathSApply(rootNode, "//zipcode", xmlValue)

sum(codes == "21231")
#127

##----------------
## Question 5
##----------------
#install.packages("data.table", dependencies=TRUE)
library(data.table)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
dateDownloaded <- format(Sys.time(), "%b.%d.%Y")
destFile <- paste("data/usa_comm",dateDownloaded,"csv",sep= ".")
download.file(fileUrl, destfile = destFile, method = "curl")

DT <- fread(destFile)

# Ok, does the job
system.time(mean(DT[DT$SEX==1,]$pwgtp15))
system.time(mean(DT[DT$SEX==2,]$pwgtp15))
# 0.44 <- X , too slow

# Does not do the expected thing
system.time(mean(DT$pwgtp15,by=DT$SEX))
#0 <- X

# Ok, does the job
system.time(DT[,mean(pwgtp15),by=SEX])
#0.004

# Ok, it does the job
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
#0 <- X

# Ok, it does the job
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
#0 <- X

# This one does not even work
system.time(rowMeans(DT)[DT$SEX==1])
system.time(rowMeans(DT)[DT$SEX==2])
# > 1 <- X

# using a foor loop or replicate we can get more insight
    
system.time(for(i in 1:1000) DT[,mean(pwgtp15),by=SEX])
system.time(for(i in 1:1000) tapply(DT$pwgtp15,DT$SEX,mean))
system.time(for(i in 1:1000) sapply(split(DT$pwgtp15,DT$SEX),mean))
