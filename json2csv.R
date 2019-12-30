## clear Workspace
## ========================================================================
rm(list = ls()); cat("\014")

library(jsonlite)
library(tidyverse)
library(lubridate)

## set working directory
setwd("WORKING DIRECTORY")

## Load in JSON file and convert to datafrane
df <- fromJSON(paste(getwd(),"/Location History.json",sep = "")) %>% as.data.frame

## Convert unix dates into something more readable
df$locations.timestampMs <- as.POSIXct.numeric(as.numeric(df$locations.timestampMs)/1000, origin = "1970-01-01")

## Remove wierd column - can keep if you know what to do with it!
df <- df[-c(9)]

## converts lat/lon into usable format by dividing by 1e7
df$locations.latitudeE7 <- as.numeric(df$locations.latitudeE7) / 1e7
df$locations.longitudeE7 <- df$locations.longitudeE7 / 1e7

## add in hour of day and day of week
df$hour <- hour(df$locations.timestampMs)
df$day <- weekdays(df$locations.timestampMs)

## filter it to just 2019
df_2019 <- df %>% subset(year(locations.timestampMs) == 2019)

## write to csv
write.csv(df_2019, file = "2019_timeline.csv",row.names=FALSE)
