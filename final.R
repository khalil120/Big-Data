library(data.table)


#load the data to data table
data = fread("GlobalLandTemperaturesByCity.csv")

#deleting NA rows
data <- data[!is.na(AverageTemperature)]