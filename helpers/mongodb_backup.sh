#!/bin/bash

# MongoDB server connection details
HOST="10.0.10.10"
PORT="27017"
DB="items_db"


# S3 details
BUCKET="top-secret-and-defintely-not-public-S3-bucket"
FOLDER="backups"

# Get current date and time
BACKUP_NAME=`date +%Y_%m_%d_%H_%M_%S`

# MongoDB Backup
echo "Creating backup of MongoDB"
mongodump --host $HOST --port $PORT --db $DB --out /backup/$BACKUP_NAME

# Check if mongodump was successful
if [ $? -eq 0 ]; then
   echo "MongoDB Backup successful!"
else
   echo "MongoDB Backup failed!"
   exit 1
fi

# Create tar of Backup
tar -zcvf /backup/$BACKUP_NAME.tgz /backup/$BACKUP_NAME

# Check if tar was successful
if [ $? -eq 0 ]; then
   echo "Successfully created tar of backup!"
else
   echo "Failed to create tar of backup!"
   exit 1
fi

# Upload to S3
echo "Uploading backup to S3"
aws s3 cp /backup/$BACKUP_NAME.tgz s3://$BUCKET/$FOLDER/$BACKUP_NAME.tgz

# Check if S3 upload was successful
if [ $? -eq 0 ]; then
   echo "Upload to S3 successful!"
else
   echo "Upload to S3 failed!"
   exit 1
fi

# If everything was successful, remove local backup files
rm -rf /backup/$BACKUP_NAME
rm /backup/$BACKUP_NAME.tgz

echo "Backup procedure completed successfully!"