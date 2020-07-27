library(data.table)


#load the data to data table
data = fread("GlobalLandTemperaturesByCity.csv")

#deleting NA rows
data <- data[!is.na(AverageTemperature)]

#changing the class of dt field from char to DATE
data[, dt := as.Date(data$dt)]
data[, Year := substr(dt,1,4)]
#MPY = measure per year
data[, MPY := .N, by = Year]
