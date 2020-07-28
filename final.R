library(data.table)


#load the data to data table
data = fread("GlobalLandTemperaturesByCity.csv")

#deleting NA rows
data <- data[!is.na(AverageTemperature)]

#changing the class of dt field from char to DATE
data[, dt := as.Date(data$dt)]
data[, Year := as.integer(substr(dt,1,4))]
data <- data[Year > 1799]
#MPC = measure per city -> this field will be deleted
data[, MPC := .N, by = City]
