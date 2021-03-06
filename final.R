library(data.table)
library(dplyr)
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
monthly_temp = function(table1, Long, Lat){
  
  table <- copy(table1)
  
  m_num = c("01","02","03","04","05","06","07","08","09","10","11","12")
  m_name = c("January","February","March","April","May","June","July","August"
         ,"September","October","November","December" )
  par(mfrow=c(4,3))
  
  #################DELETING UNNECESSARY COLUMNS#####################
  table[, AverageTemperature := NULL]
  table[, Latitude := NULL]
  table[, Longitude := NULL]
  table[, Country := NULL]
  table[, RegionLati := NULL]
  table[, RegionLong := NULL]
  
  if(Lat != 0){
    table <- table[Long == table$FixedLongi & Lat == table$FixedLati]
  }
  
  ######Creating plots & linear models ##########
  for(m in  1:12){
    
    selected_month = table[table$Month == m_num[m],]
    
    lmTmp = lm(selected_month$AvgTmp~as.numeric(selected_month$Year))
    Incline = coef(lmTmp)[2]
    r2 = summary(lmTmp)$r.squared
    selected_month[, Month := NULL]
    selected_month =  unique(selected_month)
    pval = t.test(selected_month$AvgTmp,mu=0)
    
    par(mar = rep(2, 4))
    plot(selected_month$Year,selected_month$AvgTmp, type = "p",
         pch = 16, cex = 1.3, xlab = "Year", ylab = "Temparature",
         main = paste0(m_name[m]),col="cyan3",las = 1)
    mtext(paste("R^2=",round(r2,digits = 4),", P = ",round(pval$p.value,digits = 4),
                "Inc = ",round(Incline,digits = 4)), side=3, cex=0.5,font=1)
    
    
    if(Incline > 0){
      abline(lmTmp, col = "red")
    }else{
      abline(lmTmp, col = "chartreuse3")
    }
  }
}
####################################END OF THE FUNCTION####################################