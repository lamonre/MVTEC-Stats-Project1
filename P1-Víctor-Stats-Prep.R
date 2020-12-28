library(dplyr)
library(tidyr)
library(readxl)
library(lubridate)

country_info = read_excel("/Users/VictorGarcia/Documents/PRIVAT/Uni/Màster UdG/TreballFinal1/country-info.xlsx")
sapply(country_info, class)
#attach(country_info)
##Shortenning qualitative variables

GovType<-factor(country_info$Government_Type)
#levels(GovType)
GovTypeRewritten<-GovType
Govnewvalues <-c("AbsMonar","Communist","ConstMonar", "Dictatorship", "Transition", "IslParRep", "IslPreRep", "IslSPreRep", "ParRep", "PreLimDemo", "PreRep", "SPreRep")
GovTypeRewritten <- Govnewvalues[match(GovTypeRewritten,levels(GovType))]

CorrPre<-factor(country_info$Corruption_preception)
#levels(CorrPre)
CorrPreRewritten<-CorrPre
Corrnewvalues <-c("HCorr", "LCorr", "NI")
CorrPreRewritten <- Corrnewvalues[match(CorrPreRewritten,levels(CorrPre))]

DevStatus<-factor(country_info$Development_Status)
#levels(DevStatus)
DevStatusRewritten<-DevStatus
DevStatusnewvalues <-c("Developed", "Developing", "Transition")
DevStatusRewritten <- DevStatusnewvalues[match(DevStatusRewritten,levels(DevStatus))]

country_info2<-rename(country_info, location = Country_Name)

##Adding those columns to the dataset
RewrittenCountryInfo<-country_info2 %>%
  select(location, Government_Type, Corruption_preception, Development_Status) %>%
  mutate(
    Government_Type = GovTypeRewritten,
    Corruption_preception = CorrPreRewritten,
    Development_Status = DevStatusRewritten
  )


##Reading original covid database

originalCovid = read.csv(file = "/Users/VictorGarcia/Documents/PRIVAT/Uni/Màster UdG/TreballFinal1/owid-covid-data.csv")
sapply(originalCovid, class)
FormatedDate<-as.Date(originalCovid[,4], format = "%Y-%m-%d")

originalCovid2<-rename(originalCovid, IcuAdxWeek =weekly_icu_admissions, HospAdxWeek=weekly_hosp_admissions, stringency = stringency_index, HospBedsx1000 = hospital_beds_per_thousand, total_casesxM = total_cases_per_million, life_expect = life_expectancy)

RewrittenOriginalCovid<-originalCovid2 %>%
  select(continent,location, date, total_cases, total_casesxM, new_cases,new_cases_smoothed, total_deaths,new_deaths, new_deaths_smoothed,reproduction_rate,hosp_patients,
         IcuAdxWeek,HospAdxWeek, total_tests, new_tests, tests_per_case, positive_rate,
        stringency, population, population_density,median_age, gdp_per_capita,
         handwashing_facilities, HospBedsx1000, life_expect) %>%
  mutate(
    date = FormatedDate,
  )

##Joining both databases
Database <- left_join(RewrittenCountryInfo, RewrittenOriginalCovid, by = c('location'))

##Aggregate fortnightly
Aggregatedf<- Database
Aggregatedf$week <- floor_date(Aggregatedf$date, "week")
WeeklyDf<-Aggregatedf %>%
  group_by(week, location, Government_Type, Corruption_preception,continent) %>%
  summarize(total_cases = max(total_cases, na.rm = FALSE), total_casesxM = max(total_casesxM, na.rm = FALSE),
            new_cases = cumsum(new_cases), total_deaths = max(total_deaths, na.rm = FALSE),new_deaths = cumsum(new_deaths),
            reproduction_rate = mean(reproduction_rate, na.rm = FALSE), hosp_patients = mean(hosp_patients, na.rm = FALSE), IcuAdxWeek = mean(IcuAdxWeek, na.rm = FALSE),
            HospAdxWeek = mean(HospAdxWeek, na.rm = FALSE), total_tests=max(total_tests, na.rm = FALSE), new_tests = cumsum(new_tests), population = mean(population, na.rm = FALSE),
            population_density = mean(population_density, na.rm = FALSE), median_age = mean(median_age, na.rm = FALSE), gdp_per_capita = mean(gdp_per_capita, na.rm = FALSE), HospBedsx1000 = mean(HospBedsx1000, na.rm = FALSE),
            life_expect = mean(life_expect, na.rm = FALSE))
###Check what countries has the info we want
RemoveNAhosp = originalCovid %>%
  drop_na(hospital_beds_per_thousand)
unique(RemoveNAhosp$location)
