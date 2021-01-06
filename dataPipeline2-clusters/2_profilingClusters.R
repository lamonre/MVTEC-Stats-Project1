### PROJECT 1 Covid19 - Statistics
# @authors: Ànnia, Rebecca, Rocío, Victor.



###################################################################
############ READING DATA FROM EXCEL/CSV COVID + EXTRA ############
###################################################################

#install.packages("readr") 
#install.packages("tidyverse")
library(readr)
library(tidyverse)


#setwd("~/AMAZON") !!!!

top10 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/B_top10data.csv") # S3 
#top10 <- subset(top10, select = -c(X))
head(top10)   # mostrar 10 1es files cada colm
names(top10)  # mostrar nom colm

library(lubridate)
top10$date <- as.Date(top10$date, format="%Y-%m-%d")
#hist(top10$date, breaks=4)

#top10cluster - agrupem per location, code and continent & treiem na's fent la mitjana
top10clusterAll <- top10 %>%
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
top10clusterAll$obesity[is.na(top10clusterAll$obesity)] <- 0
top10clusterAll$population_density[is.na(top10clusterAll$population_density)] <- 0
top10clusterAll$median_age[is.na(top10clusterAll$median_age)] <- 0
top10clusterAll$gdp_per_capita[is.na(top10clusterAll$gdp_per_capita)] <- 0
top10clusterAll$corruption[is.na(top10clusterAll$corruption)] <- "no data"
top10clusterAll$gov[is.na(top10clusterAll$gov)] <- "no data"
top10clusterAll$healthSecurity[is.na(top10clusterAll$healthSecurity)] <- "no data"
top10clusterAll$reproduction_rate[is.nan(top10clusterAll$reproduction_rate)] <- 0
top10clusterAll$total_deaths[is.nan(top10clusterAll$total_deaths)] <- 0
top10clusterAll$total_deaths_per_million[is.nan(top10clusterAll$total_deaths_per_million)] <- 0
top10clusterAll$hospital_beds_per_thousand[is.nan(top10clusterAll$hospital_beds_per_thousand)] <- 0
top10clusterAll$total_tests_per_thousand[is.nan(top10clusterAll$total_tests_per_thousand)] <- 0
top10clusterAll$total_tests[is.nan(top10clusterAll$total_tests)] <- 0
top10clusterAll$new_deaths[is.nan(top10clusterAll$new_deaths)] <- 0
top10clusterAll$cardiovascular_deaths[is.nan(top10clusterAll$cardiovascular_deaths)] <- 0
top10clusterAll$pulmonary_deaths[is.nan(top10clusterAll$pulmonary_deaths)] <- 0
top10clusterAll$diabetes_deaths[is.nan(top10clusterAll$diabetes_deaths)] <- 0
top10clusterAll$cancer_deaths[is.nan(top10clusterAll$cancer_deaths)] <- 0
#top10clusterAll$temp[is.na(top10clusterAll$temp)] <- 0

# Comprovem que no hi ha na's
apply(
  is.na
  (top10clusterAll), 2, mean)
  
str(top10clusterAll) # x veure tipus dada. x clust: caràcters han ser factors 
top10clusterAll$location <- as.factor(top10clusterAll$location)
class(top10clusterAll$location)
top10clusterAll$continent <- as.factor(top10clusterAll$continent)
class(top10clusterAll$continent)
top10clusterAll$code <- as.factor(top10clusterAll$code)
class(top10clusterAll$code)
top10clusterAll$gov <- as.factor(top10clusterAll$gov)
class(top10clusterAll$gov)
top10clusterAll$corruption <- as.factor(top10clusterAll$corruption)
class(top10clusterAll$corruption)
top10clusterAll$healthSecurity <- as.factor(top10clusterAll$healthSecurity)
class(top10clusterAll$healthSecurity)
library(lubridate)
top10clusterAll$date <- as.Date(top10clusterAll$date, format="%Y-%m-%d")
class(top10clusterAll$date)

############### CLUSTER ################

# Quitamos United States y Brazil, pq las analizaremos en un grupo diferente
# Lo explicamos en el informe
top10cluster <-top10clusterAll[-c(13), ]
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
## We have selected the cluster by countries on date 03-01-2021

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

c_g5_mean <- top10clusterAll %>% 
  filter(location %in% c("United States", "Brazil"))

