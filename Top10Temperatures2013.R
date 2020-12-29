library(dplyr)
library(tidyr)
library(chron)
library(lubridate)

##Temperature extracted from https://data.world/data-society/global-climate-change-data
World_T = read.csv(file = "/Users/VictorGarcia/Documents/PRIVAT/Uni/Màster UdG/TreballFinal1/World_Temperatures/data-society-global-climate-change-data/GlobalLandTemperatures/GlobalLandTemperaturesByCountry.csv")

#selecting the interesting countries and formatting the date
FormatedDate<-as.Date(World_T[,1], format = "%Y-%m-%d")

allCountries = c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Swaziland", "Equatorial Guinea", "Morocco", "Namibia", "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czech Republic", "Moldova", "Switzerland", "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Saudia Arabia", "United Arab Emirates", "Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala", "Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana", "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu")

weather_filtered<-World_T %>%
  select(dt, AverageTemperature, Country) %>%
  mutate(
    dt = FormatedDate
  ) %>%
  filter(dt >= as.Date("2012-01-01") & dt < as.Date("2013-01-01"), Country %in% allCountries)