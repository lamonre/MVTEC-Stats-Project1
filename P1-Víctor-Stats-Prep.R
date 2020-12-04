library(dplyr)
library(tidyr)
library(readxl)

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
  select(location, Government_Type, Corruption_preception, Development_Status,GDP_per_unit_of_energy_use_constant,Population_total) %>%
  mutate(
    Government_Type = GovTypeRewritten,
    Corruption_preception = CorrPreRewritten,
    Development_Status = DevStatusRewritten
  )


##Reading original covid database

originalCovid = read.csv(file = "/Users/VictorGarcia/Documents/PRIVAT/Uni/Màster UdG/TreballFinal1/owid-covid-data.csv")
sapply(originalCovid, class)
FormatedDate<-as.Date(originalCovid[,4], format = "%Y-%m-%d")

originalCovid2<-rename(originalCovid, IcuAdxWeek =weekly_icu_admissions, HospAdxWeek=weekly_hosp_admissions, stringency = stringency_index, HospBedsx1000 = hospital_beds_per_thousand, life_expect = life_expectancy)

RewrittenOriginalCovid<-originalCovid2 %>%
  select(location, date, total_cases, new_cases,total_deaths,new_deaths, icu_patients, hosp_patients,
         IcuAdxWeek,HospAdxWeek, total_tests, new_tests, tests_per_case, positive_rate,
         tests_units, stringency, population, population_density,median_age, gdp_per_capita,
         HospBedsx1000, life_expect) %>%
  mutate(
    date = FormatedDate,
  )

##Joining both databases
Database <- left_join(RewrittenCountryInfo, RewrittenOriginalCovid, by = c('location'))
