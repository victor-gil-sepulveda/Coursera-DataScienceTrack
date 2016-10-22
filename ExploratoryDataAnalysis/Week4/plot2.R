# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
# Convert type to factor
NEI$type <- as.factor(NEI$type)
# Load the other dataset
SCC <- readRDS("Source_Classification_Code.rds")

plot.total.per.year <- function(ds, title){
    # SUM and GROUP BY
    totals_per_year <- aggregate(ds$Emissions, by=list(year =ds$year), FUN = mean)
    # We plot the actual points here
    x <- totals_per_year$year
    y <- totals_per_year$x
    plot(x = x, y = y, 
         ylab = "Avg. Emission", 
         xlab = "Year", 
         main = title, 
         xaxt = "n")
    # Plot a regression line to make the tendency more evident
    abline(lm(y~x), col = "grey", lwd=1.5)
    # We put the correct labels in x ticks
    axis(1, at=x, labels=x)
}

#------------------------
# Question 2
#------------------------
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to 
# make a plot answering this question.
#-------------------------
# We make exactly the same than for plot 1
baltimore <- subset(NEI, fips == 24510)
plot.total.per.year(baltimore, "Total Emissions per Year @ Baltimore")
dev.copy(png,'plot2.png')
dev.off()
