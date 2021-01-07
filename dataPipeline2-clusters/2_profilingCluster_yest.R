### PROJECT 1 Covid19 - Statistics
# @authors: Ànnia, Rebecca, Rocío, Victor.



###################################################################
############ READING DATA FROM EXCEL/CSV COVID + EXTRA ############
###################################################################

#install.packages("readr")
#install.packages("tidyverse")
library(readr)
library(tidyverse)


#setwd("~/AMAZON") !!!! Rebecca
top10 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/preprocess/B_top10data_yest.csv") # S3 !!!! Rebecca
#top10 <- subset(top10, select = -c(0)) !!!! Don't need anymore, remove row.names from outputted CSV.
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



###################################################################
############        GENERAMOS LOS CLUSTERS            ############
###################################################################

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



###################################################################
############        PROFILING + KRUSKAL MODEL          ############
###################################################################

## Look at script -> "script R extra" -> "2_profiling_OK.R"
## Lo ponemos en otro script porque no es necesario que el pipeline ejecute ese código.



######################################################
############    SAVING CLUSTERS IN DF's   ############
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




################################################################
############    MATRIX CORRELATION CLUSTER GROUPS   ############
################################################################

# We will see here what are more significant correlation variables, for each group cluster

#install.packages("PerformanceAnalytics")
#install.packages("corrplot")
#library(corrplot)
#library(PerformanceAnalytics)

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
#chart.Correlation(c_g4_mean[,c(5:23)], histogram = FALSE, method = "pearson")

# Cluster g5 - Matrix correlation -> variables temporales
#chart.Correlation(c_g5[,c(5:11,13,14)], histogram = FALSE, method = "pearson")
                  
# Cluster g5 - Matrix correlation -> variables NO temporales (lo hacemos con la media)
# We can't do the correlation because we only have 2 countries


# Cluster g1 - Significancia categóricas
# g1_aov <- aov(m_tcpm ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(total_cases ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(new_cases ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(total_deaths ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(total_deaths_per_million ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(total_tests ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(total_tests_per_thousand ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(population ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(cardiovascular_deaths ~ corruption, data = c_g1_mean) 
# g1_aov <- aov(pulmonary_deaths ~ corruption, data = c_g1_mean)
# g1_aov <- aov(diabetes_deaths ~ corruption, data = c_g1_mean) 
# summary(g1_aov)


# Para 'healthSecurity' como solo tiene 1 level, no se pueden aplicar ni Anova, ni Ttest
# y hemos decidido que sea SIGNIFICATIVA pq todos los valores del cluster tienen el mismo valor




#################################################################
############   CLUSTER 1 - LINIAL MODEL PREDICTION   ############
#################################################################

# Seleccionamos las categóricas que nos dieron resultados más significativos 
lm_c_g1 <- lm(new_cases ~ total_cases + total_cases_per_million + total_deaths + 
                total_deaths_per_million + total_tests_per_thousand + total_tests + new_deaths + 
                population + cardiovascular_deaths + pulmonary_deaths + diabetes_deaths + date, c_g1)
summary(lm_c_g1)


# Cogemos los datos del cluster g1, para la fecha más actual del dataframe
# Duda: ¿Está bien coger sólo 1 día o tendríamos que haber cogido más para hacer la predicción?
g1_pred_subset <- subset(c_g1, date == max(c_g1$date))

# Hacemos la media de las variables para tener los datos medios del cluster
g1_mean_tc <- mean(g1_pred_subset$total_cases, na.rm = TRUE)
g1_mean_tcpm <- mean(g1_pred_subset$total_cases_per_million, na.rm = TRUE)
g1_mean_td <- mean(g1_pred_subset$total_deaths,na.rm = TRUE)
g1_mean_tdpm <- mean(g1_pred_subset$total_deaths_per_million, na.rm = TRUE)
g1_mean_ttpt <- mean(g1_pred_subset$total_tests_per_thousand, na.rm = TRUE)
g1_mean_tt <- mean(g1_pred_subset$total_tests, na.rm = TRUE)
g1_mean_nd <- mean(g1_pred_subset$new_deaths, na.rm = TRUE)
g1_mean_p <- mean(g1_pred_subset$population, na.rm = TRUE)
g1_mean_cd <- mean(g1_pred_subset$cardiovascular_deaths, na.rm = TRUE)
g1_mean_pd <- mean(g1_pred_subset$pulmonary_deaths, na.rm = TRUE)
g1_mean_dd <- mean(g1_pred_subset$diabetes_deaths, na.rm = TRUE)

today <- Sys.Date()-1

