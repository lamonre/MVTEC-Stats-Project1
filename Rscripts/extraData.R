#Creating extra_data file

library(readr)
library(tidyverse)
library(readxl)

setwd("/Users/rvpazos/Documents/mvtec/cross-module-assignment/MVTEC-Stats-Project1/Rscripts")

#Read all external files
owid <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")
extra <- read_excel("country-info.xlsx")
healthSecurity <- read.csv("healthSecurity.csv")
obesitat <- read.csv("obesitat.csv")
mortality <- read.csv("mortality_causes.csv")

#Set countries to filter to from pre-analysis here
countries = c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Eswatini", "Equatorial Guinea", "Morocco", "Namibia", "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czechia", "Moldova", "Switzerland", "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Saudi Arabia", "United Arab Emirates", "Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala", "Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana", "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu")

## Renaming some problematic countries
#extra
extra[extra == "Cabo Verde"] <- "Cape Verde"
extra[extra == "Czech Republic"] <- "Czechia"
extra[extra == "Bahamas, The"] <- "Bahamas"

#obesity
obesitat[obesitat == "Swaziland"] <- "Eswatini"
obesitat[obesitat == "Czech Republic"] <- "Czechia"

obesitatFiltered = obesitat %>%
    filter(Entity %in% countries, Year == "2016")

## Subset owid, extra data, obesitat, mortality, temperature to just the selected countries and columns
owidSelect <- owid %>%
        group_by(iso_code, location) %>%
        filter(location %in% countries) %>%
        summarise(population = first(population), 
                  popDensity = first(population_density), 
                  medianAge = first(median_age), 
                  gdp = first(gdp_per_capita))

extraSelect <- extra %>%
        filter(COUNTRY %in% countries) %>%
        subset(select = c(COUNTRY, Government_Type, Corruption_preception)) %>%
        rename(location = COUNTRY, govt = Government_Type, corruption = Corruption_preception)

obesitatSelect <- obesitatFiltered %>%
      subset(select = c(Code, Prevalence.of.obesity..both.sexes....WHO..2019.)) %>%
      rename(iso_code = Code, obesity = Prevalence.of.obesity..both.sexes....WHO..2019.)
    
#Join all

extra_data <- owidSelect %>%
        inner_join(extraSelect, c("location" = "location")) %>%
        inner_join(healthSecurity, c("location" = "country")) %>%
        inner_join(obesitatSelect, c("iso_code" = "iso_code"))

#export to CSV       
write.csv(extra_data, file="extra_data.csv",
          row.names=FALSE)


#Checking all countries are found
countries %in% owidSelect$location
countries %in% extraSelect$location
countries %in% obesitatFiltered$Entity

