### PROJECT 1 Covid19 - Statistics
# @authors: Ànnia, Rebecca, Rocío, Victor.



############################################################
############ READING DATA FROM EXCEL/CSV COVID ############
############################################################

#install.packages("readr") 
#install.packages("tidyverse")
library(readr);
library(tidyverse);

#data <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/rawdata/A_covidDaily.csv")
data <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")
data <- rename(data, code = iso_code)

head(data)   # mostrar 10 1es files cada colm
names(data)  # mostrar nom columnes

# is R reading data correctly?
# Has dd the correct number of ROWS and COLUMNS?
dim(data)

# TIPO DE OBJETO DATOS
class(data)

#check table
#View(data)

#open access by name to columns
#attach(data)
#?attach

#are all columns of expected types?
sapply(data, class)

# ens quedem amb les columnes que tenen menys NA's
apply(
  is.na
  (data), 2, mean)

# reduir la bd eliminant colm --> https://www.listendata.com/2015/06/r-keep-drop-columns-from-data-frame.html 
data <- subset(data, select = c(code, continent, location, date, total_cases, total_cases_per_million, new_cases, reproduction_rate, total_deaths, total_deaths_per_million, new_deaths, hospital_beds_per_thousand, total_tests, total_tests_per_thousand, population, population_density, median_age, gdp_per_capita))

## dates ##
class(data$date)  # --> ha ser data i no caràcter
library(lubridate)
#data$date <- ymd(data$date)
data$date <- as.Date(data$date, format="%Y-%m-%d")
class(data$date)

# x saber quants NA hi ha per colm
apply(is.na(data), 2, sum) # 2 = columnes



############################################################
############        READING DATA OBESITY        ############
############################################################

ob <- read.csv("rawdata/obesitat.csv") 
sapply(ob, class)

# renaming columns
 
ob <- rename(ob, country = Entity, code = Code, year = Year, obesity = Prevalence.of.obesity..both.sexes....WHO..2019.)

# taking 2016 year values only
ob <- filter(ob, year==2016) 

# removing some rows that don't serve
ob <- ob[!(ob$country=="Africa" | ob$country=="Americas" | ob$country=="Eastern Mediterranean" | ob$country=="Europe" | ob$country=="Global" | ob$country=="South-East Asia" | ob$country=="Western Pacific"),]
head(ob)

ob <- subset(ob, select = -c(year))


############################################################
############   READING DATA CAUSES DEATH        ############
############################################################


dataDeaths <- read.csv("rawdata/mortality_causes.csv") 
#head(dataDeaths)
#View(dataDeaths)

# renaming columns and rows
dataDeaths <- rename(dataDeaths, location = Country, causes = Causes, numDeathsOther = Both.sexes)
dataDeaths$location [dataDeaths$location == "Cabo Verde"] <- "Cape Verde"
dataDeaths$location [dataDeaths$location == "United States of America"] <- "United States"
dataDeaths$location [dataDeaths$location == "Republic of Moldova"] <- "Moldova"
dataDeaths$location [dataDeaths$location == "Bolivia (Plurinational State of)"] <- "Bolivia"

#sapply(dataDeaths, class)

# removing column year
dataDeaths <- dataDeaths[,-2]
head(dataDeaths)

library(reshape2)
dataDeaths <- dcast(dataDeaths,location~causes)
head(dataDeaths)
#class(dataDeathsOk)
dataDeaths <- rename(dataDeaths, cardiovascular_deaths = "Cardiovascular diseases", pulmonary_deaths = "Chronic obstructive pulmonary disease", diabetes_deaths = "Diabetes mellitus", cancer_deaths = "Malignant neoplasms")
names(dataDeaths)

# top 10 countries
top10Deaths <- dataDeaths %>% 
  filter(location %in% c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Eswatini", "Equatorial Guinea", "Morocco", "Namibia", 
                         "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Georgia", "United Arab Emirates", 
                         "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czechia", "Moldova", "Switzerland", 
                         "Panama", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala",
                         "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu", "Samoa",
                         "Chile", "Peru", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana","Brazil","United States"))


head(top10Deaths)
top10Deaths <- rename(top10Deaths, country = location)


############################################################
############      READING DATA REBECCA          ############
############################################################

dataSecurity <- read.csv("rawdata/healthSecurity.csv") 
head(dataSecurity)

############################################################
############   READING DATA TEMPERATURE        ############
############################################################

dataTemp <- read.csv("rawdata/temperatura.csv") 
dataTemp <- subset(dataTemp, select = -c(X))
dataTemp <- rename(dataTemp, country = Country)

write.csv(dataTemp, file = "B-top10DataTemperature.csv", row.names = FALSE)

############################################################
############     JOIN COVID + ALL EXTRA DATA   ############
############################################################

# info countries extra - Karina#
library(readxl)    # x poder llegir arxiu, q és xlsx
pp <- read_excel("rawdata/country-info.xlsx")

head(pp)
sapply(pp, class)

# seleccionar colm ok
pp <- subset(pp, select = c(COUNTRY, Government_Type, Corruption_preception))
# tmb es podria fer amb pp <- select(pp, COUNTRY, Government_Type, Corruption_preception)

# canviar nom colm
pp <- rename(pp, country = COUNTRY, gov = Government_Type, corruption = Corruption_preception)

# obesity + info paisos extra
obExtra <- left_join(ob, pp, by = "country")
head(obExtra)
extra <- left_join(top10Deaths, dataSecurity, by = "country")
#extra <- left_join(extra, dataTemp, by = "country")
extra <- left_join(obExtra, extra, by = "country")


# top 10 countries extra
extra <- extra %>% 
  filter(country %in% c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Eswatini", "Equatorial Guinea", "Morocco", "Namibia", 
                         "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Georgia", "United Arab Emirates", 
                         "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czechia", "Moldova", "Switzerland", 
                         "Panama", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala",
                         "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu", "Samoa",
                         "Chile", "Peru", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana","Brazil","United States"))

# extra + covid data
dataOk <- left_join(data, extra, by = "code")
dataOk <- subset(dataOk, select = -c(country)) 

# dataOk = extra + covid
dataOk <- dataOk %>% 
  filter(location %in% c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Eswatini", "Equatorial Guinea", "Morocco", "Namibia", 
                        "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Georgia", "United Arab Emirates", 
                        "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czechia", "Moldova", "Switzerland", 
                        "Panama", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala",
                        "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu", "Samoa",
                        "Chile", "Peru", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana","Brazil","United States"))

write.csv(dataOk, file = "B-top10Data.csv", row.names = FALSE)