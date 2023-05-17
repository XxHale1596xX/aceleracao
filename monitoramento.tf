resource "aws_cloudwatch_log_group" "grafana_log_group" {
  name = "/grafana/eks-cluster"
}

resource "aws_cloudwatch_log_stream" "grafana_log_stream" {
  name           = "eks-cluster"
  log_group_name = aws_cloudwatch_log_group.grafana_log_group.name
}

resource "aws_cloudwatch_log_resource_policy" "grafana_log_policy" {
  policy_name = "grafana-log-policy"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
        Resource = aws_cloudwatch_log_stream.grafana_log_stream.arn
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "eks_cluster_cpu_utilization" {
  alarm_name          = "eks-cluster-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric checks the CPU utilization of the RDS instance."
  alarm_actions       = ["arn:aws:sns:us-west-2:123456789012:my-sns-topic"]
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.rds_instance.id
  }
}
