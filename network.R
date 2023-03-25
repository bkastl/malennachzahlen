library(RMySQL)
library(networkD3)

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

# df6 <- sqlQuery("select CONCAT('i',case_index), `index` from contacts")
df6 <-read.csv("df6.csv")
names(df6)[1] <- "index"
names(df6)[2] <- "contact_index"

#write.csv(df6,"df6.csv", row.names=FALSE)

df6 <- head(df6,100)

p <- simpleNetwork(df6, height="500px", 
                   width="500px",
                   linkColour = "#79FBB0",        
                   nodeColour = "#666",
                   opacity = 0.9,
                   charge = -15, 
                   zoom = T)

print(p)
