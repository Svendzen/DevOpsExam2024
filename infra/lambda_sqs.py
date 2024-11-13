import base64
import boto3
import json
import random
import os

# AWS-klienter for Bedrock og S3
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

# Modellen og bucket-informasjonen
MODEL_ID = "amazon.titan-image-generator-v1"
BUCKET_NAME = os.environ["BUCKET_NAME"]  # Samme bucket som SAM-applikasjonen
CANDIDATE_PREFIX = os.environ.get("CANDIDATE_PREFIX", "9")  # Legger til kandidatnummer

def lambda_handler(event, context):
    # Loop gjennom alle SQS-meldinger
    for record in event["Records"]:
        # Henter meldingsinnhold (prompt) fra SQS
        prompt = record["body"]
        seed = random.randint(0, 2147483647)
        
        # Setter riktig filsti for lagring i S3
        s3_image_path = f"{CANDIDATE_PREFIX}/generated_images/from_queue/titan_{seed}.png"
        
        # Konfigurasjon for bildegenerering
        native_request = {
            "taskType": "TEXT_IMAGE",
            "textToImageParams": {"text": prompt},
            "imageGenerationConfig": {
                "numberOfImages": 1,
                "quality": "standard",
                "cfgScale": 8.0,
                "height": 512,
                "width": 512,
                "seed": seed,
            },
        }

        # Kaller modellen for å generere bildet
        response = bedrock_client.invoke_model(
            modelId=MODEL_ID,
            body=json.dumps(native_request)
        )

        model_response = json.loads(response["body"].read())
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Lagrer bildet i S3-bucket med riktig filsti
        s3_client.put_object(Bucket=BUCKET_NAME, Key=s3_image_path, Body=image_data)

    return {
        "statusCode": 200,
        "body": json.dumps("Bildegenerering fullført. Vellykket lagring av generert bilde..")
    }
