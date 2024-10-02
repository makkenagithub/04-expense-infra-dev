data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.env}/vpc_id"
}

