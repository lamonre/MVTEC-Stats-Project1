library(dplyr)
library(tidyr)

setwd("/Users/rvpazos/Documents/mvtec/cross-module-assignment/MVTEC-Stats-Project1")

ghsIndex = read.csv(file = "additionalData/globalSecurityIndex .csv")

countries = c("Cabo Verde", "South Africa", "Djibouti", "São Tomé and Príncipe", "Libya", "Gabon", "eSwatini (Swaziland)", "Equatorial Guinea", "Morocco", "Namibia", "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czech Republic", "Moldova", "Switzerland", "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Saudi Arabia", "United Arab Emirates", "Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala", "Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana", "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu")

healthSecurity = ghsIndex %>%
        filter(Country %in% countries)  %>%
        subset(select = c(Country, category)) %>%
        rename(location = Country, healthSecurity = category)

#rename to match OWID        
healthSecurity[healthSecurity == "Cabo Verde"] <- "Cape Verde"
healthSecurity[healthSecurity == "eSwatini (Swaziland)"] <- "Swaziland"
healthSecurity[healthSecurity == "São Tomé and Príncipe"] <- "Sao Tome and Principe"
healthSecurity[healthSecurity == "Saudi Arabia"] <- "Saudia Arabia"

write.csv(healthSecurity, file="rebecca/data_output/healthSecurity.csv",
          row.names=FALSE)

