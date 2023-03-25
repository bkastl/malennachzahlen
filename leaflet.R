library(RMySQL)
library(ggplot2)
library(hrbrthemes)
library(leaflet)

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
#df5 <- sqlQuery("select lat, lon, city from cases_geocode")
df5 <-read.csv("df5.csv")
names(df5)[1] <- "lat"
names(df5)[2] <- "long"
names(df5)[3] <- "city"

#write.csv(df5,"df5.csv", row.names=FALSE)

df5[['lat']] <- as.numeric(df5[['lat']])
df5[['long']] <- as.numeric(df5[['long']])

casesmap <- leaflet(data = df5) %>% addTiles() %>%
  addCircleMarkers(~long, ~lat, popup = ~as.character(city), label = ~as.character(city), clusterOptions = markerClusterOptions())

print(casesmap)