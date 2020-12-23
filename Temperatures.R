library(dplyr)
library(tidyr)
library(chron)
library(lubridate)

##Temperature extracted from https://data.open-power-system-data.org/weather_data/
Weather = read.csv(file = "/Users/VictorGarcia/Documents/PRIVAT/Uni/Màster UdG/TreballFinal1/weather.csv")

#Erasing time and creating the variable date

dtparts = t(as.data.frame(strsplit(Weather[,1],'T')))
row.names(dtparts) = NULL
thetimes = chron(dates=dtparts[,1],format=c('y-m-d'))

#selecting the interesting countries, renaming them and adding the time variable created before

weatherFinal<-Weather %>%
  select(utc_timestamp, BE_temperature,HR_temperature, CZ_temperature, DK_temperature,
         EE_temperature,FR_temperature,DE_temperature,IE_temperature, LV_temperature,
         LT_temperature, NL_temperature, NO_temperature, PT_temperature, RO_temperature,
         SI_temperature, ES_temperature, GB_temperature, ) %>%
  mutate(
    utc_timestamp = thetimes,
  ) %>%
  rename(Belgium = BE_temperature, Croatia = HR_temperature, Czechia = CZ_temperature,
         Denmark = DK_temperature, Estonia = EE_temperature, France = FR_temperature,
         Germany = DE_temperature, Ireland = IE_temperature, Latvia = LV_temperature,
         Lithuania = LT_temperature, Netherlands = NL_temperature, Norway = NO_temperature,
         Portugal = PT_temperature, Romania = RO_temperature, Slovenia = SI_temperature,
         Spain = ES_temperature, United_Kingdom = GB_temperature)

#Countries that I couldn't find the data Cyprus, Iceland, Malta, United states.

#Format date
sapply(weatherFinal, class)
FormatedDate<-as.Date(weatherFinal[,1], format = "%y-%m-%d")

#Group by day and filter by year 2019

DailyWeather<-weatherFinal %>%
  mutate(
    utc_timestamp = FormatedDate,) %>%
  filter(utc_timestamp >= as.Date("2019-01-01")) %>%
  group_by(utc_timestamp) %>%
  summarize(Belgium = mean(Belgium, na.rm = FALSE), Croatia = mean(Croatia, na.rm = FALSE),
            Czechia = mean(Czechia, na.rm = FALSE), Denmark = mean(Denmark, na.rm = FALSE),
            Estonia = mean(Estonia, na.rm = FALSE), France = mean(France, na.rm = FALSE),
            Germany = mean(Germany, na.rm = FALSE), Ireland = mean(Ireland, na.rm = FALSE),
            Latvia = mean(Latvia, na.rm = FALSE), Lithuania = mean(Lithuania, na.rm = FALSE),
            Netherlands = mean(Netherlands, na.rm = FALSE), Norway = mean(Norway, na.rm = FALSE),
            Portugal = mean(Portugal, na.rm = FALSE), Romania = mean(Romania, na.rm = FALSE),
            Slovenia = mean(Slovenia, na.rm = FALSE), Spain = mean(Spain, na.rm = FALSE),
            United_Kingdom = mean(United_Kingdom, na.rm = FALSE))
