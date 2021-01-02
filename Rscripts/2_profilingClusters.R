### PROJECT 1 Covid19 - Statistics
# @authors: Ànnia, Rebecca, Rocío, Victor.



###################################################################
############ READING DATA FROM EXCEL/CSV COVID + EXTRA ############
###################################################################

install.packages("readr") 
install.packages("tidyverse")
library(readr)
library(tidyverse)


#setwd("~/AMAZON") !!!!

top10 <- read.csv("B-top10DataFixCluster.csv")
top10 <- subset(top10, select = -c(X))
head(top10)   # mostrar 10 1es files cada colm
names(top10)  # mostrar nom colm

library(lubridate)
top10$date <- as.Date(top10$date, format="%Y-%m-%d")
#hist(top10$date, breaks=4)

#top10cluster - agrupem per location, code and continent & treiem na's fent la mitjana
top10cluster <- top10 %>%
  group_by(code, location, continent) %>%  # si date es posa aquí, apareix cada país per cada dia
  summarise(date = first(date),
            m_tcpm = mean(total_cases_per_million, na.rm = TRUE),   # si date es posa a summarise, apareix 1 país x 1 dia (agafa el 23 gen20)
            total_cases = mean(total_cases, na.rm = TRUE),
            new_cases = mean(new_cases, na.rm = TRUE),
            reproduction_rate = mean(reproduction_rate, na.rm = TRUE),
            total_deaths = mean(total_deaths, na.rm = TRUE),
            total_deaths_per_million = mean(total_deaths_per_million, na.rm = TRUE),
            new_deaths = mean(new_deaths, na.rm = TRUE),
            hospital_beds_per_thousand = mean(hospital_beds_per_thousand, na.rm = TRUE),
            total_tests = mean(total_tests, na.rm = TRUE),
            total_tests_per_thousand = mean(total_tests_per_thousand, na.rm = TRUE),
            population = first(population),
            population_density = first(population_density),
            median_age = first(median_age),
            gdp_per_capita = first(gdp_per_capita),
            obesity = first(obesity),
            cardiovascular_deaths = mean(cardiovascular_deaths, na.rm = TRUE),
            pulmonary_deaths = mean(pulmonary_deaths, na.rm = TRUE),
            diabetes_deaths = mean(diabetes_deaths, na.rm = TRUE),
            cancer_deaths = mean(cancer_deaths, na.rm = TRUE),
            #temp = mean(AverageTemperature, na.rm = TRUE),
            corruption = first(corruption),
            gov = first(gov),
            healthSecurity = first(healthSecurity)) %>%
  arrange(desc(m_tcpm))



# Transform na & nan to 0 or "no data"
top10cluster$obesity[is.na(top10cluster$obesity)] <- 0
top10cluster$population_density[is.na(top10cluster$population_density)] <- 0
top10cluster$median_age[is.na(top10cluster$median_age)] <- 0
top10cluster$gdp_per_capita[is.na(top10cluster$gdp_per_capita)] <- 0
top10cluster$corruption[is.na(top10cluster$corruption)] <- "no data"
top10cluster$gov[is.na(top10cluster$gov)] <- "no data"
top10cluster$healthSecurity[is.na(top10cluster$healthSecurity)] <- "no data"
top10cluster$reproduction_rate[is.nan(top10cluster$reproduction_rate)] <- 0
top10cluster$total_deaths[is.nan(top10cluster$total_deaths)] <- 0
top10cluster$total_deaths_per_million[is.nan(top10cluster$total_deaths_per_million)] <- 0
top10cluster$hospital_beds_per_thousand[is.nan(top10cluster$hospital_beds_per_thousand)] <- 0
top10cluster$total_tests_per_thousand[is.nan(top10cluster$total_tests_per_thousand)] <- 0
top10cluster$total_tests[is.nan(top10cluster$total_tests)] <- 0
top10cluster$new_deaths[is.nan(top10cluster$new_deaths)] <- 0
top10cluster$cardiovascular_deaths[is.nan(top10cluster$cardiovascular_deaths)] <- 0
top10cluster$pulmonary_deaths[is.nan(top10cluster$pulmonary_deaths)] <- 0
top10cluster$diabetes_deaths[is.nan(top10cluster$diabetes_deaths)] <- 0
top10cluster$cancer_deaths[is.nan(top10cluster$cancer_deaths)] <- 0
#top10cluster$temp[is.na(top10cluster$temp)] <- 0

