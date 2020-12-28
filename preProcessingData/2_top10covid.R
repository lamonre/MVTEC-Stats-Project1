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
top10b$data <- as.Date(top10b$data, format="%Y-%m-%d")
class(top10b$data)


# Top10c 
top10c <- top10 %>% 
  group_by(code, location, continent) %>%  # si date es posa aquí, apareix cada país per cada dia
  summarise(data = first(date), 
            total_cases_per_million = mean(total_cases_per_million, na.rm = TRUE),  
            total_cases = mean(total_cases, na.rm = TRUE),
            new_cases_smoothed = mean(new_cases_smoothed, na.rm = TRUE),
            reproduction_rate = mean(reproduction_rate, na.rm = TRUE),
            total_deaths = mean(total_deaths, na.rm = TRUE),
            total_deaths_per_million = mean(total_deaths_per_million, na.rm = TRUE),
            hospital_beds_per_thousand = mean(hospital_beds_per_thousand, na.rm = TRUE),
            population = first(population),
            population_density = first(population_density),
            median_age = first(median_age),
            gdp_per_capita = first(gdp_per_capita),
            obesity = first(obesity)) %>%
  arrange(desc(m_tcpm))

# Top10noData 
top10noData <- top10 %>% 
  group_by(code, location, continent) %>% 
  summarise(total_cases_per_million = mean(total_cases_per_million, na.rm = TRUE),   # si date es posa a summarise, apareix 1 país x 1 dia (agafa el 23 gen20)
          hospital_beds_per_thousand = mean(hospital_beds_per_thousand, na.rm = TRUE),
          population = first(population),
          population_density = first(population_density),
          median_age = first(median_age),
          gdp_per_capita = first(gdp_per_capita),
          obesity = first(obesity),
          corruption = first(corruption),
          gov = first(gov)) %>%
  arrange(desc(total_cases_per_million))
  


############### CLUSTER ################

#### Cluster 1 Mitja Total casos x million (dendograma)
library(cluster)
top10Matrix <- daisy(top10b[,5:10], metric = "gower", stand=TRUE)
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


#### Cluster 2  (dendograma)
top10Matrix2 <- daisy(top10c[,c(5,7:12)], metric = "gower", stand=TRUE)
top10dist2 <- top10Matrix2^2
h2 <- hclust(top10dist2, method="ward.D2")
plot(h2, labels = top10c$location, hang = -1, cex = 0.3, cex.axis=0.5, cex.lab=0.5)

subTop10c <- cutree(h2, k=4)
table(subTop10c)
rect.hclust(h2, k=4, border=2:5)


#### Cluster 3 top10noData(dendograma)
top10noData$corruption <- as.factor(top10noData$corruption)
top10noData$gov <- as.factor(top10noData$gov)
class(top10noData$gov)
top10Matrix3 <- daisy(top10noData[,4:12], metric = "gower", stand=TRUE)
top10dist3 <- top10Matrix3^2
h3 <- hclust(top10dist3, method="ward.D2")
plot(h3, labels = top10noData$location, hang = -1, cex = 0.3, cex.axis=0.5, cex.lab=0.5)

subTop10noData <- cutree(h3, k=4)
table(subTop10noData)
rect.hclust(h3, k=4, border=2:5)


#### Cluster 4 Corrupción y Total casos x million (dendograma)
top10Matrix4 <- daisy(top10noData[,c(4,12)], metric = "gower", stand=TRUE)
top10dist4 <- top10Matrix4^2
h4 <- hclust(top10dist4, method="ward.D2")
plot(h4, labels = top10noData$location, hang = -1, cex = 0.3, cex.axis=0.5, cex.lab=0.5)

sub4 <- cutree(h4, k=4)
table(sub4)
rect.hclust(h4, k=4, border=2:5)




############### PROFILING + KRUSKAL MODEL################

Xnum <- top10noData$total_cases_per_million
Xquali <- top10noData$gov
P <- h4

#Calcula els valor test de la variable Xnum per totes les modalitats del factor P
ValorTestXnum <- function(Xnum,P){
  #freq dis of fac
  nk <- as.vector(table(P)); 
  n <- sum(nk); 
  #mitjanes x grups
  xk <- tapply(Xnum,P,mean);
  #valors test
  txk <- (xk-mean(Xnum))/(sd(Xnum)*sqrt((n-nk)/(n*nk))); 
  #p-values
  pxk <- pt(txk,n-1,lower.tail=F);
  for(c in 1:length(levels(as.factor(P)))){if (pxk[c]>0.5){pxk[c]<-1-pxk[c]}}
  return (pxk)
}

