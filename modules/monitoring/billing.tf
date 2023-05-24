resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name          = "billing_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600"
  statistic           = "Maximum"
  threshold           = "10.0"
  alarm_description   = "Billing Alarm fired"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {}
}

