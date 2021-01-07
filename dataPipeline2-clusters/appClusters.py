import pandas as pd
import os
from email_cred import send_mail
from upload_to_s3 import upload_to_s3
import logging
import boto3
from botocore.exceptions import ClientError
from config import bucket, folder, region
import subprocess

#########################################
############ YESTERDAY3 DATA ############
#########################################

## Run R Script to get yest3 predictions ##
subprocess.call(['Rscript', '2_profilingClusters-yest3.R'])
cluster1yest3 = "C-top10Cluster1Pred-yest3.csv"
cluster2yest3 = "C-top10Cluster2Pred-yest3.csv"
cluster3yest3 = "C-top10Cluster3Pred-yest3.csv"
cluster4yest3 = "C-top10Cluster4Pred-yest3.csv"
cluster5yest3 = "C-top10Cluster5Pred-yest3.csv"

#Start upload to S3 Heroku console
logging.info("Starting upload of yest3 data....")

#Cluster 1 - yest3
try:
    df1yest3 = pd.read_csv(cluster1yest3)
    df1yest3csv = df1yest3.to_csv(index=False)
    logging.info("Starting upload of Cluster 1 yest3")
    upload_to_s3(body=df1yest3csv, filename='yest3/C-top10Cluster1Pred-yest3.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 1: Yest3 data', 'Something went wrong with Cluster 1: %s' % str(e))


# #Cluster 2 - yest3
try:
    df2yest3 = pd.read_csv(cluster2yest3)
    df2yest3csv = df2yest3.to_csv(index=False)
    logging.info("Starting upload of Cluster 2 yest3")
    upload_to_s3(body=df2yest3csv, filename='yest3/C-top10Cluster2Pred-yest3.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 2: Yest3 data', 'Something went wrong with Cluster 2: %s' % str(e))

# #Cluster 3 - yest3
try:
    df3yest3 = pd.read_csv(cluster3yest3)
    df3yest3csv = df3yest3.to_csv(index=False)
    logging.info("Starting upload of Cluster 3 yest3")
    upload_to_s3(body=df3yest3csv, filename='yest3/C-top10Cluster3Pred-yest3.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 3: Yest3 data', 'Something went wrong with Cluster 3: %s' % str(e))

# #Cluster 4 - yest3
try:
    df4yest3 = pd.read_csv(cluster4yest3)
    df4yest3csv = df4yest3.to_csv(index=False)
    logging.info("Starting upload of Cluster 4 yest3")
    upload_to_s3(body=df4yest3csv, filename='yest3/C-top10Cluster4Pred-yest3.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 4: Yest3 data', 'Something went wrong with Cluster 4: %s' % str(e))

# #Cluster 5 - yest3
try:
    df5yest3 = pd.read_csv(cluster5yest3)
    df5yest3csv = df5yest3.to_csv(index=False)
    logging.info("Starting upload of Cluster 5 yest3")
    upload_to_s3(body=df5yest3csv, filename='yest3/C-top10Cluster5Pred-yest3.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 5: Yest3 data', 'Something went wrong with Cluster 5: %s' % str(e))


#########################################
############ YESTERDAY2 DATA ############
#########################################

## Run R Script to get yest2 predictions ##
subprocess.call(['Rscript', '2_profilingClusters-yest2.R'])
cluster1yest2 = "C-top10Cluster1Pred-yest2.csv"
cluster2yest2 = "C-top10Cluster2Pred-yest2.csv"
cluster3yest2 = "C-top10Cluster3Pred-yest2.csv"
cluster4yest2 = "C-top10Cluster4Pred-yest2.csv"
cluster5yest2 = "C-top10Cluster5Pred-yest2.csv"

#Start upload to S3 Heroku console
logging.info("Starting upload of yest2 data....")

#Cluster 1 - yest2
try:
    df1yest2 = pd.read_csv(cluster1yest2)
    df1yest2csv = df1yest2.to_csv(index=False)
    logging.info("Starting upload of Cluster 1 yest2")
    upload_to_s3(body=df1yest2csv, filename='yest2/C-top10Cluster1Pred-yest2.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 1: Yest2 data', 'Something went wrong with Cluster 1: %s' % str(e))

