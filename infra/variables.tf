variable "sqs_queue_name" {
  type        = string
  default     = "image-generation-queue-9"
  description = "Navn på SQS køen for bildegenerering"
}

variable "lambda_role_name" {
  type        = string
  default     = "lambda_execution_role_9"
  description = "IAM rolle for Lambda funksjonen"
}

variable "lambda_function_name" {
  type        = string
  default     = "Lambda_Image_Processor_9"
  description = "Navn på Lambda-funksjonen for bildegenerering"
}

variable "bucket_name" {
  type        = string
  default     = "pgr301-couch-explorers"
  description = "S3 bucket for lagring av genererte bilder"
}

variable "candidate_prefix" {
  type        = string
  default     = "9"
  description = "Samme som kandidat nummer"
}
