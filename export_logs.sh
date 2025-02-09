#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Purpose:
# This script downloads CloudTrail logs and CloudTrail digest logs from an S3 bucket across all AWS regions into a local directory. 
# It ensures logs from each region are synced to corresponding directories for further processing.

# Get the list of AWS regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text --profile Log --region eu-north-1)

# S3 Bucket Details
BUCKET_NAME="huge-logistic-aws-cloudtrail-logs-640783789316-ebcbfc9f"  # The source S3 bucket containing CloudTrail logs
ACCOUNT_ID="640783789316"  # The AWS account ID associated with the logs

# Download logs for each region to the current directory
for region in $regions; do
    echo "Downloading CloudTrail logs for region: $region"  # Notify the region being processed

    # Sync CloudTrail logs from the S3 bucket to a local directory for the specific region
    aws s3 sync s3://$BUCKET_NAME/AWSLogs/$ACCOUNT_ID/CloudTrail/$region/ ./CloudTrail/$region/ --region $region --profile Log
    
    # Sync CloudTrail digest logs from the S3 bucket to a local directory for the specific region
    aws s3 sync s3://$BUCKET_NAME/AWSLogs/$ACCOUNT_ID/CloudTrail-Digest/$region/ ./CloudTrail-Digest/$region/ --region $region --profile Log
done

# Notify the user of successful download and the destination directory
echo "All logs downloaded to: $(pwd)/CloudTrail/"
