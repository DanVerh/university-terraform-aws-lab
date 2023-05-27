resource "aws_sns_topic" "alarms" {
  name = "${var.naming}-alarms"
}

resource "aws_sns_topic_subscription" "alarms" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.email
}
