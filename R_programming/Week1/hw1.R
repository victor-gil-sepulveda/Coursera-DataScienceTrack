path_csv <- "/home/victor/git/datasciencecoursera/R_programming/Week1/hw1_data.csv"
path_gz <- "/home/victor/git/datasciencecoursera/R_programming/Week1/hw1_data.csv.gz"

# Loading the files fro compressed and std files
file.info(path_gz)$size
file.info(path_csv)$size
system.time(data <- read.csv(path_csv))
system.time(data <- read.csv(path_gz))
system.time(data <- read.csv(path_gz, sep=","))

#11
data <- read.csv(path_gz)
names(data)

#12
head(data)

#13
dim(data)

#14
tail(data)

#15
data[["Ozone"]][47] # This is the actual result

#16
ozone <- data[["Ozone"]]
sum(is.na(ozone)) # Using coercion of TRUE to 1
length(ozone[is.na(ozone)]) # Using the length 

sum(!complete.cases(data[["Ozone"]])) # the missing values are the "not complete"
data["Ozone"] # This is another data frame
sum(!complete.cases(data["Ozone"]))

#17
mean(ozone[!is.na(ozone)])

#18
sub <- subset(data, Ozone>31 & Temp > 90)
sub
solar_subset <- sub[["Solar.R"]]
mean(solar_subset[!is.na(solar_subset)])

#19
sub <- subset(data, Month == 6)
mean(sub[["Temp"]]) #Visual inspection does not show NAs

#20
sub <- subset(data, Month == 5)
ozone <- sub[["Ozone"]]
max(ozone[!is.na(ozone)])