#Cluster 2 - yest2
try:
    df2yest2 = pd.read_csv(cluster2yest2)
    df2yest2csv = df2yest2.to_csv(index=False)
    logging.info("Starting upload of Cluster 2 yest2")
    upload_to_s3(body=df2yest2csv, filename='yest2/C-top10Cluster2Pred-yest2.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 2: Yest2 data', 'Something went wrong with Cluster 2: %s' % str(e))

#Cluster 3 - yest2
try:
    df3yest2 = pd.read_csv(cluster3yest2)
    df3yest2csv = df3yest2.to_csv(index=False)
    logging.info("Starting upload of Cluster 3 yest2")
    upload_to_s3(body=df3yest2csv, filename='yest2/C-top10Cluster3Pred-yest2.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 3: Yest2 data', 'Something went wrong with Cluster 3: %s' % str(e))

#Cluster 4 - yest2
try:
    df4yest2 = pd.read_csv(cluster4yest2)
    df4yest2csv = df4yest2.to_csv(index=False)
    logging.info("Starting upload of Cluster 4 yest2")
    upload_to_s3(body=df4yest2csv, filename='yest2/C-top10Cluster4Pred-yest2.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 4: Yest2 data', 'Something went wrong with Cluster 4: %s' % str(e))

#Cluster 5 - yest2
try:
    df5yest2 = pd.read_csv(cluster5yest2)
    df5yest2csv = df5yest2.to_csv(index=False)
    logging.info("Starting upload of Cluster 5 yest2")
    upload_to_s3(body=df5yest2csv, filename='yest2/C-top10Cluster5Pred-yest2.csv')
    logging.info("Success!")

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error with Cluster 5: Yest2 data', 'Something went wrong with Cluster 5: %s' % str(e))

#########################################
############ JOINED DATA ################
#########################################

# ## Run R Script for joined data ##
subprocess.call(['Rscript', '2_profilingCluster_yest.R'])
cluster1join = "C-top10Cluster1Pred-joined.csv"
cluster2join = "C-top10Cluster2Pred-joined.csv"
cluster3join = "C-top10Cluster3Pred-joined.csv"
cluster4join = "C-top10Cluster4Pred-joined.csv"
cluster5join = "C-top10Cluster5Pred-joined.csv"

#Start upload to S3 Heroku console
logging.info("Starting upload of joined data....")

#Cluster 1 - Joined
try:
    df1join = pd.read_csv(cluster1join)
    df1joincsv = df1join.to_csv(index=False)
    logging.info("Starting upload of Cluster 1 joined")
    upload_to_s3(body=df1joincsv, filename='joined/C-top10Cluster1Pred-joined.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success: Cluster 1 joined uploaded', 'Uploaded.')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 1: %s' % str(e))

#Cluster 2 - Joined
try:
    df2join = pd.read_csv(cluster2join)
    df2joincsv = df2join.to_csv(index=False)
    logging.info("Starting upload of Cluster 2 joined")
    upload_to_s3(body=df2joincsv, filename='joined/C-top10Cluster2Pred-joined.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success: Cluster 2 joined uploaded', 'Uploaded.')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 2: %s' % str(e))

#Cluster 3 - Joined
try:
    df3join = pd.read_csv(cluster3join)
    df3joincsv = df3join.to_csv(index=False)
    logging.info("Starting upload of Cluster 3 joined")
    upload_to_s3(body=df3joincsv, filename='joined/C-top10Cluster3Pred-joined.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success: Cluster 3 joined uploaded', 'Uploaded.')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 3: %s' % str(e))

#Cluster 4 - Joined
try:
    df4join = pd.read_csv(cluster4join)
    df4joincsv = df4join.to_csv(index=False)
    logging.info("Starting upload of Cluster 4 joined")
    upload_to_s3(body=df4joincsv, filename='joined/C-top10Cluster4Pred-joined.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success: Cluster 4 joined uploaded', 'Uploaded.')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 4: %s' % str(e))

#Cluster 5 - Joined
try:
    df5join = pd.read_csv(cluster5join)
    df5joincsv = df5join.to_csv(index=False)
    logging.info("Starting upload of Cluster 5 joined")
    upload_to_s3(body=df5joincsv, filename='joined/C-top10Cluster5Pred-joined.csv')
    logging.info("Success!")
    send_mail('mvtec2020covid@gmail.com','Success: Cluster 5 joined uploaded', 'Uploaded.')

except Exception as e:
    send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong with Cluster 5: %s' % str(e))
