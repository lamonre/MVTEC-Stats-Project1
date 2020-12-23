import pandas as pd
from dotenv import load_dotenv
import os
from email_cred import send_mail
from upload_to_s3 import upload_to_s3
import logging
import boto3
from botocore.exceptions import ClientError
from config import bucket, folder, region
from io import BytesIO

#load local environment variables
load_dotenv()
IS_DEV = os.getenv('IS_DEV')

#for Heroku console
logging.info("Starting....")

url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
columns = ['continent', 'location', 'date', 'total_cases', 'total_cases_per_million', 'new_cases_smoothed', 'total_deaths', 'total_deaths_per_million', 'new_deaths_smoothed']
countries = ["Belgium", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "France", "Germany", "Iceland", "Ireland", "Latvia", "Lithuania", "Malta", "Netherlands", "Norway", "Portugal", "Romania", "Slovenia", "Spain", "United Kingdom", "United States"]

try:
    c = pd.read_csv(url, usecols = columns, parse_dates = ['date'])
    df = c[c['location'].isin(countries)]
    # df['year'] = df['date'].dt.year
    # df['week'] = df['date'].dt.week
    # csv_buffer = BytesIO()
    df2csv = df.to_csv(index=False)
    logging.info("starting upload")
    upload_to_s3(body=df2csv, filename='B_covidDaily.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong: %s' % str(e))