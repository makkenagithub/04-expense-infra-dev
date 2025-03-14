
# store the arn of the aws listener
resource "aws_ssm_parameter" "app_alb_listener_arn" {

  name  = "/${var.project_name}/${var.env}/app_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
}