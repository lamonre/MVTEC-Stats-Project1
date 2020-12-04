
#Time Management
setwd("D:/karina/docencia/01areferenciesPPT/0DadesPractiques/planta")
#planta<- read.table("depdani41dates.csv",header=T);
planta<- read.table("plantaVminitabMisOK.csv",header=T, sep=";");

names(planta)
n<-dim(planta)[1]
sapply(planta,class)

planta<- read.table("plantaVminitabMisOK.csv",header=T, sep=";", dec=".", na.strings="*");


attach(planta)

hist(Q.E)
boxplot(Q.E, horizontal=TRUE)
summary(Q.E)
sd(Q.E)
sd(Q.E, na.rm=TRUE)


#Graphical representation
plot.ts(Q.E)
#quasi equivale a
index<-c(1:n)
plot(index, Q.E)
lines(index, Q.E)

#equivalent to
plot(index, Q.E, type="n")
lines(index, Q.E)


#for all numerical variables
K=dim(planta)[2]
par(ask=TRUE)
for(k in 4:K){plot.ts(planta[,k], main=paste("Time Series of", names(planta)[k]))}

par(ask=FALSE)



#Rotular eix X amb les dates 
plot.ts(Q.E, xaxt ="n", main="Time Series of Caudal.E")
ticks<-seq(1,n,by=1)
axis(side = 1, at=ticks, labels = DATE,  cex.axis = 0.7, las=2)

plot.ts(Q.E, xaxt ="n", main="Time Series of Caudal.E")
ticks<-seq(1,n,by=14)
axis(side = 1, at=ticks, labels = DATE[ticks],  cex.axis = 0.7, las=2)


plot.ts(Q.E, xaxt ="n", main="Time Series of Caudal.E")
ticks<-seq(1,n,by=14)
axis(side = 1, at=ticks, labels = DATEformated[ticks],  cex.axis = 0.7, las=2)

#equivalent a
CaudalE<-ts(Q.E)
class(Q.E)
class(CaudalE)

plot(CaudalE, xaxt ="n", main="Time Series of Caudal.E")
ticks<-seq(1,n,by=14)
axis(side = 1, at=ticks, labels = DATEformated[ticks],  cex.axis = 0.7, las=2)


par(ask=TRUE)
for(k in 4:K){
  plot.ts(planta[,k], xaxt="n",main=paste("Time Series of", names(planta)[k]))
  axis(side = 1, at=ticks, labels = DATEformated[ticks],  cex.axis = 0.7, las=2)
}

par(ask=FALSE)


plot.ts(NH4.S)
#NH4 seems empty!!!!
hist(NH4.S)
plot(index, NH4.S)

plot.ts(NH4.S)
points(index, NH4.S)
lines(index,NH4.S)

plot.ts(IM.B, xaxt="n",main="Time Series of IM.B")
axis(side = 1, at=ticks, labels = DATEformated[ticks],  cex.axis = 0.7, las=2)

#install.packages("zoo")
#library(zoo)
IM.Bcomplete<-na.approx(IM.B)
plot.ts(IM.Bcomplete)
plot.ts(IM.Bcomplete, xaxt="n",main="Time Series of IM.B imputed")
axis(side = 1, at=ticks, labels = DATEformated[ticks],  cex.axis = 0.7, las=2)

#Managing Dates

hist(DATEformated)
# R no enten que es aquesta variable
class(DATEformated)

#la pren com a qualitative!
summary(DATEformated)

Data<-as.Date(DATEformated, format="%d/%m/%y")
summary(Data)

#Symbol Meaning                  Example
# %d    day as a number (0-31)   01-31
# %D    Date format
# %a    Abbreviated weekday      Mon
# %A    Unabbreviated weekdat    Monday
# %m    Month (01-12)            00-12
# %b    Abbreviated month        Jan
# %B    Unabbreviated month      January
# %y    2-digit year             07
# %Y    4-digit year             2007
##
# %c    Date and time 
# %C    Century
# %H    Hours (00-23)            15
# %I    Hours (1-12)             3
# %j    Day of the year (0-365)  250
# %M    Minute (00-59)           34
# %S    Second as integer (0-61) 07

Data<-as.Date(DateNorm, format="%d/%m/%y")
class(Data)
summary(Data)
sd(Data)
sd(Data, na.rm=TRUE)

par(ask=FALSE)
hist(Data)
hist(Data,breaks="weeks")
hist(Data,breaks="months")
hist(Data,breaks="quarters")


fmt <- "%b-%d-%y" # format for axis labels
labs <- format(Data, fmt)
CaudalE<-ts(Q.E)
class(CaudalE)
plot(CaudalE, main="Time Series of Caudal.E")

plot(CaudalE, xaxt ="n", main="Time Series of Caudal.E")
ticks<-seq(1,n,by=14)
axis(side = 1, at=ticks, labels = Data[ticks],  cex.axis = 0.7, las=2)

fmt <- "%b-%d-%y" # format for axis labels
labs <- format(Data, fmt)
CaudalE<-ts(Q.E)
plot(CaudalE, xaxt ="n", main="Time Series of Caudal.E")
ticks<-seq(1,n,by=14)
axis(side = 1, at=ticks, labels = labs[ticks],  cex.axis = 0.7, las=2)

plot(CaudalE, xaxt ="n", main="Time Series of Caudal.E")
ticks<-seq(1,n,by=7)
axis(side = 1, at=ticks, labels = labs[ticks],  cex.axis = 0.7, las=2)

#  Hores
DataHoraria<-as.POSIXct(DateNorm, format="%d/%m/%y")
head(DataHoraria)
DH<-format(DataHoraria,"%d/%m/%y %H:%M" )
print(head(DH))

#no es propaga la condicio de variable temporal a copies
hist(DH, breaks="months")
summary(DH)

#cal declara-les sempre
DH<-as.POSIXct(DH, format="%d/%m/%y %H:%M")

hist(DH, breaks="months")
summary(DH)

#per descomposar la data
weekdays(DataHoraria)

diaSemana<-strftime(as.Date(trending_date, format="%y.%d.%m"), "%d")

#Alerta! Si tenim varies mesures hor?ries podem operar amb elles
#difftime<-time1-time2
#hist(unclass(difftime))
#summary(as.numeric(difftime))

