# I outputs.tf ser man ressursene

output "lambda_function_arn" {
  value = aws_lambda_function.image_processor_lambda.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.image_generation_queue.id
}