# Comprovem que no hi ha na's
apply(
  is.na
  (top10cluster), 2, mean)
  
str(top10cluster) # x veure tipus dada. x clust: caràcters han ser factors 
top10cluster$location <- as.factor(top10cluster$location)
class(top10cluster$location)
top10cluster$continent <- as.factor(top10cluster$continent)
class(top10cluster$continent)
top10cluster$code <- as.factor(top10cluster$code)
class(top10cluster$code)
top10cluster$gov <- as.factor(top10cluster$gov)
class(top10cluster$gov)
top10cluster$corruption <- as.factor(top10cluster$corruption)
class(top10cluster$corruption)
top10cluster$healthSecurity <- as.factor(top10cluster$healthSecurity)
class(top10cluster$healthSecurity)
library(lubridate)
top10cluster$date <- as.Date(top10cluster$date, format="%Y-%m-%d")
class(top10cluster$date)

############### CLUSTER ################

top10cluster <-top10cluster[-c(13), ]
top10cluster <-top10cluster[-c(15),]

library(cluster)
str(top10cluster)
top10Matrix4 <- daisy(top10cluster[,c(5:23)], metric = "gower", stand=TRUE)
top10dist4 <- top10Matrix4^2
h4 <- hclust(top10dist4, method="ward.D2")
plot(h4, labels = top10cluster$location, hang = -1, cex = 0.3, cex.axis=0.5, cex.lab=0.5)

cluster4 <- cutree(h4, k=4)
table(cluster4)
rect.hclust(h4, k=4, border=2:5)

cluster <- cluster4
#View(cluster)

# Ajuntem la columna cluster al data frame top10cluster
top10cluster <- cbind(top10cluster, cluster)
top10cluster <- rename(top10cluster, cluster = "...27")
names(top10cluster)


############### PROFILING + KRUSKAL MODEL ################
## Look at script -> "script R extra" -> 2_profiling_OK.R
## Lo ponemos en otro script porque no es necesario que el pipeline ejecute ese código.



######################################################
############ MODEL DE PREDICCIÓ -> LINEAL ############
######################################################

## Lineal Model by Top 10 - Cluster groups ##

# Cluster g1 (6)   -> Qatar, Bahrain, Luxembourg, Kuwait, United Arab Emirates,Singapore
# Cluster g2 (37)  -> San Marino, Andorra, Vatican, Panama, Montenegro, Armenia, Oman, Maldives, Moldova, 
#                     Costa Rica, Cape Verde, Georgia, Bahamas, Bolivia, Dominican Republic, Ecuador, Belize, Honduras, Morocco,             
#                     Suriname, Djibouti, Libya, Paraguay, Sao Tome and Principe, Guatemala, Eswatini, Gabon, Namibia, Guyana, 
#                     Equatorial Guinea, New Zealand, Marshall Islands, Papua New Guinea, Fiji, Solomon Islands, Samoa, Vanuatu
# Cluster g3 (7)   -> Chile, Israel, Belgium, Czechia, Switzerland, Canada, Australia
# Cluster g4 (6)   -> Mexico, Spain, Colombia, Peru, South Africa, Argentina
# Cluster g5 (2)   -> United States, Brazil


# Cluster g1
c_g1 <- top10 %>% 
  filter(location %in% c("Qatar", "Bahrain", "Luxembourg", "Kuwait", "United Arab Emirates","Singapore"))
table(c_g1$location)

c_g1_mean <- top10cluster %>% 
  filter(location %in% c("Qatar", "Bahrain", "Luxembourg", "Kuwait", "United Arab Emirates","Singapore"))

