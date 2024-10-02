data "aws_ssm_parameter" "mysql_sg_id" {
    name = "/${var.project_name}/${var.env}/mysql_sg_id"
}

data "aws_ssm_parameter" "database_subnet_group_name" {
    name = "/${var.project_name}/${var.env}/database_subnet_group_name"
}