# mean_tc_c1 
g1_df_pred <- data.frame(date=c(today),
                         total_cases=c(g1_mean_tc),
                         total_cases_per_million=c(g1_mean_tcpm),
                         total_deaths=c(g1_mean_td),
                         total_deaths_per_million=c(g1_mean_tdpm),
                         total_tests_per_thousand=c(g1_mean_ttpt),
                         total_tests=c(g1_mean_tt),
                         new_deaths=c(g1_mean_nd),
                         population=c(g1_mean_p),
                         cardiovascular_deaths=c(g1_mean_cd),
                         pulmonary_deaths=c(g1_mean_pd),
                         diabetes_deaths=c(g1_mean_dd))


# hacemos prediccion
g1_pred_new_cases <- predict(object=lm_c_g1, newdata=g1_df_pred)

# creamos df con la prediccion y fecha actual
g1_pred_df_result <- data.frame(date=g1_df_pred$date,g1_pred_new_cases)

# Leemos las predicciones anteriores...
g1_pred_df_yest2 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest2/C-top10Cluster1Pred-yest2.csv")
g1_pred_df_yest3 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest3/C-top10Cluster1Pred-yest3.csv")  # S3 !!!! Rebecca
g1_pred_df_yest2$date <- as.Date(g1_pred_df_yest2$date, format="%Y-%m-%d")
g1_pred_df_yest3$date <- as.Date(g1_pred_df_yest3$date, format="%Y-%m-%d")
# g1_pred_df_final <- subset(g1_pred_df_final, select = -c(0))

# creamos un df con las predicciones anteriores + actual
g1_pred_df_final <- rbind(g1_pred_df_result, g1_pred_df_yest2, g1_pred_df_yest3)

# Export predictions for each cluster
write.csv(g1_pred_df_final, file = "C-top10Cluster1Pred-joined.csv", row.names = FALSE)  # S3 !!!! Rebecca



#################################################################
############   CLUSTER 2 - LINIAL MODEL PREDICTION   ############
#################################################################


# Cogemos los datos del cluster g1, para la fecha más actual del dataframe
# Duda: ¿Está bien coger sólo 1 día o tendríamos que haber cogido más para hacer la predicción?
g2_pred_subset <- subset(c_g2, date == max(c_g2$date))

# Hacemos la media de las variables para tener los datos medios del cluster
# eliminamos total_tests_per_thousand y total_tests de la prediccion porque en este cluster hay demasiados NA's
g2_mean_tc <- mean(g2_pred_subset$total_cases, na.rm = TRUE, nan.rm = TRUE)
g2_mean_tcpm <- mean(g2_pred_subset$total_cases_per_million, na.rm = TRUE, nan.rm = TRUE)
g2_mean_td <- mean(g2_pred_subset$total_deaths, na.rm = TRUE, nan.rm = TRUE)
g2_mean_tdpm <- mean(g2_pred_subset$total_deaths_per_million, na.rm = TRUE, nan.rm = TRUE)
#g2_mean_ttpt <- mean(g2_pred_subset$total_tests_per_thousand, na.rm = TRUE, nan.rm = TRUE)
#g2_mean_tt <- mean(g2_pred_subset$total_tests, na.rm = TRUE, nan.rm = TRUE)
g2_mean_nd <- mean(g2_pred_subset$new_deaths, na.rm = TRUE, nan.rm = TRUE)
g2_mean_p <- mean(g2_pred_subset$population, na.rm = TRUE, nan.rm = TRUE)
g2_mean_pod <- mean(g2_pred_subset$population_density, na.rm = TRUE, nan.rm = TRUE)
g2_mean_ma <- mean(g2_pred_subset$median_age, na.rm = TRUE, nan.rm = TRUE)
g2_mean_cd <- mean(g2_pred_subset$cardiovascular_deaths, na.rm = TRUE, nan.rm = TRUE)
g2_mean_pd <- mean(g2_pred_subset$pulmonary_deaths, na.rm = TRUE, nan.rm = TRUE)
g2_mean_dd <- mean(g2_pred_subset$diabetes_deaths, na.rm = TRUE, nan.rm = TRUE)
g2_mean_cad <- mean(g2_pred_subset$cancer_deaths, na.rm = TRUE, nan.rm = TRUE)


today2 <- Sys.Date()-1