ValorTestXnum
str(pxk)

ValorTestXquali <- function(P,Xquali){
  taula <- table(P,Xquali);
  n <- sum(taula); 
  pk <- apply(taula,1,sum)/n;
  pj <- apply(taula,2,sum)/n;
  pf <- taula/(n*pk);
  pjm <- matrix(data=pj,nrow=dim(pf)[1],ncol=dim(pf)[2]);      
  dpf <- pf - pjm; 
  dvt <- sqrt(((1-pk)/(n*pk))%*%t(pj*(1-pj))); 
  #si hi ha divisions iguals a 0 dona NA i no funciona
  zkj <- dpf
  zkj[dpf!=0]<-dpf[dpf!=0]/dvt[dpf!=0]; 
  pzkj <- pnorm(zkj,lower.tail=F);
  for(c in 1:length(levels(as.factor(P)))){for (s in 1:length(levels(Xquali))){if (pzkj[c,s]> 0.5){pzkj[c,s]<-1- pzkj[c,s]}}}
  return (list(rowpf=pf,vtest=zkj,pval=pzkj))
}


#dades contain the dataset
dades<-top10noData
#dades<-dd[filtro,]
#dades<-df
K<-dim(dades)[2]
par(ask=TRUE)

#P must contain the class variable
#P<-top10b$location
#P<-df[,33]

nc<-length(levels(factor(P)))
pvalk <- matrix(data=0,nrow=nc,ncol=K, dimnames=list(levels(P),names(dades)))
nameP<-"Class"
n<-dim(dades)[1]

