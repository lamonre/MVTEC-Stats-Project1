####################################################
############     TOP 10 per Continent   ############
####################################################


table(dataOk$continent)
africa <- filter(dataOk, continent == "Africa")
asia <- filter(dataOk, continent == "Asia")
europe <- filter(dataOk, continent == "Europe")
northAmerica <- filter(dataOk, continent == "North America")
sudAmerica <- filter(dataOk, continent == "South America")
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

top10 <- filter(dataOk, location %in% c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Eswatini", "Equatorial Guinea", "Morocco", "Namibia", 
                                        "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Georgia", "United Arab Emirates", 
                                        "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czechia", "Moldova", "Switzerland", 
                                        "Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala",
                                        "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu", "Samoa",
                                        "Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana"))


write.csv(top10, file = "B-top10Data.csv")




#####################################################################

# interpolate data para llenar datos NA
# imputeTS library
# https://www.rdocumentation.org/packages/imputeTS/versions/3.1

#care with missing data!!!!
#table(Dictamen, useNA="ifany")

#What about ORDINAL VARIABLES?
#barplot(table(Tipo.trabajo))

#Tipo.trabajo<-factor(Tipo.trabajo, levels=c( "1", "2", "3", "4", "0"), labels=c("fixe","temporal","autonom","altres sit", "WorkingTypeUnknown"))
#pie(table(Tipo.trabajo))
#barplot(table(Tipo.trabajo))

#Export pre-processed data to persistent files, independent from statistical package
#write.table(dd, file = "credscoCategoriques.csv", sep = ";", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)