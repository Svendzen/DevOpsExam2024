# CloudWatch-alarm som overvåker alderen til den eldste meldingen i SQS-køen
resource "aws_cloudwatch_metric_alarm" "sqs_age_alarm" {
  alarm_name          = "SQSApproximateAgeOfOldestMessageAlarm-9"
  comparison_operator = "GreaterThanThreshold"     # Alarmen trigges når verdien overstiger terskelen (GreaterThanThreshold)
  evaluation_periods  = 1                          # Antall evalueringsperioder (1 minutt per periode) før alarmen trigges
  threshold           = var.age_threshold          # Terskelverdi for aldersgrensen, definert via en variabel
  metric_name         = "ApproximateAgeOfOldestMessage"   # Navn på metrikken som overvåkes i SQS
  namespace           = "AWS/SQS"     # Namespace for SQS-metrikker
  statistic           = "Maximum"     # Bruk maksimumsverdien i hver evalueringsperiode for å fange opp topper
  period              = 60            # Evalueringsperiodens lengde i sekunder.
  alarm_description   = "Alarm trigges når den eldste meldingen i køen overstiger terskelverdien"

  dimensions = {
    # Dimensjoner spesifiserer hvilken kø som overvåkes. 
    QueueName = "image-generation-queue-9"  # Navnet på SQS-kø som skal overvåkes - kan også settes dynamisk med parameter
  }
    # Når alarmen trigges, sendes et varsel til SNS-emnet nedenfor
  alarm_actions = [aws_sns_topic.sqs_age_alarm_topic.arn] 
}
# Oppretter et SNS-emne som alarmen bruker til å sende varsler
resource "aws_sns_topic" "sqs_age_alarm_topic" {
  name = "sqs-age-alarm-topic-9"
}

# Legger til en e-postadresse som abonnent til SNS-emnet for å motta varsler
resource "aws_sns_topic_subscription" "sqs_age_alarm_email" {
  topic_arn = aws_sns_topic.sqs_age_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
