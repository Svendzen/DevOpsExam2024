# SQS-køen
resource "aws_sqs_queue" "image_generation_queue" {
  name                      = var.sqs_queue_name
  visibility_timeout_seconds = 60
}

# IAM-rolle
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
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
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_execution_role.id
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
      }
    ]
  })
}

# Lambda-funksjonen
resource "aws_lambda_function" "image_processor_lambda" {
  filename         = "lambda_sqs.zip"
  function_name    = "ImageProcessorLambda"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.8"

  environment {
    variables = {
      BUCKET_NAME = "arn:aws:s3:::${var.bucket_name}/${var.candidate_prefix}/*"
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
