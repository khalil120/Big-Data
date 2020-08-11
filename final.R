library(data.table)

#my goal is to divide the data-table to 4-sub Tables(WEST,EAST,NORTH,SOUTH)
#Longitude Diveded to 4 intervals 0-1, 1-60, 61-120, 121 - 180 (FixedLongi)
#Latitude Diveded to 4 intervals 0-1, 1-30, 31-60, 61-90 (FixedLati)

#load the data to data table
data = fread("GlobalLandTemperaturesByCity.csv")

#deleting NA rows
data <- data[!is.na(AverageTemperature)]
data[,AverageTemperatureUncertainty := NULL]
#changing the class of dt field from char to DATE
data[, dt := as.Date(data$dt)]
data[, dt := substr(dt,1,7)]
data[, Month := substr(dt,6,7)]
data[, Year := substr(dt,6,7)]
#range of years: 1800 to 2012
data <- data[as.integer(substr(dt,1,4)) > 1799 & as.integer(substr(dt,1,4)) < 2013]

data[, RegionLati := substr(Latitude,nchar(Latitude),nchar(Latitude))]
data[, RegionLong := substr(Longitude,nchar(Longitude),nchar(Longitude))]

data[,Longitude := as.double(substr(Longitude,1,nchar(Longitude)-1))]
data[,Latitude := as.double(substr(Latitude,1,nchar(Latitude)-1))]

data[,FixedLongi := ifelse(Longitude < 1,0,ifelse(Longitude < 61,60,
                          ifelse(Longitude < 121,120,180)))]

data[,FixedLati := ifelse(Latitude < 1,0,ifelse(Latitude < 31,30,
                           ifelse(Latitude < 61,60,90)))]

zero_line <- data[FixedLati == 0]
zero_line[,Avg := sum(AverageTemperature) / .N , by = dt]
west <- data[RegionLong == "W"]
east <- data[RegionLong == "E"]
north <- data[RegionLati == "N"]
south <- data[RegionLati == "S"]