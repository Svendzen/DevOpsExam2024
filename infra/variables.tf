# Navn på SQS køen som brukes for bildegenerering
variable "sqs_queue_name" {
  type        = string
  default     = "image-generation-queue-9"
  description = "Navn på SQS køen for bildegenerering"
}

# Navn på IAM rollen som brukes av Lambda-funksjonen
variable "lambda_role_name" {
  type        = string
  default     = "lambda_execution_role_9"
  description = "IAM rolle for Lambda funksjonen"
}

# Navn på Lambda-funksjonen for prosessering av bilder
variable "lambda_function_name" {
  type        = string
  default     = "Lambda_Image_Processor_9"
  description = "Navn på Lambda-funksjonen for bildegenerering"
}

# Navn på S3 bucket som brukes for lagring av bilder
variable "bucket_name" {
  type        = string
  default     = "pgr301-couch-explorers"
  description = "S3 bucket for lagring av genererte bilder"
}

# Prefiks som representerer kandidatnummer
variable "candidate_prefix" {
  type        = string
  default     = "9"
  description = "Er det samme som kandidat nummer"
}

# E-postadresse for varsler, settes i tf.vars-filen
variable "alert_email" {
  type        = string
  description = "E-postadresse for å motta alarmer."
}

# Variabel for aldergrensen (i sekunder) for den eldste meldingen i køen før alarmen trigges.
variable "age_threshold" {
  description = "Aldersgrensen for ApproximateAgeOfOldestMessage i sekunder."
  type        = number
  default     = 30           # Eksempelterskel, kan justeres
}