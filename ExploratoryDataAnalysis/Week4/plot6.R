# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
# Convert type to factor
NEI$type <- as.factor(NEI$type)
# Load the other dataset
SCC <- readRDS("Source_Classification_Code.rds")

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
