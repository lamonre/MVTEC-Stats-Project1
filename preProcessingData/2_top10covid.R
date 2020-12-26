### PROJECT 1 Covid19 - Statistics
# @authors: Ànnia, Rebecca, Rocío, Victor.



###################################################################
############ READING DATA FROM EXCEL/CSV COVID + EXTRA ############
###################################################################

library(readr);
library(tidyverse)

data <- read.csv("covidCleanObesity.csv")
data <- subset(data, select = -c(X))
head(data)   # mostrar 10 1es files cada colm
names(data)  # mostrar nom colm

top10 <- filter(data, location %in% c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Swaziland", "Equatorial Guinea", "Morocco", "Namibia", 
                                      "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Saudi Arabia", "United Arab Emirates", 
                                      "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czech Republic", "Moldova", "Switzerland", 
                                      "Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala",
                                      "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu",
                                      "Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana"))

top10 <- subset(top10, select = -c(country,year)) 
top10 <- rename(top10, obesity = share)
head(top10)
str(top10)
top10$date <- as.Date(top10$date, format="%Y-%m-%d")
class(top10$date)


# Top10b = Taula amb les mitjanes x Total cases x million
top10b <- top10 %>% 
  group_by(code, location, continent) %>%  # si date es posa aquí, apareix cada país per cada dia
  summarise(data = first(date),
            m_tcpm = mean(total_cases_per_million, na.rm = TRUE),   # si date es posa a summarise, apareix 1 país x 1 dia (agafa el 23 gen20)
            total_cases = mean(total_cases, na.rm = TRUE),
            new_cases_smoothed = mean(new_cases_smoothed, na.rm = TRUE),
            reproduction_rate = mean(reproduction_rate, na.rm = TRUE),
            total_deaths = mean(total_deaths, na.rm = TRUE),
            total_deaths_per_million = mean(total_deaths_per_million, na.rm = TRUE),
            new_cases_smoothed = mean(new_cases_smoothed, na.rm = TRUE)) %>%
  arrange(desc(m_tcpm)) # ordenat per Total cases x million

head(top10b)
str(top10b) # x veure tipus dada. x clust: caràcters han ser factors 
top10b$location <- as.factor(top10b$location)
class(top10b$location)
top10b$continent <- as.factor(top10b$continent)
class(top10b$continent)
top10b$data <- 
  as.Date
(top10b$data, format="%Y-%m-%d")
class(top10b$data)


# Cluster Mitja Total casos x million (dendograma)
library(cluster)
top10Matrix <- daisy(top10b[,6:10], metric = "gower", stand=TRUE)
top10dist <- top10Matrix^2
h1 <- hclust(top10dist, method="ward.D2")
plot(h1, labels = top10b$location, hang = -1, cex = 0.3, cex.axis=0.5, cex.lab=0.5)

# Identificar subgrups del Cluster (graficament)
subTop10b <- cutree(h1, k=4)
table(subTop10b)
rect.hclust(h1, k=4, border=2:5)

c_tab_continent <- table(subTop10b, top10b$continent) %>%
  as.data.frame.matrix() %>%
  mutate(subTop10b = c("cluster1", "cluster2", "cluster3", "cluster4")) %>%
  select(subTop10b, everything())

table(c_tab_continent)
