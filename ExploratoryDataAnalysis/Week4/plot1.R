# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
# Convert type to factor
NEI$type <- as.factor(NEI$type)
# Load the other dataset
SCC <- readRDS("Source_Classification_Code.rds")


#------------------------
# Question 1
#------------------------
# Have total emissions from PM2.5 decreased in the United States from 1999 to 
# 2008? Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.
#-------------------------
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

plot.total.per.year(NEI, "Total Emissions per Year")

dev.copy(png,'plot1.png')
dev.off()