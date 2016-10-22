# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
# Convert type to factor
NEI$type <- as.factor(NEI$type)
# Load the other dataset
SCC <- readRDS("Source_Classification_Code.rds")

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