# mean_tc_g2 
g2_df_pred <- data.frame(date=c(today2),
                         total_cases=c(g2_mean_tc),
                         total_cases_per_million=c(g2_mean_tcpm),
                         total_deaths=c(g2_mean_td),
                         total_deaths_per_million=c(g2_mean_tdpm),
                         new_deaths=c(g2_mean_nd),
                         population=c(g2_mean_p),
                         population_density=c(g2_mean_pod),
                         median_age=c(g2_mean_ma),
                         cardiovascular_deaths=c(g2_mean_cd),
                         pulmonary_deaths=c(g2_mean_pd),
                         diabetes_deaths=c(g2_mean_dd),
                         cancer_deaths=c(g2_mean_cad))


# Seleccionamos las categóricas que nos dieron resultados más significativos 

lm_c_g2 <- lm(new_cases ~ total_cases + total_cases_per_million + total_deaths + 
                total_deaths_per_million + new_deaths + population + population_density + 
                median_age + cardiovascular_deaths + pulmonary_deaths + diabetes_deaths + cancer_deaths + date, c_g2)
summary(lm_c_g2)


# hacemos prediccion
g2_pred_new_cases <- predict(object=lm_c_g2, newdata=g2_df_pred)

# creamos df con la prediccion y fecha actual
g2_pred_df_result <- data.frame(date=g2_df_pred$date,g2_pred_new_cases)

# Leemos las predicciones anteriores...
g2_pred_df_yest2 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest2/C-top10Cluster2Pred-yest2.csv")
g2_pred_df_yest3 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest3/C-top10Cluster2Pred-yest3.csv")  # S3 !!!! Rebecca
g2_pred_df_yest2$date <- as.Date(g2_pred_df_yest2$date, format="%Y-%m-%d")
g2_pred_df_yest3$date <- as.Date(g2_pred_df_yest3$date, format="%Y-%m-%d")
# g1_pred_df_final <- subset(g1_pred_df_final, select = -c(0))

# creamos un df con las predicciones anteriores + actual
g2_pred_df_final <- rbind(g2_pred_df_result, g2_pred_df_yest2, g2_pred_df_yest3)


# Export predictions for each cluster
write.csv(g2_pred_df_final, file = "C-top10Cluster2Pred-joined.csv", row.names = FALSE)  # S3 !!!! Rebecca


#################################################################
############   CLUSTER 3 - LINIAL MODEL PREDICTION   ############
#################################################################

lm_c_g3 <- lm(new_cases ~ total_cases + total_cases_per_million + total_deaths +
                total_deaths_per_million +  new_deaths + population + cardiovascular_deaths + 
                pulmonary_deaths + cancer_deaths + date, c_g3)
#summary(lm_c_g3)

# Cogemos los datos del cluster g3, para la fecha más actual del dataframe
# Duda: ¿Está bien coger sólo 1 día o tendríamos que haber cogido más para hacer la predicción?
g3_pred_subset <- subset(c_g3, date == max(c_g3$date))

# Hacemos la media de las variables para tener los datos medios del cluster
# eliminamos total_tests_per_thousand y total_tests de la prediccion porque en este cluster hay demasiados NA's
g3_mean_tc <- mean(g3_pred_subset$total_cases, na.rm = TRUE)
g3_mean_tcpm <- mean(g3_pred_subset$total_cases_per_million, na.rm = TRUE)
g3_mean_td <- mean(g3_pred_subset$total_deaths,na.rm = TRUE)
g3_mean_tdpm <- mean(g3_pred_subset$total_deaths_per_million, na.rm = TRUE)
#g3_mean_ttpt <- mean(g3_pred_subset$total_tests_per_thousand, na.rm = TRUE)
#g3_mean_tt <- mean(g3_pred_subset$total_tests, na.rm = TRUE)
g3_mean_nd <- mean(g3_pred_subset$new_deaths, na.rm = TRUE)
g3_mean_p <- mean(g3_pred_subset$population, na.rm = TRUE)
g3_mean_cd <- mean(g3_pred_subset$cardiovascular_deaths, na.rm = TRUE)
g3_mean_pd <- mean(g3_pred_subset$pulmonary_deaths, na.rm = TRUE)
g3_mean_cad <- mean(g3_pred_subset$cancer_deaths, na.rm = TRUE)

today3 <- Sys.Date()-1

# mean_tc_g3
g3_df_pred <- data.frame(date=c(today3),
                         total_cases=c(g3_mean_tc),
                         total_cases_per_million=c(g3_mean_tcpm),
                         total_deaths=c(g3_mean_td),
                         total_deaths_per_million=c(g3_mean_tdpm),
                         new_deaths=c(g3_mean_nd),
                         population=c(g3_mean_p),
                         cardiovascular_deaths=c(g3_mean_cd),
                         pulmonary_deaths=c(g3_mean_pd),
                         cancer_deaths=c(g3_mean_cad))

