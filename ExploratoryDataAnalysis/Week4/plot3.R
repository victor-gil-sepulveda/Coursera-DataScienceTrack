# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
# Convert type to factor
NEI$type <- as.factor(NEI$type)
# Load the other dataset
SCC <- readRDS("Source_Classification_Code.rds")


# Helper function adapted from :
# http://stackoverflow.com/questions/6364783/capitalize-the-first-letter-of-both-words-in-a-two-word-string
simpleCap <- function(x) {
    s0 <- tolower(x)
    s <- strsplit(s0, " ")[[1]]
    paste(toupper(substring(s, 1,1)), substring(s, 2),
          sep="", collapse=" ")
}


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

# Do the actual plots
plots <- lapply(levels(baltimore$type), function(t){
    data <- subset(baltimore, type == t)
    totals_per_year <- aggregate(data$Emissions, by=list(year =data$year), FUN = mean)
    ggplot(totals_per_year, aes(x=year, y=x)) +
        geom_point() +
        ylab("Avg. Emission") +
        ggtitle(paste(simpleCap(t),"Emissions @ Baltimore",sep=" "))+ 
        geom_smooth(method='lm', color= alpha("grey",0.5), se = FALSE)
})
g = do.call (grid.arrange, c(plots, ncol = 2, newpage = TRUE))

ggsave(file= "plot3.png",g)