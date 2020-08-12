library(data.table)
library(ggplot2)

#my goal is to divide the data-table to 4-sub Tables(WEST,EAST,NORTH,SOUTH)
#one table will contain the zero line
#Longitude Diveded to 4 intervals 0-1, 1-60, 61-120, 121 - 180 (FixedLongi)
#Latitude Diveded to 4 intervals 0-1, 1-30, 31-60, 61-90 (FixedLati)

#load the data to data table
data = fread("GlobalLandTemperaturesByCity.csv")

#deleting NA rows & unnecessary columns
data <- data[!is.na(AverageTemperature)]
data[, AverageTemperatureUncertainty := NULL]
data[, City := NULL]
#changing the class of dt field from char to DATE
data[, dt := as.Date(data$dt)]
data[, dt := substr(dt,1,7)]
data[, Month := substr(dt,6,7)]
data[, Year := substr(dt,1,4)]
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
zero_line[,AvgTmp := sum(AverageTemperature) / .N , by = dt]
west_north <- data[RegionLong == "W" & RegionLati == "N"]
west_north[,AvgTmp := sum(AverageTemperature) / .N , by = dt]
west_south <- data[RegionLong == "W" & RegionLati == "S"]
west_south[,AvgTmp := sum(AverageTemperature) / .N , by = dt]
east_north <- data[RegionLong == "E" & RegionLati == "N"]
east_north[,AvgTmp := sum(AverageTemperature) / .N , by = dt]
east_south <- data[RegionLong == "E" & RegionLati == "S"]
east_south[,AvgTmp := sum(AverageTemperature) / .N , by = dt]

####################################Function to plot temp of the months####################################
monthly_temp = function(table, fixedVal, msg){
  
  m_num = c("01","02","03","04","05","06","07","08","09","10","11","12")
  m_name = c("January","February","March","April","May","June","July","August"
         ,"September","October","November","December" )
  par(mfrow=c(4,3))
  options(digit = 5) #enable the number to be five digits only
  #################DELETING UNNECESSARY COLUMNS#####################
  table[,AverageTemperature := NULL]
  table[, Latitude := NULL]
  table[, Longitude := NULL]
  table[, Country := NULL]
}