# eliminamos las columnas que la media da NA o nan
# g3_df_pred <- g3_df_pred[ , colSums(is.na(g3_df_pred)) == 0]

# hacemos prediccion
g3_pred_new_cases <- predict(object=lm_c_g3, newdata=g3_df_pred)

# creamos df con la prediccion y fecha actual
g3_pred_df_result <- data.frame(date=g3_df_pred$date,g3_pred_new_cases)

# Leemos las predicciones anteriores...
g3_pred_df_yest2 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest2/C-top10Cluster3Pred-yest2.csv")
g3_pred_df_yest3 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest3/C-top10Cluster3Pred-yest3.csv")  # S3 !!!! Rebecca
g3_pred_df_yest2$date <- as.Date(g3_pred_df_yest2$date, format="%Y-%m-%d")
g3_pred_df_yest3$date <- as.Date(g3_pred_df_yest3$date, format="%Y-%m-%d")
# g1_pred_df_final <- subset(g1_pred_df_final, select = -c(0))

# creamos un df con las predicciones anteriores + actual
g3_pred_df_final <- rbind(g3_pred_df_result, g3_pred_df_yest2, g3_pred_df_yest3)

# Export predictions for each cluster
write.csv(g3_pred_df_final, file = "C-top10Cluster3Pred-joined.csv", row.names = FALSE)  # S3 !!!! Rebecca



#################################################################
############   CLUSTER 4 - LINIAL MODEL PREDICTION   ############
#################################################################

lm_c_g4 <- lm(new_cases ~ total_cases + total_cases_per_million + total_deaths +
                total_deaths_per_million + new_deaths +
                population + median_age + gdp_per_capita + cardiovascular_deaths + diabetes_deaths + date, c_g4)
#summary(lm_c_g4)

# Cogemos los datos del cluster g4, para la fecha más actual del dataframe
# Duda: ¿Está bien coger sólo 1 día o tendríamos que haber cogido más para hacer la predicción?
g4_pred_subset <- subset(c_g4, date == max(c_g4$date))

# Hacemos la media de las variables para tener los datos medios del cluster
# eliminamos total_tests_per_thousand y total_tests de la prediccion porque en este cluster hay demasiados NA's
g4_mean_tc <- mean(g4_pred_subset$total_cases, na.rm = TRUE)
g4_mean_tcpm <- mean(g4_pred_subset$total_cases_per_million, na.rm = TRUE)
g4_mean_td <- mean(g4_pred_subset$total_deaths,na.rm = TRUE)
g4_mean_tdpm <- mean(g4_pred_subset$total_deaths_per_million, na.rm = TRUE)
#g4_mean_ttpt <- mean(g4_pred_subset$total_tests_per_thousand, na.rm = TRUE)
#g4_mean_tt <- mean(g4_pred_subset$total_tests, na.rm = TRUE)
g4_mean_nd <- mean(g4_pred_subset$new_deaths, na.rm = TRUE)
g4_mean_p <- mean(g4_pred_subset$population, na.rm = TRUE)
g4_mean_ma <- mean(g4_pred_subset$median_age, na.rm = TRUE)
g4_mean_gdp <- mean(g4_pred_subset$gdp_per_capita, na.rm = TRUE)
g4_mean_cd <- mean(g4_pred_subset$cardiovascular_deaths, na.rm = TRUE)
g4_mean_dd <- mean(g4_pred_subset$diabetes_deaths, na.rm = TRUE)

today4 <- Sys.Date()-1

g4_df_pred <- data.frame(date=c(today4),
                         total_cases=c(g4_mean_tc),
                         total_cases_per_million=c(g4_mean_tcpm),
                         total_deaths=c(g4_mean_td),
                         total_deaths_per_million=c(g4_mean_tdpm),
                         new_deaths=c(g4_mean_nd),
                         population=c(g4_mean_p),
                         median_age=c(g4_mean_ma),
                         gdp_per_capita=c(g4_mean_gdp),
                         cardiovascular_deaths=c(g4_mean_cd),
                         diabetes_deaths=c(g4_mean_dd))


# hacemos prediccion
g4_pred_new_cases <- predict(object=lm_c_g4, newdata=g4_df_pred)

# creamos df con la prediccion y fecha actual
g4_pred_df_result <- data.frame(date=g4_df_pred$date,g4_pred_new_cases)

