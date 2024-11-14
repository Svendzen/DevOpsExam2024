# SQS-køen
resource "aws_sqs_queue" "image_generation_queue" {
  name                       = var.sqs_queue_name
  visibility_timeout_seconds = 60
}

# IAM-rolle
resource "aws_iam_role" "lambda_execution_role" {
  name = var.lambda_role_name # Bruker variabel for IAM-rollen
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Policyer for IAM-rollen
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Effect   = "Allow",
        Resource = aws_sqs_queue.image_generation_queue.arn
      },
      {
        Action = [
          "s3:PutObject"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::${var.bucket_name}/${var.candidate_prefix}/*"
      },
      {
        Action = [
          "bedrock:InvokeModel"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
      }
    ]
  })
}

# Oppretter en ZIP-fil av lambda_sqs.py for bruk i Lambda-funksjonen
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_sqs.py"
  output_path = "${path.module}/lambda_sqs.zip"
}


# Lambda-funksjonen
resource "aws_lambda_function" "image_processor_lambda" {
  filename         = data.archive_file.lambda_zip.output_path # peker på oppdatert ZIP-fil
  function_name    = var.lambda_function_name                 # Bruker variabel for Lambda-funksjonsnavnet
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.8"
  timeout          = 30                                               # Øker timeout til 30 sekunder
  memory_size      = 256                                              # Øker minne til 256 MB for bedre ytelse
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256 # Automatisk hash-basert oppdatering


  environment {
    variables = {
      BUCKET_NAME      = var.bucket_name # Bruker variabel for bucket-navnet
      CANDIDATE_PREFIX = var.candidate_prefix
    }
  }
}

# SQS-trigger for Lambda
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_generation_queue.arn
  function_name    = aws_lambda_function.image_processor_lambda.arn
  batch_size       = 10
  enabled          = true
}
