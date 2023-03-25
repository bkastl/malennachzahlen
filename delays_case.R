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
#df3 <- sqlQuery("select delay_test, `delay_symptoms` from `cases`")
df3 <-read.csv("df3.csv")
names(df3)[1] <- "Test"
names(df3)[2] <- "Symptoms"

# write.csv(df3,"df3.csv", row.names=FALSE)

graph <- ggplot(data=df3, aes(x = Test)) +
  geom_histogram( binwidth=1, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
  theme_ipsum() +
  ggtitle("Delay between test and case created (in days)") 

print(graph)

graph2 <- ggplot(data=df3, aes(x = Symptoms)) +
  geom_histogram( binwidth=1, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
  theme_ipsum() +
  ggtitle("Delay between symptoms and case created (in days)") 

print(graph2)

