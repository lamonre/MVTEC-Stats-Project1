library(dplyr)
library(tidyr)

ghsIndex = read.csv(file = "additionalData/globalSecurityIndex .csv")

countries = c("Belgium", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "France", "Germany", "Iceland", "Ireland", "Latvia", "Lithuania", "Malta", "Netherlands", "Norway", "Portugal", "Romania", "Slovenia", "Spain", "United Kingdom", "United States")

healthSecurity = ghsIndex %>%
        filter(Country %in% countries)  %>%
        subset(select = c(Country, category)) %>%
        rename(country = Country, healthSecurity = category)

write.csv(healthSecurity, file="rebecca/data_output/healthSecurity.csv",
          row.names=FALSE)
        