library(data.table)

#my goal is to divide the data-table to 4-sub Tables(WEST,EAST,NORTH,SOUTH)

#load the data to data table
data = fread("GlobalLandTemperaturesByCity.csv")

#deleting NA rows
data <- data[!is.na(AverageTemperature)]
data[,AverageTemperatureUncertainty := NULL]
#changing the class of dt field from char to DATE
data[, dt := as.Date(data$dt)]
data[, Year := as.integer(substr(dt,1,4))]
#range of years: 1800 to 2012
data <- data[Year > 1799 & Year < 2013]

data[, RegionLati := substr(Latitude,nchar(Latitude),nchar(Latitude))]
data[, RegionLong := substr(Longitude,nchar(Longitude),nchar(Longitude))]