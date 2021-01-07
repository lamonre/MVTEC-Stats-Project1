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
subprocess.call(['Rscript', '1_preprocessing.R'])
preprocess = "B-top10Data.csv"
temp = "B-top10DataTemperature.csv"

#Start upload to S3 Heroku console
#CSV without temp data
logging.info("Starting....")

try:
    df = pd.read_csv(preprocess)
    df2csv = df.to_csv(index=False)
    logging.info("Starting upload of CSV without temp data")
    upload_to_s3(body=df2csv, filename='B_top10data.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success', 'B_top10data.csv has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong: %s' % str(e))

#CSV with Temperature data

try:
    dftemp = pd.read_csv(temp)
    dftempcsv = df.to_csv(index=False)
    logging.info("Starting upload of CSV with temp data")
    upload_to_s3(body=dftempcsv, filename='B-top10DataTemperature.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success: CSV with temp data uploaded', 'B-top10DataTemperature.csv has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error uploading CSV with temp data', 'Something went wrong: %s' % str(e))