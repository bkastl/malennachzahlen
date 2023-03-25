library(RMySQL)
library(ggplot2)
library(hrbrthemes)

sqlQuery <- function (query) {
  
  # creating DB connection object with RMysql package
  DB <- dbConnect(MySQL(), user="root", dbname='noeg', host='127.0.0.1')
  
  # close db connection after function call exits
  on.exit(dbDisconnect(DB))
  
  # send Query to btain result set
  rs <- dbSendQuery(DB, query)
  
  # get elements from result sets and convert to dataframe
  result <- fetch(rs, -1)
  
  # return the dataframe
  return(result)
}

#df2 <- sqlQuery("select DATE(source_created), count(case_index) from `contacts` group by case_index")
df2 <-read.csv("df2.csv")
names(df2)[1] <- "Day"
names(df2)[2] <- "Contacts"

# write.csv(df2,"df2.csv", row.names=FALSE)

df2[['Day']] <- as.Date(df2[['Day']], format = "%Y-%m-%d")

full_dates <- seq(min(df2$Day), max(df2$Day), by = "day")
full_dates <- data.frame(Day = full_dates)

df2 <- merge(df2, full_dates, all = TRUE)
df2[is.na(df2)] <- 0

graph <- ggplot(data=df2, aes(x = Day, y= Contacts, group = 1)) +
  geom_point(color="#69b3a2") +
  #geom_smooth(method = 'loess', color="#79FBB0") +
  #geom_boxplot(color="#69b3a2") +
  theme_ipsum() +
  ggtitle("Contacts per case per day") +
  ylim(0,15)

print(graph)

