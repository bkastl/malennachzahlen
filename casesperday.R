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

#df1 <- sqlQuery("select DATE(created), count(DATE(created)) from `cases` group by DATE(created)")
df1 <-read.csv("df1.csv")
names(df1)[1] <- "Day"
names(df1)[2] <- "Cases"

# write.csv(df1,"df1.csv", row.names=FALSE)

df1[['Day']] <- as.Date(df1[['Day']], format = "%Y-%m-%d")

full_dates <- seq(min(df1$Day), max(df1$Day), by = "day")
full_dates <- data.frame(Day = full_dates)

df1 <- merge(df1, full_dates, all = TRUE)
df1[is.na(df1)] <- 0

graph <- ggplot(data=df1, aes(x = Day, y= Cases, group = 1)) +
  geom_line(color="#69b3a2", linewidth=0.5, alpha=0.75, linetype=1) +
  #geom_smooth(method = 'loess', color="#79FBB0") +
  #geom_boxplot(color="#69b3a2") +
  theme_ipsum() +
  ggtitle("Cases per Day") +
  ylim(0,5)

print(graph)
