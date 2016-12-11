data <- read.csv(unz("activity.zip", "activity.csv"))
data$date <- as.Date(data$date)
summary(data)

steps_per_day <- aggregate(data$steps, by=list(date=data$date), FUN=sum, na.rm = TRUE)


# Remove those with 0 steps (no activity that day)
positive_steps_per_day <- subset(steps_per_day, x!=0)
length(unique(positive_steps_per_day$x))

library(ggplot2)

ggplot(data=positive_steps_per_day, aes(positive_steps_per_day$x)) + 
    geom_histogram(bins = 25)+
    labs(x="Steps per day (>0)", y="Count")+
    geom_vline(aes(xintercept=mean(x)),color="red", 
               linetype="dashed", size=1)

mean(positive_steps_per_day$x)
median(positive_steps_per_day$x)


# now we have to aggregate per interval and show the time series
plot_timeline <- function(data,  title="", ylim=250){
    avg_steps_per_interval <- aggregate(data$steps, by=list(interval=data$interval), FUN=mean, na.rm = TRUE)
    
    max_interval_index <- which(avg_steps_per_interval$x == max(avg_steps_per_interval$x))
    max_interval <- avg_steps_per_interval[max_interval_index,]
    
    ggplot(avg_steps_per_interval, aes(interval,x)) + 
        geom_line() +
        labs(x="5' Interval", y="Avg. Num. Steps", title=title)+
        geom_vline(aes(xintercept=max_interval$interval),color="red", linetype="dashed", size=1)+
        ylim(0,ylim)
}

plot_timeline(data)

# Impute NAs
number_of_nas <- sum(is.na(data$steps))

avg_steps_per_interval <- aggregate(data$steps, by=list(interval=data$interval), FUN=mean, na.rm = TRUE)

imputed_data <- data
for (i in 1:dim(imputed_data)[1]){
    if (is.na(imputed_data[i,"steps"])){
        interval <- imputed_data[i,"interval"] # 5*(i-1) indeed, or 5*i if we start at 0
        interval_index <- which (avg_steps_per_interval$interval == interval)
        imputed_data[i,"steps"] <- avg_steps_per_interval$x[interval_index]
    }
}

# redo calulations
imp_steps_per_day <- aggregate(imputed_data$steps, 
                               by=list(date=imputed_data$date), 
                               FUN=sum, na.rm = TRUE)


# Remove those with 0 steps (no activity that day)
imp_positive_steps_per_day <- subset(imp_steps_per_day, x!=0)
length(unique(positive_steps_per_day$x))

ggplot(data=imp_positive_steps_per_day, aes(imp_positive_steps_per_day$x)) + 
    geom_histogram(bins = 25) +
    labs(x="Steps per day (>0)", y="Count") +
    geom_vline(aes(xintercept=mean(x)),color="red", 
               linetype="dashed", size=1)

mean(imp_positive_steps_per_day$x)
median(imp_positive_steps_per_day$x)


# weekdays
day_type <- function(date){
     if (weekdays(date) %in% c("Saturday","Sunday")){
         return("weekend")
     }
    else{
        return("weekday")
    };
}

imputed_data$day.type <- sapply(imputed_data$date, day_type, simplify=TRUE)

weekday_data = subset(imputed_data, day.type == "weekday")
weekend_data = subset(imputed_data, day.type == "weekend")

plot1 <- plot_timeline(weekday_data, "Week days", 250)
plot2 <- plot_timeline(weekend_data, "Week end", 250)
library(gridExtra)
g = grid.arrange(plot1, plot2, ncol=2,  newpage = TRUE)