#install.packages("PerformanceAnalytics")
#install.packages("corrplot")
library(corrplot)
library(PerformanceAnalytics)

# Cluster g1 - Matrix correlation -> variables temporales
#chart.Correlation(c_g1[,c(5:11,13,14)], histogram = FALSE, method = "pearson")

# Cluster g1 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
#chart.Correlation(c_g1_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g2 - Matrix correlation -> variables temporales
#chart.Correlation(c_g2[,c(5:11,13,14)], histogram = FALSE, method = "pearson")

# Cluster g2 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
#chart.Correlation(c_g2_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g3 - Matrix correlation -> variables temporales
#chart.Correlation(c_g3[,c(5:11,13,14)], histogram = FALSE, method = "pearson")

# Cluster g3 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
#chart.Correlation(c_g3_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g4 - Matrix correlation -> variables temporales
#chart.Correlation(c_g4[,c(5:11,13,14)], histogram = FALSE, method = "pearson")

# Cluster g4 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
chart.Correlation(c_g4_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g5 - Matrix correlation -> variables temporales
#chart.Correlation(c_g5[,c(5:11,13,14)], histogram = FALSE, method = "pearson")
                  
# Cluster g5 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
# We can't do the correlation because we only have 2 countries


# Cluster g1 - Significancia categóricas
g1_aov <- aov(m_tcpm ~ corruption, data = c_g1_mean) 
g1_aov <- aov(total_cases ~ corruption, data = c_g1_mean) 
g1_aov <- aov(new_cases ~ corruption, data = c_g1_mean) 
g1_aov <- aov(total_deaths ~ corruption, data = c_g1_mean) 
g1_aov <- aov(total_deaths_per_million ~ corruption, data = c_g1_mean) 
g1_aov <- aov(total_tests ~ corruption, data = c_g1_mean) 
g1_aov <- aov(total_tests_per_thousand ~ corruption, data = c_g1_mean) 
g1_aov <- aov(population ~ corruption, data = c_g1_mean) 
g1_aov <- aov(cardiovascular_deaths ~ corruption, data = c_g1_mean) 
g1_aov <- aov(pulmonary_deaths ~ corruption, data = c_g1_mean)
g1_aov <- aov(diabetes_deaths ~ corruption, data = c_g1_mean) 
summary(g1_aov)

g1_aov <- aov(m_tcpm ~ gov, data = c_g1_mean) 
g1_aov <- aov(total_cases ~ gov, data = c_g1_mean) 
g1_aov <- aov(new_cases ~ gov, data = c_g1_mean) 
g1_aov <- aov(total_deaths ~ gov, data = c_g1_mean) 
g1_aov <- aov(total_deaths_per_million ~ gov, data = c_g1_mean) 
g1_aov <- aov(total_tests ~ gov, data = c_g1_mean) 
g1_aov <- aov(total_tests_per_thousand ~ gov, data = c_g1_mean) 
g1_aov <- aov(population ~ gov, data = c_g1_mean) 
g1_aov <- aov(cardiovascular_deaths ~ gov, data = c_g1_mean) 
g1_aov <- aov(pulmonary_deaths ~ gov, data = c_g1_mean)
g1_aov <- aov(diabetes_deaths ~ gov, data = c_g1_mean) 
summary(g1_aov)

# Para 'healthSecurity' como solo tiene 1 level, no se pueden aplicar ni Anova, ni Ttest
# y hemos decidido que sea SIGNIFICATIVA pq todos los valores del cluster tienen el mismo valor


lm_c_g1 <- lm(new_cases ~ total_cases + total_cases_per_million + total_deaths + 
                total_deaths_per_million + total_tests_per_thousand + total_tests + new_deaths + 
                population + cardiovascular_deaths + pulmonary_deaths + diabetes_deaths, c_g1)
summary(lm_c_g1)

#install.packages("stargazer")
#library(stargazer)
#stargazer(lm_c_g1, type="text", df=FALSE)

# plot(lm_c_g1)
predict(lm_c_g1)


write.csv(lm_c_g1, file = "C-top10Cluster1Pred.csv")
write.csv(lm_c_g2, file = "C-top10Cluster2Pred.csv")
write.csv(lm_c_g3, file = "C-top10Cluster3Pred.csv")
write.csv(lm_c_g4, file = "C-top10Cluster4Pred.csv")
write.csv(lm_c_g5, file = "C-top10Cluster5Pred.csv")


