folder="rawdata"

bucket="test-mvtec-2020-covid"
region="us-east-1"

# some logging config
import logging, sys
logging.basicConfig(stream=sys.stdout, level=logging.INFO)

if folder=="TEST":
    logging.warn("\n\nPlease set your `folder` variable in the config.py. Read the README for more information.\n\n")
