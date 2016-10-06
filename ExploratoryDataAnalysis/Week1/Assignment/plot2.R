df <- as.data.frame(read.table("household_power_consumption.txt", 
                               sep = ";", header = TRUE, 
                               na.strings = c("?")))
df$Date <- as.Date(df$Date, format = "%d/%m/%Y")
# Dates must be between 2007-02-01 and 2007-02-02
df.sub <- subset(df, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
# Now let's add the time information
datetime = paste(as.character(df.sub$Date), df.sub$Time)
df.sub$CompleteDate <- strptime(datetime, "%Y-%m-%d %H:%M:%S") 

library(datasets)
x11()
plot(df.sub$CompleteDate, df.sub$Global_active_power, 
     type = "l",
     ylab = "Global Active Power (kilowatts)",
     xlab = "")

dev.copy(png, filename = 'plot2.png', width = 480, height = 480)
dev.off()