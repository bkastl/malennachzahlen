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
#df4 <- sqlQuery("select contacts.index, -TIMESTAMPDIFF(HOUR,contacts.reached_date, cases.symptoms_date) as timedifference from contacts inner join cases on cases.index = contacts.case_index")
df4 <-read.csv("df4.csv")
names(df4)[1] <- "indexcase"
names(df4)[2] <- "delay"

# write.csv(df4,"df4.csv", row.names=FALSE)

result.mean <- mean(df4$delay)

graph <- ggplot(data=df4, aes(x = delay)) +
  geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8) +
  ggtitle("Delay between symptoms of case and contact reached (in h)") +
  geom_vline(xintercept = result.mean, colour="#79FBB0", linetype = "longdash") +
  theme_ipsum()

print(graph)

print(result.mean)


