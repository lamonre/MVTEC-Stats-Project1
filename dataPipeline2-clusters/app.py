import pandas as pd
import os
from email_cred import send_mail
from upload_to_s3 import upload_to_s3
import logging
import boto3
from botocore.exceptions import ClientError
from config import bucket, folder, region
import subprocess

#Run R Script to create B-top10Data.csv
subprocess.call(['Rscript', '2_profilingClusters.R'])
cluster1 = "C-top10Cluster1Pred.csv"
cluster2 = "C-top10Cluster2Pred.csv"
cluster3 = "C-top10Cluster3Pred.csv"
cluster4 = "C-top10Cluster4Pred.csv"
cluster5 = "C-top10Cluster5Pred.csv"

#Start upload to S3 Heroku console
logging.info("Starting....")

#Cluster 1
try:
    df1 = pd.read_csv(cluster1)
    df1csv = df1.to_csv(index=False)
    logging.info("Starting upload of Cluster 1")
    upload_to_s3(body=df1csv, filename='C-top10Cluster1Pred.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success', 'Cluster 1 has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 1: %s' % str(e))


#Cluster 2
try:
    df2 = pd.read_csv(cluster2)
    df2csv = df2.to_csv(index=False)
    logging.info("Starting upload of Cluster 2")
    upload_to_s3(body=df2csv, filename='C-top10Cluster2Pred.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success', 'Cluster 2 has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 2: %s' % str(e))

#Cluster 3
try:
    df3 = pd.read_csv(cluster3)
    df3csv = df3.to_csv(index=False)
    logging.info("Starting upload of Cluster 3")
    upload_to_s3(body=df3csv, filename='C-top10Cluster3Pred.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success', 'Cluster 3 has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 3: %s' % str(e))

#Cluster 4
try:
    df4 = pd.read_csv(cluster4)
    df4csv = df4.to_csv(index=False)
    logging.info("Starting upload of Cluster 4")
    upload_to_s3(body=df4csv, filename='C-top10Cluster4Pred.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success', 'Cluster 4 has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 4: %s' % str(e))

#Cluster 5
try:
    df5 = pd.read_csv(cluster5)
    df5csv = df5.to_csv(index=False)
    logging.info("Starting upload of Cluster 5")
    upload_to_s3(body=df5csv, filename='C-top10Cluster5Pred.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success', 'Cluster 5 has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 5: %s' % str(e))


