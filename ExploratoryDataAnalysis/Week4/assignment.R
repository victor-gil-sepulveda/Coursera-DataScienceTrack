# Contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 
# 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted 
# from a specific type of source for the entire year. Here are the first few rows.

# fips: A five-digit number (represented as a string) indicating the U.S. county
# SCC: The name of the source as indicated by a digit string (see source code classification table)
# Pollutant: A string indicating the pollutant
# Emissions: Amount of PM2.5 emitted, in tons
# type: The type of source (point, non-point, on-road, or non-road)
# year: The year of emissions recorded

# Source Classification Code Table (Source_Classification_Code.rds): This table provides 
# a mapping from the SCC digit strings in the Emissions table to the actual name of the 
# PM2.5 source. The sources are categorized in a few different ways from more general to 
# more specific and you may choose to explore whatever categories you think are most useful.
# For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal 
# /Pulverized Coal”.

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Check the names of vars
names(NEI)
names(SCC)

# Get a taste of the data
head(NEI)
head(SCC)

# How many years are there? How many samples per year?
summary(as.factor(NEI$year))


# Helper function adapted from :
# http://stackoverflow.com/questions/6364783/capitalize-the-first-letter-of-both-words-in-a-two-word-string
simpleCap <- function(x) {
    s0 <- tolower(x)
    s <- strsplit(s0, " ")[[1]]
    paste(toupper(substring(s, 1,1)), substring(s, 2),
          sep="", collapse=" ")
}

# Convert type to factor
NEI$type <- as.factor(NEI$type)

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
         ylab = "Avg Emission", 
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

#------------------------
# Question 2
#------------------------
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to 
# make a plot answering this question.
#-------------------------
# We make exactly the same than before here
baltimore <- subset(NEI, fips == 24510)
plot.total.per.year(baltimore, "Total Emissions per Year @ Baltimore")
dev.copy(png,'plot2.png')
dev.off()

#------------------------
# Question 3
#------------------------
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999–2008 
# for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the 
# ggplot2 plotting system to make a plot answer this question.
#------------------------
# Using base
#par(mfrow=c(2,2))
#lapply(levels(baltimore$type), function(x){
#    data <- subset(baltimore, type == x)
#    plot.total.per.year(data, paste(simpleCap(x),"Emissions @ Baltimore",sep=" "))
#})
#for (x in levels(baltimore$type)){
#    data <- subset(baltimore, type == x)
#    plot.total.per.year(data, paste(simpleCap(x),"Emissions @ Baltimore",sep=" "))
#}

#Using ggplot2
library(ggplot2)
#install.packages("gridExtra")
library(grid)
library(gridExtra)
plots <- lapply(levels(baltimore$type), function(t){
    data <- subset(baltimore, type == t)
    totals_per_year <- aggregate(data$Emissions, by=list(year =data$year), FUN = mean)
    ggplot(totals_per_year, aes(x=year, y=x)) +
            geom_point() +
            ylab("Avg Emission") +
            ggtitle(paste(simpleCap(t),"Emissions @ Baltimore",sep=" "))+ 
            geom_smooth(method='lm', color= alpha("grey",0.5), se = FALSE)
})
g = do.call (grid.arrange, c(plots, ncol = 2, newpage = TRUE))

ggsave(file= "plot3.png",g)

#------------------------
# Question 4
#------------------------
# Across the United States, how have emissions from coal combustion-related sources changed 
# from 1999–2008?
#------------------------
# This tell us we want the guys "Fuel Comb - XXXX - Coal"
#grep("Coal",SCC$EI.Sector, value = TRUE)

# Do the "join" operation
merged <- merge(NEI, SCC, by = "SCC")
coal_emissions <- merged[grep("Coal", merged$EI.Sector, value = FALSE) , ]

# This shows that theere are only 3 sectors
# ggplot(coal_emissions, aes(x=year, y=Emissions, color=EI.Sector)) +
#       geom_point()

source("summarySE.R")

