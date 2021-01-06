import logging
import boto3
from botocore.exceptions import ClientError
from config import bucket, folder, region
import os

### Uncomment 2 lines below to load creds if uploading locally ###
from dotenv import load_dotenv
load_dotenv()

def upload_to_s3(body, filename):
    boto_kwargs = {
    "aws_access_key_id": os.getenv("AWS_ACCESS_KEY_ID"),
    "aws_secret_access_key": os.getenv("AWS_SECRET_ACCESS_KEY")
    }
    s3_client = boto3.Session(**boto_kwargs).client("s3")
    try:
        target = "%s/%s" % (folder, filename)
        s3_client.put_object(Body=body, Bucket=bucket, Key=target, ACL='public-read', ContentType='text/csv')
        logging.info("Uploaded: https://%s.s3-%s.amazonaws.com/%s" % (bucket, region, target))
    except ClientError as e:
        logging.error(e)
        return False
    return True