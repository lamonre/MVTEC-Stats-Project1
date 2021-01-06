import pandas as pd
import os
from email_cred import send_mail
from upload_to_s3 import upload_to_s3
import logging
import boto3
from botocore.exceptions import ClientError
from config import bucket, folder, region
import subprocess

### Uncomment 3 lines below to load creds if uploading locally ###
# from dotenv import load_dotenv
# load_dotenv()
# IS_DEV = os.getenv('IS_DEV')

#Run R Script to create B-top10Data.csv
subprocess.call(['Rscript', '1_preprocessing.R'])
preprocess = "B-top10Data.csv"

#Start upload to S3 Heroku console
logging.info("Starting....")

try:
    df = pd.read_csv(preprocess)
    df2csv = df.to_csv(index=False)
    logging.info("starting upload")
    upload_to_s3(body=df2csv, filename='B_top10data.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success', 'B_covidDaily.csv has been updated')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong: %s' % str(e))