
# store the arn of aws cert manager
resource "aws_ssm_parameter" "https_cert_arn" {

  name  = "/${var.project_name}/${var.env}/https_cert_arn"
  type  = "String"
  value = aws_acm_certificate.expense.arn

}