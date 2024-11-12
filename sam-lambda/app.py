import base64
import boto3
import json
import random
import os

# Set up the AWS clients
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

# Retrieve environment variables (from template.yaml)
bucket_name = os.getenv("BUCKET_NAME")
candidate_prefix = os.getenv("CANDIDATE_PREFIX", "9")   # 9 is default if env variable is not available

def lambda_handler(event, context):
    # Extract prompt from the incoming event body
    try:
        body = json.loads(event["body"])
        prompt = body.get("prompt")
        
        # Check if 'prompt' is provided, return error message
        if not prompt:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": "Error: 'prompt' field is required in the request body."})
            }

    except (json.JSONDecodeError, KeyError):
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "Invalid request body. Ensure 'prompt' field is included."})
        }

    # Generate a unique seed and S3 path for the image
    seed = random.randint(0, 2147483647)
    s3_image_path = f"{candidate_prefix}/generated_images/titan_{seed}.png"

    # Configure the request for the Titan model
    native_request = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        }
    }

    # Invoke the model and handle response
    try:
        response = bedrock_client.invoke_model(modelId="amazon.titan-image-generator-v1", body=json.dumps(native_request))
        model_response = json.loads(response["body"].read())
        
        # Extract and decode the image data
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Upload the image to S3
        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)

        # Return the S3 path as response
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Image generated successfully", "s3_path": f"s3://{bucket_name}/{s3_image_path}"})
        }

    except Exception as e:
        # Handle errors
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Image generation failed", "error": str(e)})
        }
