# variables.tf
variable "bucket_name" {
  description = "S3 bucket for storing generated images"
  type        = string
  default     = "pgr301-couch-explorers"
}

variable "candidate_prefix" {
  description = "Candidate prefix for S3 storage path"
  type        = string
  default     = "9"
}

variable "sqs_queue_name" {
  description = "Name of the SQS queue for image generation"
  type        = string
  default     = "image-generation-queue"
}
