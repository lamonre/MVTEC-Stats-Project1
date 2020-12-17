library(dplyr)
library(tidyr)

originalCovid = read.csv(url("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"))

removeNA = originalCovid %>%
    drop_na(weekly_hosp_admissions_per_million, hospital_beds_per_thousand)

countries = unique(removeNA$location)
length(countries)
print(countries)