df <- as.data.frame(read.table("household_power_consumption.txt", 
                               sep = ";", header = TRUE, 
                               na.strings = c("?")))
df$Date <- as.Date(df$Date, format = "%d/%m/%Y")
# Dates must be between 2007-02-01 and 2007-02-02
df.sub <- subset(df, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))

library(datasets)
x11()
hist(df.sub$Global_active_power, 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency",
     border="black", 
     col="red",
     freq = TRUE)

dev.copy(png, filename = 'plot1.png', width = 480, height = 480)
dev.off()