import pandas as pd
import os
from email_cred import send_mail
from upload_to_s3 import upload_to_s3
import logging
import boto3
from botocore.exceptions import ClientError
from config import bucket, folder, region
import subprocess
import datetime

#Get UTC datetime and get previous days
yest = (pd.Timestamp.utcnow() + pd.DateOffset(-1)).date() #One day before UTC now
yest2 = (pd.Timestamp.utcnow() + pd.DateOffset(-2)).date() #Two days before UTC now
yest3 = (pd.Timestamp.utcnow() + pd.DateOffset(-3)).date() #Three days before UTC now

###Run R Script to create B-top10Data.csv with & without temp data###
subprocess.call(['Rscript', '1_preprocessing.R'])
preprocess = "B-top10Data.csv"
#temp = "B-top10DataTemperature.csv" Removing for now, too complicated

### Start upload to S3 Heroku console ###

#CSV with data up to yesterday
logging.info("Starting....")

try:
    dfyest = pd.read_csv(preprocess)
    dfyest['date'] = pd.to_datetime(dfyest['date'], format = '%Y-%m-%d')
    df1 = dfyest[dfyest['date'] <= pd.to_datetime(yest)]
    #Checking date is accurate
    maxdate1 = df1['date'].max() 
    print(maxdate1) 
    df1csv = df1.to_csv(index=False)
    logging.info("Starting upload of yesterday's CSV")
    upload_to_s3(body=df1csv, filename='preprocess/B_top10data_yest.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success - yesterday data updated', 'B_top10data_yest.csv has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong: %s' % str(e))

#CSV with data up to two days ago
try:
    dfyest2 = pd.read_csv(preprocess)
    dfyest2['date'] = pd.to_datetime(dfyest2['date'], format = '%Y-%m-%d')
    df2 = dfyest2[dfyest2['date'] <= pd.to_datetime(yest2)]
    #Checking date is accurate
    maxdate2 = df2['date'].max() 
    print(maxdate2)
    df2csv = df2.to_csv(index=False)
    logging.info("Starting upload of day before yesterday's CSV")
    upload_to_s3(body=df2csv, filename='preprocess/B_top10data_yest2.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success - yesterday2 data updated', 'B_top10data_yest2.csv has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong: %s' % str(e))

#CSV with data up to three days ago
try:
    dfyest3 = pd.read_csv(preprocess)
    dfyest3['date'] = pd.to_datetime(dfyest3['date'], format = '%Y-%m-%d')
    df3 = dfyest3[dfyest3['date'] <= pd.to_datetime(yest3)]
    #Checking date is accurate
    maxdate3 = df3['date'].max() 
    print(maxdate3)
    df3csv = df3.to_csv(index=False)
    logging.info("Starting upload of two days ago CSV")
    upload_to_s3(body=df3csv, filename='preprocess/B_top10data_yest3.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success - yesterday3 data updated', 'B_top10data_yest3.csv has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong: %s' % str(e))