library(tidyverse)

## COVID data
data <- read.csv("owid-covid-data.csv")
sapply(data, class)

# removing columns not needed
data <- subset(data, select = -c(new_cases_smoothed, new_deaths_smoothed, new_cases_smoothed_per_million, new_deaths_smoothed_per_million, new_tests_smoothed, new_tests_smoothed_per_thousand, life_expectancy))

# changing data format
data <- as.Date(data$date, format="%d/%m/%y") ### doesn't work!!!

# how many Na values are in the columns?
apply(is.na(data), 2, sum)


## OBESITY data
ob <- read.csv("obesitat.csv") 
sapply(ob, class)

# renaming columns
ob <- rename(ob, country = Entity, code = Code, year = Year, share = Prevalence.of.obesity..both.sexes....WHO..2019.)

# taking 2016 year values only
ob <- filter(ob, year==2016) 

# removing some rows that don't serve
ob <- ob[!(ob$country=="Africa" | ob$country=="Americas" | ob$country=="Eastern Mediterranean" | ob$country=="Europe" | ob$country=="Global" | ob$country=="South-East Asia" | ob$country=="Western Pacific"),]


## INFO PAÏSOS EXTRA data
library(readxl)    
pp <- read_excel("InfoPaisosExtra.xlsx")
sapply(pp, class)

# removing columns not needed
pp <- select(pp, COUNTRY, Government_Type, Corruption_preception)

# renaming columns
pp <- rename(pp, country = COUNTRY, gov = Government_Type, corruption = Corruption_preception)


### JOIN three datasets
# obesity + info paisos extra
obPp <- left_join(ob, pp, by = "country")

# renaming code column for merge
data <- rename(data, code = iso_code)

# obPp + covid data
dataOk <- left_join(data, obPp, by = "code")



