# Eksponerer ARN-en til CloudWatch-alarmen, slik at den kan brukes eller refereres andre steder.
output "sqs_age_alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.sqs_age_alarm.arn
  description = "ARN for SQS ApproximateAgeOfOldestMessage CloudWatch alarm"
}