for(k in 1:K){
  if (is.numeric(dades[,k])){ 
    print(paste("Anàlisi per classes de la Variable:", names(dades)[k]))
    
    boxplot(dades[,k]~P, main=paste("Boxplot of", names(dades)[k], "vs", nameP ), horizontal=TRUE)
    
    barplot(tapply(dades[[k]], P, mean),main=paste("Means of", names(dades)[k], "by", nameP ))
    abline(h=mean(dades[[k]]))
    legend(0,mean(dades[[k]]),"global mean",bty="n")
    print("Estadístics per groups:")
    for(s in levels(as.factor(P))) {print(summary(dades[P==s,k]))}
    o<-oneway.test(dades[,k]~P)
    print(paste("p-valueANOVA:", o$p.value))
    kw<-kruskal.test(dades[,k]~P)
    print(paste("p-value Kruskal-Wallis:", kw$p.value))
    pvalk[,k]<-ValorTestXnum(dades[,k], P)
    print("p-values ValorsTest: ")
    print(pvalk[,k])      
  }else{
    if(class(top10noData[,k])=="Date"){
      print(summary(top10noData[,k]))
      print(sd(top10noData[,k]))
      #decide breaks: weeks, months, quarters...
      hist(top10noData[,k],breaks="weeks")
    }else{
      #qualitatives
      print(paste("Variable", names(dades)[k]))
      table<-table(P,dades[,k])
      #   print("Cross-table")
      #   print(table)
      rowperc<-prop.table(table,1)
      
      colperc<-prop.table(table,2)
      #  print("Distribucions condicionades a files")
      # print(rowperc)
      
      #ojo porque si la variable es true o false la identifica amb el tipus Logical i
      #aquest no te levels, por tanto, coertion preventiva
      
      dades[,k]<-as.factor(dades[,k])
      
      
      marg <- table(as.factor(P))/n
      print(append("Categories=",levels(as.factor(dades[,k]))))
      
      #from next plots, select one of them according to your practical case
      plot(marg,type="l",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]))
      paleta<-rainbow(length(levels(dades[,k])))
      for(c in 1:length(levels(dades[,k]))){lines(colperc[,c],col=paleta[c]) }
      
      #with legend
      plot(marg,type="l",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]))
      paleta<-rainbow(length(levels(dades[,k])))
      for(c in 1:length(levels(dades[,k]))){lines(colperc[,c],col=paleta[c]) }
      legend("topright", levels(dades[,k]), col=paleta, lty=2, cex=0.6)
      
      #condicionades a classes
      print(append("Categories=",levels(dades[,k])))
      plot(marg,type="n",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]))
      paleta<-rainbow(length(levels(dades[,k])))
      for(c in 1:length(levels(dades[,k]))){lines(rowperc[,c],col=paleta[c]) }
      
      #with legend
      plot(marg,type="n",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]))
      paleta<-rainbow(length(levels(dades[,k])))
      for(c in 1:length(levels(dades[,k]))){lines(rowperc[,c],col=paleta[c]) }
      legend("topright", levels(dades[,k]), col=paleta, lty=2, cex=0.6)
      
      #amb variable en eix d'abcisses
      marg <-table(dades[,k])/n
      print(append("Categories=",levels(dades[,k])))
      plot(marg,type="l",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]), las=3)
      #x<-plot(marg,type="l",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]), xaxt="n")
      #text(x=x+.25, y=-1, adj=1, levels(CountryName), xpd=TRUE, srt=25, cex=0.7)
      paleta<-rainbow(length(levels(as.factor(P))))
      for(c in 1:length(levels(as.factor(P)))){lines(rowperc[c,],col=paleta[c]) }
      
      #with legend
      plot(marg,type="l",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]), las=3)
      for(c in 1:length(levels(as.factor(P)))){lines(rowperc[c,],col=paleta[c])}
      legend("topright", levels(as.factor(P)), col=paleta, lty=2, cex=0.6)
      
      #condicionades a columna 
      plot(marg,type="n",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]), las=3)
      paleta<-rainbow(length(levels(as.factor(P))))
      for(c in 1:length(levels(as.factor(P)))){lines(colperc[c,],col=paleta[c]) }
      
      #with legend
      plot(marg,type="n",ylim=c(0,1),main=paste("Prop. of pos & neg by",names(dades)[k]), las=3)
      for(c in 1:length(levels(as.factor(P)))){lines(colperc[c,],col=paleta[c])}
      legend("topright", levels(as.factor(P)), col=paleta, lty=2, cex=0.6)
      
      table<-table(dades[,k],P)
      print("Cross Table:")
      print(table)
      print("Distribucions condicionades a columnes:")
      print(colperc)
      
      #diagrames de barres apilades                                         
      
      paleta<-rainbow(length(levels(dades[,k])))
      barplot(table(dades[,k], as.factor(P)), beside=FALSE,col=paleta )
      
      barplot(table(dades[,k], as.factor(P)), beside=FALSE,col=paleta )
      legend("topright",levels(as.factor(dades[,k])),pch=1,cex=0.5, col=paleta)
      
      #diagrames de barres adosades
      barplot(table(dades[,k], as.factor(P)), beside=TRUE,col=paleta )
      
      barplot(table(dades[,k], as.factor(P)), beside=TRUE,col=paleta)
      legend("topright",levels(as.factor(dades[,k])),pch=1,cex=0.5, col=paleta)
      
      print("Test Chi quadrat: ")
      print(chisq.test(dades[,k], as.factor(P)))
      
      print("valorsTest:")
      print( ValorTestXquali(P,dades[,k]))
      #calcular els pvalues de les quali
    }
  }
}#endfor

#descriptors de les classes més significatius. Afegir info qualits
for (c in 1:length(levels(as.factor(P)))) {
  if(!is.na(levels(as.factor(P))[c])){
    print(paste("P.values per class:",levels(as.factor(P))[c]));
    print(sort(pvalk[c,]), digits=3) 
  }
}

#afegir la informacio de les modalitats de les qualitatives a la llista de pvalues i fer ordenacio global

#saving the dataframe in an external file
#write.table(dd, file = "credscoClean.csv", sep = ";", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)




############### MODEL DE PREDICCIÓ -> LINEAL ################

# Correlació i Linial Model de Predicció
top10lm <- lm(top10b$total_cases ~ top10b$total_deaths, top10b)
summary(top10lm)
plot(top10lm)
plot(top10b$total_cases, top10b$total_deaths)
boxplot(top10b$total_cases, horizontal=TRUE, main=names(top10b)[6])
boxplot(top10b$total_deaths,horizontal=TRUE,main=names(top10b)[9])
hist(top10b$total_cases, breaks=15)
hist(top10b$total_deaths,breaks=15)
cor(dist,speed)
cor.test(dist,speed)