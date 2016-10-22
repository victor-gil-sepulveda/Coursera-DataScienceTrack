# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
# Convert type to factor
NEI$type <- as.factor(NEI$type)
# Load the other dataset
SCC <- readRDS("Source_Classification_Code.rds")

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

# Load the helper functio
# See http://www.cookbook-r.com/Manipulating_data/Summarizing_data/ 
source("summarySE.R")

# get the data summary
coal_em_summ <-summarySE(coal_emissions, measurevar="Emissions", groupvars=c("year", "EI.Sector"))
# reduce levels of the summary
coal_em_summ$EI.Sector <- as.factor(as.character(coal_em_summ$EI.Sector))

# This plot evidences that the scale difference is problematic, we use log transform 
# to make it clearer
ggplot(coal_em_summ, aes(x=year, y=Emissions, color=EI.Sector)) + 
    geom_errorbar(mapping =aes(ymin=Emissions-se, ymax=Emissions+se), width=.1)+
    geom_point()+
    geom_line()+
    scale_y_continuous(trans='log2')+
    ylab("Log. Avg. Emissions")+
    xlab("Year")+
    ggtitle("Coal Combustion Emissions")

ggsave("plot4.png")