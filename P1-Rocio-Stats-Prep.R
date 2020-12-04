### PROJECT 1 Covid19 - Statistics
# @authors: Ànnia, Rebecca, Rocío, Victor.


# READING DATA FROM EXCEL
library(readr);

ddCovid <- read_excel("originalData/owid-covid-data-131120.xlsx", col_names = TRUE, na="NA");
ddExtra <- read_excel("originalData/country-info-clean.xlsx",col_names = TRUE, na="NA");


# is R reading data correctly?
# Has dd the correct number of ROWS and COLUMNS?
dim(ddCovid)
dim(ddExtra)
n<-dim(ddCovid)[2]
n
K<-dim(ddExtra)[1]
K

# TIPO DE OBJETO DATOS
class(ddCovid)
class(ddExtra)

#check column contents
names(ddCovid)
View(ddCovid)

#open access by name to columns
attach(ddCovid)
attach(ddExtra)
?attach

#are all columns of expected types?

#summary(Dictamen)
#boxplot(Dictamen)
#class(dd[,1])
#class(Dictamen)
sapply(ddCovid, class)
sapply(ddExtra,class)


HospitalAdmisions <- as.numeric(weekly_hosp_admissions)

# R knows that Dictament is not numeric now
mean(HospitalAdmisions)

class(HospitalAdmisions)
table(HospitalAdmisions)
sapply(HospitalAdmisions,class)

# Crear una nueva columna
# actives<-c(2:14)
# dd2<-dd
# dd<-dd[,actives]

#consistency issues derived from "attach" function
class(HospitalAdmisions)
class(dd[,1])
summary(ddCovid$weekly_hosp_admissions)
summary(HospitalAdmisions)
summary(dd[,1])
barplot(table(Dictamen))
pie(table(Dictamen))

# interpolate data para llenar datos NA
# imputeTS library
# https://www.rdocumentation.org/packages/imputeTS/versions/3.1

#internal coertion. NOT ALWAYS
barplot(table(dd[,1]))

#INTERPRETABILITY, EXPLAINABILITY
#labelling modalities. Check metadata. 
#WARNING: Sequential assignment with levels

levels(Dictamen) <- c(NA, "positiu","negatiu")
table(Dictamen)

#care with missing data!!!!
table(Dictamen, useNA="ifany")

#What about ORDINAL VARIABLES?
barplot(table(Tipo.trabajo))

Tipo.trabajo<-factor(Tipo.trabajo, levels=c( "1", "2", "3", "4", "0"), labels=c("fixe","temporal","autonom","altres sit", "WorkingTypeUnknown"))
pie(table(Tipo.trabajo))
barplot(table(Tipo.trabajo))

#zoom the barplot to see all levels in the X axis

#ordering modalities! For ordinal variables 
Tipo.trabajo <- factor(Tipo.trabajo, ordered=TRUE,  levels= c("WorkingTypeUnknown","temporal","fixe","autonom","altres sit"))
frecs<-table(Tipo.trabajo)
barplot(frecs)

#recodificacions. Find short acronims of modalities for efficient data visualitation
print(frecs)
newvalues<-c("WTUnk","Fix","Temp","Auto","Other")
Tipo.trabajo <- newvalues[ match(Tipo.trabajo,
                                 c("WorkingTypeUnknown","fixe",                                             
                                   "temporal","autonom","altres sit"
                                 )
) 
]

table(Tipo.trabajo)
frecs<-table(Tipo.trabajo)
barplot(frecs, las=3, cex.names=0.7, main=paste("Barplot of", "Tipo.trabajo"))

#labelling of other factors in the dataset, be sure your assignment corresponds with the order of modalities
#if you doubt, use the match instruction shown above

levels(Vivienda) <- c("VivUnkown", "lloguer","escriptura","contr_privat","ignora_cont","pares","altres viv")
levels(Estado.civil) <- c("ECUnknown", "solter","casat","vidu","separat","divorciat")
levels(Registros) <- c("reg_no","reg_si")

#propagate preprocessing to dataframe
class(Dictamen)
class(dd[,1])
dd[,1]<-Dictamen
class(dd[,1])

dd[,3]<-Vivienda
dd[,6]<-Estado.civil
dd[,7]<-Registros
dd[,8]<-Tipo.trabajo

class(dd[,1])

#Export pre-processed data to persistent files, independent from statistical package
write.table(dd, file = "credscoCategoriques.csv", sep = ";", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)

K