# get the data summary
coal_em_summ <-summarySE(coal_emissions, measurevar="Emissions", groupvars=c("year", "EI.Sector"))
# reduce levels of the summary
coal_em_summ$EI.Sector <- as.factor(as.character(coal_em_summ$EI.Sector))

# This plot evidences that the scale difference is problematic, we use log transform 
ggplot(coal_em_summ, aes(x=year, y=Emissions, color=EI.Sector)) + 
    geom_errorbar(mapping =aes(ymin=Emissions-se, ymax=Emissions+se), width=.1)+
    geom_point()+
    geom_line()+
    scale_y_continuous(trans='log2')+
    ylab("Log. Avg. Emissions")+
    xlab("Year")+
    ggtitle("Coal Combustion Emissions ")

ggsave("plot4.png")

#------------------------
# Question 5
#------------------------
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
#------------------------

# we use following line to find the categories we are interested in
# unique(grep("hicle",SCC$EI.Sector, value = TRUE))
categories <- c( "Mobile - On-Road Gasoline Light Duty Vehicles", 
                 "Mobile - On-Road Gasoline Heavy Duty Vehicles",
                 "Mobile - On-Road Diesel Light Duty Vehicles",
                 "Mobile - On-Road Diesel Heavy Duty Vehicles")
baltimore_cars <- subset(merged, fips == "24510" & EI.Sector %in% categories)
baltimore_cars$EI.Sector <- as.factor(as.character(baltimore_cars$EI.Sector))
balt_cars_em_summ <-summarySE(baltimore_cars, measurevar="Emissions", groupvars=c("year", "EI.Sector"))
ggplot(balt_cars_em_summ, aes(x=year, y=Emissions, color=EI.Sector)) + 
    geom_errorbar(mapping =aes(ymin=Emissions-se, ymax=Emissions+se), width=.1)+
    geom_point()+
    geom_line()+
    ylab("Log. Avg. Emissions")+
    xlab("Year")+
    ggtitle("Car Emissions @ Baltimore")

ggsave("plot5.png")

#------------------------
# Question 6
#------------------------
# Compare emissions from motor vehicle sources in Baltimore City with emissions from 
# motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city 
# has seen greater changes over time in motor vehicle emissions?
#------------------------
#Use same x y limits (same axis scale)
categories <- c( "Mobile - On-Road Gasoline Light Duty Vehicles", 
                 "Mobile - On-Road Gasoline Heavy Duty Vehicles",
                 "Mobile - On-Road Diesel Light Duty Vehicles",
                 "Mobile - On-Road Diesel Heavy Duty Vehicles")

plot_car_emissions <- function(dataset, city_id, city_name, car_categories, leg_position){
    cars_info <- subset(dataset, fips == city_id & EI.Sector %in% car_categories)
    cars_info$EI.Sector <- as.factor(as.character(cars_info$EI.Sector))
    cars_summ <-summarySE(cars_info, measurevar="Emissions", groupvars=c("year", "EI.Sector"))
    ggplot(cars_summ, aes(x=year, y=Emissions, color=EI.Sector)) + 
        geom_errorbar(mapping =aes(ymin=Emissions-se, ymax=Emissions+se), width=.1) +
        geom_point() +
        geom_line() +
        ylab("Log. Avg. Emissions") +
        xlab("Year") +
        ggtitle(paste("Emissions @", city_name, sep = " "))+
        theme(legend.position=leg_position)+
        scale_colour_discrete(name  ="Cat.",
                              breaks= categories,
                              labels= c("Gas. Light", 
                                        "Gas. Heavy",
                                        "Diesel Light",
                                        "Diesel Heavy"))
}

plot1 <- plot_car_emissions(merged, "24510", "Baltimore",categories, "top")
plot2 <- plot_car_emissions(merged, "06037", "Los Angeles",categories, "top")
g = grid.arrange(plot1, plot2, ncol=2,  newpage = TRUE)
ggsave(file = "plot6.png", g)
