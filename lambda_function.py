import json
import os
from urllib.parse import unquote_plus
import boto3

s3 = boto3.client("s3")
sns = boto3.client("sns")

SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

FILE_TYPES = {
    "pdf": "pdf-files",
    "docx": "docx-files",
    "doc": "doc-files",
    "jpeg": "jpeg-files",
    "jpg": "jpg-files",
    "png": "png-files",
    "csv": "csv-files",
    "xlsx": "xlsx-files",
    "zip": "zip-files",
}

def lambda_handler(event, context):
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        key = unquote_plus(record["s3"]["object"]["key"])
        filename = key.split("/")[-1]

        # Prevent reprocessing files already moved
        if key.startswith((
            "pdf-files/",
            "docx-files/",
            "doc-files/",
            "jpeg-files/",
            "jpg-files/",
            "png-files/",
            "csv-files/",
            "xlsx-files/",
            "zip-files/",
            "other/"
        )):
            continue

        # Get file extension
        if "." in filename:
            extension = filename.split(".")[-1].lower()
        else:
            extension = ""

        # Choose folder
        folder = FILE_TYPES.get(extension, "other")
        new_key = f"{folder}/{filename}"

        # Extra safety: do nothing if source and destination are the same
        if key == new_key:
            continue

        try:
            s3.copy_object(
                Bucket=bucket,
                CopySource={"Bucket": bucket, "Key": key},
                Key=new_key
            )

            s3.delete_object(Bucket=bucket, Key=key)

            sns.publish(
                TopicArn=SNS_TOPIC_ARN,
                Subject="Upload successful",
                Message=f"{filename} moved to {folder}/"
            )

        except Exception as e:
            sns.publish(
                TopicArn=SNS_TOPIC_ARN,
                Subject="Upload failed",
                Message=f"Error processing {filename}: {str(e)}"
            )
            raise e

    return {
        "statusCode": 200,
        "body": json.dumps("File processed successfully")
    }