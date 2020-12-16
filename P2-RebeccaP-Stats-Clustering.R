#Clustering script begin

data = read.csv(file = "data_output/rvpazos_preprocessed.csv")
names(data)
dim(data)
summary(data)

#attach(data) didn't work for me

library(cluster)

actives<-c(2:16)
