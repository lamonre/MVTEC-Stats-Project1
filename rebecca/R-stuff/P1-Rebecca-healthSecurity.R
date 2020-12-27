library(dplyr)
library(tidyr)

setwd("/Users/rvpazos/Documents/mvtec/cross-module-assignment/MVTEC-Stats-Project1")

ghsIndex = read.csv(file = "additionalData/globalSecurityIndex .csv")

countries = c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Swaziland", "Equatorial Guinea", "Morocco", "Namibia", "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czech Republic", "Moldova", "Switzerland", "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Saudia Arabia", "United Arab Emirates", "Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala", "Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana", "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu")

healthSecurity = ghsIndex %>%
        filter(Country %in% countries)  %>%
        subset(select = c(Country, category)) %>%
        rename(country = Country, healthSecurity = category)

write.csv(healthSecurity, file="rebecca/data_output/healthSecurity.csv",
          row.names=FALSE)
        