# Cluster g2
c_g2 <- top10 %>% 
  filter(location %in% c("Panama", "Montenegro", "Armenia", "Oman", "Maldives","Morocco", "Moldova", "Costa Rica", "Cape Verde", "Georgia", "Bahamas", "Bolivia", "Dominican Republic", "Ecuador", "Belize", "Honduras", "Suriname", "Djibouti", "Libya", "Paraguay", "Sao Tome and Principe", "Guatemala", "Eswatini", "Gabon", "Namibia", "Guyana",  "Equatorial Guinea", "New Zealand", "Marshall Islands", "Papua New Guinea","Fiji", "Solomon Islands", "Samoa", "Vanuatu"))
table(c_g2$location)

c_g2_mean <- top10cluster %>% 
  filter(location %in% c("Panama", "Montenegro", "Armenia", "Oman", "Maldives","Morocco", "Moldova", "Costa Rica", "Cape Verde", "Georgia", "Bahamas", "Bolivia", "Dominican Republic", "Ecuador", "Belize", "Honduras", "Suriname", "Djibouti", "Libya", "Paraguay", "Sao Tome and Principe", "Guatemala", "Eswatini", "Gabon", "Namibia", "Guyana",  "Equatorial Guinea", "New Zealand", "Marshall Islands", "Papua New Guinea","Fiji", "Solomon Islands", "Samoa", "Vanuatu"))

# Cluster g3
c_g3 <- top10 %>% 
  filter(location %in% c("Chile", "Israel", "Belgium", "Czechia", "Switzerland", "Canada","Australia"))
table(c_g3$location)

c_g3_mean <- top10cluster %>% 
  filter(location %in% c("Chile", "Israel", "Belgium", "Czechia", "Switzerland", "Canada","Australia"))

# Cluster g4
c_g4 <- top10 %>% 
  filter(location %in% c("Peru", "Spain", "Argentina", "Colombia", "South Africa", "Mexico"))
table(c_g4$location)

c_g4_mean <- top10cluster %>% 
  filter(location %in% c("Peru", "Spain", "Argentina", "Colombia", "South Africa", "Mexico"))

# Cluster g5
c_g5 <- top10 %>% 
  filter(location %in% c("United States", "Brazil"))
table(c_g5$location)

install.packages("PerformanceAnalytics")
install.packages("corrplot")
library(corrplot)
library(PerformanceAnalytics)

# Cluster g1 - Matrix correlation -> variables temporales
chart.Correlation(c_g1[,c(5:11,13,14)], histogram = FALSE, method = "pearson")

# Cluster g1 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
chart.Correlation(c_g1_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g2 - Matrix correlation -> variables temporales
chart.Correlation(c_g2[,c(5:11,13,14)], histogram = FALSE, method = "pearson")

# Cluster g2 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
chart.Correlation(c_g2_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g3 - Matrix correlation -> variables temporales
chart.Correlation(c_g3[,c(5:11,13,14)], histogram = FALSE, method = "pearson")

# Cluster g3 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
chart.Correlation(c_g3_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g4 - Matrix correlation -> variables temporales
chart.Correlation(c_g4[,c(5:11,13,14)], histogram = FALSE, method = "pearson")

# Cluster g4 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
chart.Correlation(c_g4_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g5 - Matrix correlation -> variables temporales

# Cluster g5 - Matrix correlation -> variables NO temporales (lo hacemos con la media)

#names(c_g1[,c(5:11,13,14)])
#names(c_g1)

lm_c_g1 <- lm(top10cluster$total_cases ~ top10cluster$total_deaths, top10cluster)
# summary(top10lm)
# plot(top10lm)
# plot(top10b$total_cases, top10b$total_deaths)
# boxplot(top10b$total_cases, horizontal=TRUE, main=names(top10b)[6])
# boxplot(top10b$total_deaths,horizontal=TRUE,main=names(top10b)[9])
# hist(top10b$total_cases, breaks=15)
# hist(top10b$total_deaths,breaks=15)
# cor(dist,speed)
# cor.test(dist,speed)

