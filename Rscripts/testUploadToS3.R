#Testing upload to S3

library(aws.s3)

bkt <- 'mvtec-group2' #S3 bucket

df <- read.csv('B-top10Data.csv')

write.csv(dataOK, file="test.csv")

put_object("test.csv", object = "rawdata/test.csv", bucket = bkt, show_progress = TRUE)

