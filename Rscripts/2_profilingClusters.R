### PROJECT 1 Covid19 - Statistics
# @authors: Ànnia, Rebecca, Rocío, Victor.



###################################################################
############ READING DATA FROM EXCEL/CSV COVID + EXTRA ############
###################################################################

library(readr);
library(tidyverse)

top10 <- read.csv("B-top10DataFixCluster.csv")
top10 <- subset(top10, select = -c(X))
head(top10)   # mostrar 10 1es files cada colm
names(top10)  # mostrar nom colm


# top10cluster - agrupem per location, code and continent & treiem na's fent la mitjana
top10cluster <- top10 %>% 
  group_by(code, location, continent) %>%  # si date es posa aquí, apareix cada país per cada dia
  summarise(m_tcpm = mean(total_cases_per_million, na.rm = TRUE),   # si date es posa a summarise, apareix 1 país x 1 dia (agafa el 23 gen20)
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
top10cluster$reproduction_rate[is.nan(top10cluster$reproduction_rate)] <- 0
top10cluster$total_deaths[is.nan(top10cluster$total_deaths)] <- 0
top10cluster$total_deaths_per_million[is.nan(top10cluster$total_deaths_per_million)] <- 0
top10cluster$hospital_beds_per_thousand[is.nan(top10cluster$hospital_beds_per_thousand)] <- 0
top10cluster$total_tests_per_thousand[is.nan(top10cluster$total_tests_per_thousand)] <- 0
top10cluster$total_tests[is.nan(top10cluster$total_tests)] <- 0
top10cluster$new_deaths[is.nan(top10cluster$new_deaths)] <- 0

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


############### CLUSTER ################

top10cluster <-top10cluster[-c(13), ]
#top10cluster <-top10cluster[,-c(20)]

library(cluster)
str(top10cluster)
top10Matrix4 <- daisy(top10cluster[,c(4:20)], metric = "gower", stand=TRUE)
top10dist4 <- top10Matrix4^2
h4 <- hclust(top10dist4, method="ward.D2")
plot(h4, labels = top10cluster$location, hang = -1, cex = 0.3, cex.axis=0.5, cex.lab=0.5)

cluster4 <- cutree(h4, k=6)
table(cluster4)
rect.hclust(h4, k=6, border=2:5)

cluster <- cluster4
#View(cluster)

# Ajuntem la columna cluster al data frame top10cluster
top10cluster <- cbind(top10cluster, cluster)
top10cluster <- rename(top10cluster, cluster = "...21")
names(top10cluster)


############### PROFILING + KRUSKAL MODEL ################

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


# put our data into Karina's variable names
dades <- as.data.frame(top10cluster)
dd <- as.data.frame(top10cluster)
P <- cluster4
n <- dim(dades)[1] #need number of rows
nameP<-"Cluster"
K <-dim(dades)[2]
nc <- length(levels(factor(P)))
pvalk <- matrix(data=0,nrow=nc,ncol=K, dimnames=list(levels(P),names(dades)))

par(ask=TRUE)


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
    if(class(dd[,k])=="Date"){
      print(summary(dd[,k]))
      print(sd(dd[,k]))
      #decide breaks: weeks, months, quarters...
      hist(dd[,k],breaks="weeks")
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
# for (c in 1:length(levels(as.factor(P)))) {
#   if(!is.na(levels(as.factor(P))[c])){
#     print(paste("P.values per class:",levels(as.factor(P))[c]));
#     print(sort(pvalk[c,]), digits=3) 
#   }
# }

#afegir la informacio de les modalitats de les qualitatives a la llista de pvalues i fer ordenacio global

#saving the dataframe in an external file
#write.table(dd, file = "credscoClean.csv", sep = ";", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)




############### MODEL DE PREDICCIÓ -> LINEAL ################

# Correlació i Linial Model de Predicció
# top10lm <- lm(top10b$total_cases ~ top10b$total_deaths, top10b)
# summary(top10lm)
# plot(top10lm)
# plot(top10b$total_cases, top10b$total_deaths)
# boxplot(top10b$total_cases, horizontal=TRUE, main=names(top10b)[6])
# boxplot(top10b$total_deaths,horizontal=TRUE,main=names(top10b)[9])
# hist(top10b$total_cases, breaks=15)
# hist(top10b$total_deaths,breaks=15)
# cor(dist,speed)
# cor.test(dist,speed)