# Leemos las predicciones anteriores...
g4_pred_df_yest2 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest2/C-top10Cluster4Pred-yest2.csv")
g4_pred_df_yest3 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest3/C-top10Cluster4Pred-yest3.csv")  # S3 !!!! Rebecca
g4_pred_df_yest2$date <- as.Date(g4_pred_df_yest2$date, format="%Y-%m-%d")
g4_pred_df_yest3$date <- as.Date(g4_pred_df_yest3$date, format="%Y-%m-%d")
# g1_pred_df_final <- subset(g1_pred_df_final, select = -c(0))

# creamos un df con las predicciones anteriores + actual
g4_pred_df_final <- rbind(g4_pred_df_result, g4_pred_df_yest2, g4_pred_df_yest3)

# Export predictions for each cluster
write.csv(g4_pred_df_final, file = "C-top10Cluster4Pred-joined.csv", row.names = FALSE)  # S3 !!!! Rebecca


#################################################################
############   CLUSTER 5 - LINIAL MODEL PREDICTION   ############
#################################################################

lm_c_g5 <- lm(new_cases ~ total_cases + total_cases_per_million + total_deaths +
                total_deaths_per_million + new_deaths +
                population + cardiovascular_deaths + pulmonary_deaths + diabetes_deaths + date, c_g5)
#summary(lm_c_g5)

# Cogemos los datos del cluster g5, para la fecha más actual del dataframe
# Duda: ¿Está bien coger sólo 1 día o tendríamos que haber cogido más para hacer la predicción?
g5_pred_subset <- subset(c_g5, date == max(c_g5$date))

# Hacemos la media de las variables para tener los datos medios del cluster
# eliminamos total_tests_per_thousand y total_tests de la prediccion porque en este cluster hay demasiados NA's
g5_mean_tc <- mean(g5_pred_subset$total_cases, na.rm = TRUE)
g5_mean_tcpm <- mean(g5_pred_subset$total_cases_per_million, na.rm = TRUE)
g5_mean_td <- mean(g5_pred_subset$total_deaths,na.rm = TRUE)
g5_mean_tdpm <- mean(g5_pred_subset$total_deaths_per_million, na.rm = TRUE)
#g5_mean_ttpt <- mean(g5_pred_subset$total_tests_per_thousand, na.rm = TRUE)
#g5_mean_tt <- mean(g5_pred_subset$total_tests, na.rm = TRUE)
g5_mean_nd <- mean(g5_pred_subset$new_deaths, na.rm = TRUE)
g5_mean_p <- mean(g5_pred_subset$population, na.rm = TRUE)
g5_mean_cd <- mean(g5_pred_subset$cardiovascular_deaths, na.rm = TRUE)
g5_mean_pd <- mean(g5_pred_subset$pulmonary_deaths, na.rm = TRUE)
g5_mean_dd <- mean(g5_pred_subset$diabetes_deaths, na.rm = TRUE)

today5 <- Sys.Date()-1

g5_df_pred <- data.frame(date=c(today5),
                         total_cases=c(g5_mean_tc),
                         total_cases_per_million=c(g5_mean_tcpm),
                         total_deaths=c(g5_mean_td),
                         total_deaths_per_million=c(g5_mean_tdpm),
                         new_deaths=c(g5_mean_nd),
                         population=c(g5_mean_p),
                         pulmonary_deaths=c(g5_mean_pd),
                         cardiovascular_deaths=c(g5_mean_cd),
                         diabetes_deaths=c(g5_mean_dd))


# hacemos prediccion
g5_pred_new_cases <- predict(object=lm_c_g5, newdata=g5_df_pred)

# creamos df con la prediccion y fecha actual
g5_pred_df_result <- data.frame(date=g5_df_pred$date,g5_pred_new_cases)

# Leemos las predicciones anteriores...
g5_pred_df_yest2 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest2/C-top10Cluster5Pred-yest2.csv")
g5_pred_df_yest3 <- read.csv("https://mvtec-group2.s3-eu-west-1.amazonaws.com/finaldata/yest3/C-top10Cluster5Pred-yest3.csv")  # S3 !!!! Rebecca
g5_pred_df_yest2$date <- as.Date(g5_pred_df_yest2$date, format="%Y-%m-%d")
g5_pred_df_yest3$date <- as.Date(g5_pred_df_yest3$date, format="%Y-%m-%d")
# g1_pred_df_final <- subset(g1_pred_df_final, select = -c(0))

# creamos un df con las predicciones anteriores + actual
g5_pred_df_final <- rbind(g5_pred_df_result, g5_pred_df_yest2, g5_pred_df_yest3)

# Export predictions for each cluster
write.csv(g5_pred_df_final, file = "C-top10Cluster5Pred-joined.csv", row.names = FALSE)  # S3 !!!! Rebecca
