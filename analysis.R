data <- read.csv("activity.csv")

data$date <- as.Date(data$date,format="%Y-%m-%d")

steps_in_a_day <- aggregate(steps~date,data,sum)
with(steps_in_a_day,hist(steps,breaks = 10))

aggregate(steps~date,data,mean)
aggregate(steps~date,data,median)

steps_average_by_interval <- aggregate(steps~interval,data,mean)
steps_average_by_interval$minutes <- (steps_average_by_interval$interval%/%100)*60 + steps_average_by_interval$interval%%100
with(steps_average_by_interval,plot(minutes,steps,type="l"))

max_interval <- which(steps_average_by_interval$steps == max(steps_average_by_interval$steps))
steps_average_by_interval$interval[max_interval]

sum(is.na(data))

test <- data
test$steps <- ifelse(is.na(test$steps),steps_average_by_interval$steps[steps_average_by_interval$interval==test$interval] , test$steps)

steps_in_a_day_imputed <- aggregate(steps~date,test,sum)
with(steps_in_a_day_imputed,hist(steps,breaks = 10))

aggregate(steps~date,test,mean)
aggregate(steps~date,test,median)

test$weekday <- weekdays(test$date)
test$weekday <- test$weekday == "Saturday" | test$weekday == "Sunday"
test$weekday <- factor(test$weekday,labels = c("weekday","weekend"))

steps_average_by_interval_weekdays <- aggregate(steps~interval,subset(test,weekday=="weekday"),mean)
steps_average_by_interval_weekend <- aggregate(steps~interval,subset(test,weekday=="weekend"),mean)

par(mfrow=c(1,2))

plot(steps_average_by_interval$minutes,steps_average_by_interval_weekdays$steps,type="l",ylim = c(0,250))
plot(steps_average_by_interval$minutes,steps_average_by_interval_weekend$steps,type="l",ylim = c(0,250))

