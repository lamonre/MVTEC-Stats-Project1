### PROJECT 1 Covid19 - Statistics
# @authors: Ànnia, Rebecca, Rocío, Victor.



############################################################
############ READING DATA FROM EXCEL/CSV COVID ############
############################################################

library(readr);
library(tidyverse)

data <- read.csv("originalData/owid-covid-data.csv")
head(data)   # mostrar 10 1es files cada colm
names(data)  # mostrar nom colm

#ddCovid <- read_excel("originalData/owid-covid-data-131120.xlsx", col_names = TRUE, na="NA");
#ddExtra <- read_excel("originalData/country-info-clean.xlsx",col_names = TRUE, na="NA");


# is R reading data correctly?
# Has dd the correct number of ROWS and COLUMNS?
dim(data)

# TIPO DE OBJETO DATOS
class(data)

#check table
View(data)

#open access by name to columns
attach(data)
?attach

#are all columns of expected types?
sapply(data, class)

# reduir la bd eliminant colm --> https://www.listendata.com/2015/06/r-keep-drop-columns-from-data-frame.html 
data <- subset(data, select = c(iso_code, continent, location, date, total_cases, total_cases_per_million, new_cases_smoothed, reproduction_rate, total_deaths, total_deaths_per_million, new_deaths_smoothed, weekly_hosp_admissions_per_million, hospital_beds_per_thousand, population, population_density, median_age, gdp_per_capita))  # mostrar nom colm
head(data)

## dates ##
class(data$date)  # --> ha ser data i no caràcter
library(lubridate)
#data$date <- ymd(data$date)
data$date <- as.Date(data$date, format="%Y-%m-%d")
class(data$date)

# x saber quants NA hi ha per colm
apply(is.na(data), 2, sum) # 2 = columnes

## DATA EXTRA KARINA
dataExtra <- read_excel("originalData/country-info.xlsx")
head(dataExtra)   # mostrar 10 1es files c

dataExtra <- subset(dataExtra, select = c(COUNTRY, Government_Type, Corruption_preception))  # mostrar nom colm
head(dataExtra)

dataExtra <- rename(dataExtra, country = COUNTRY, gov = Government_Type, corruption = Corruption_preception)
head(dataExtra)

## DATA OBESITY
ob <- read.csv("additionalData/obesitat.csv") 
sapply(ob, class)

# renaming columns
ob <- rename(ob, country = Entity, code = Code, year = Year, share = Prevalence.of.obesity..both.sexes....WHO..2019.)

# taking 2016 year values only
ob <- filter(ob, year==2016) 

# removing some rows that don't serve
ob <- ob[!(ob$country=="Africa" | ob$country=="Americas" | ob$country=="Eastern Mediterranean" | ob$country=="Europe" | ob$country=="Global" | ob$country=="South-East Asia" | ob$country=="Western Pacific"),]
head(ob)


### JOIN three datasets
# obesity + info paisos extra
obExtra <- left_join(ob, dataExtra, by = "country")
head(obExtra)

# obesity + info paisos extra + covid data
data <- rename(data, code = iso_code)
dataOk <- left_join(data, obExtra, by = "code")
head(dataOk)

write.csv(dataOk, file = "preProcessingData/covidCleanObesity.csv")

### TOP 10 per Continent
table(dataOk$continent)
africa <- filter(dataOk, continent == "Africa")
asia <- filter(dataOk, continent == "Asia")
europe <- filter(dataOk, continent == "Europe")
northAmerica <- filter(dataOk, continent == "North America")
sudAmerica <- filter(dataOk, continent == "Sud America")
oceania <- filter(dataOk, continent == "Oceania")

africa <- arrange(africa, desc(total_cases_per_million))
asia <- arrange(asia, desc(total_cases_per_million))
europe <- arrange(europe, desc(total_cases_per_million))
northAmerica <- arrange(northAmerica, desc(total_cases_per_million))
sudAmerica <- arrange(sudAmerica, desc(total_cases_per_million))
oceania <- arrange(oceania, desc(total_cases_per_million))

class(europe$location)
europe$location <- as.factor(europe$location)
africa$location <- as.factor(africa$location)
asia$location <- as.factor(asia$location)
northAmerica$location <- as.factor(northAmerica$location)
sudAmerica$location <- as.factor(sudAmerica$location)
oceania$location <- as.factor(oceania$location)
class(europe$location)

eu10 <- subset(europe, select = c(location, total_cases_per_million))
#na.rm = borra los NA
eu10 <- eu10 %>% 
  group_by(location) %>% 
  summarise(mean_tcpm = mean(total_cases_per_million, na.rm = TRUE)) %>% 
  arrange(desc(mean_tcpm))

africa10 <- africa %>% 
  group_by(location) %>% 
  summarise(mean_tcpm = mean(total_cases_per_million, na.rm = TRUE)) %>% 
  arrange(desc(mean_tcpm))

asia10 <- asia %>% 
  group_by(location) %>% 
  summarise(mean_tcpm = mean(total_cases_per_million, na.rm = TRUE)) %>% 
  arrange(desc(mean_tcpm))

northA10 <- northAmerica %>% 
  group_by(location) %>% 
  summarise(mean_tcpm = mean(total_cases_per_million, na.rm = TRUE)) %>% 
  arrange(desc(mean_tcpm))

sudA10 <- sudAmerica %>% 
  group_by(location) %>% 
  summarise(mean_tcpm = mean(total_cases_per_million, na.rm = TRUE)) %>% 
  arrange(desc(mean_tcpm))

oce10 <- oceania %>% 
  group_by(location) %>% 
  summarise(mean_tcpm = mean(total_cases_per_million, na.rm = TRUE)) %>% 
  arrange(desc(mean_tcpm))


########################################################################
############ READING DATA FROM EXCEL/CSV EXTRA CAUSES DEATH ############
########################################################################


library(readxl)
dataDeaths <- read_excel("additionalData/data_mortality_causes_WHO_2016/data_mortality_causes_OK.xlsx")
head(dataDeaths)
View(dataDeaths)

sapply(dataDeaths, class)

# canviar nom colm
dataDeaths <- rename(dataDeaths, Bothsexes = `Both sexes`)
head(dataDeaths)
class(dataDeaths)

dataDeathsCountriesSelected <- filter(dataDeaths, Country %in% c("Belgium", "Croatia", "Cyprus", "Czechia", "Denmark", "Estonia", "France", "Germany", "Iceland", "Ireland", "Latvia", "Lithuania", "Malta", "Netherlands", "Norway", "Portugal", "Romania", "Slovenia", "Spain", "United Kingdom of Great Britain and Northern Ireland", "United States of America"))
View(dataDeathsCountriesSelected)

#####################################################################

# interpolate data para llenar datos NA
# imputeTS library
# https://www.rdocumentation.org/packages/imputeTS/versions/3.1

#care with missing data!!!!
table(Dictamen, useNA="ifany")

#What about ORDINAL VARIABLES?
barplot(table(Tipo.trabajo))

Tipo.trabajo<-factor(Tipo.trabajo, levels=c( "1", "2", "3", "4", "0"), labels=c("fixe","temporal","autonom","altres sit", "WorkingTypeUnknown"))
pie(table(Tipo.trabajo))
barplot(table(Tipo.trabajo))



#Export pre-processed data to persistent files, independent from statistical package
write.table(dd, file = "credscoCategoriques.csv", sep = ";", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)