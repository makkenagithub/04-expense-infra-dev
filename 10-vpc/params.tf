# store the vpc id to smm parameter store
# one  param store exists across AWS account
resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.env}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.env}/public_subnet_ids"
  type  = "StringList"
  # join function is to conver list to list of strings - string1, string2 etc
  value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.env}/private_subnet_ids"
  type  = "StringList"
  # join function is to conver list to list of strings - string1, string2 etc
  value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project_name}/${var.env}/database_subnet_ids"
  type  = "StringList"
  # join function is to conver list to list of strings - string1, string2 etc
  value = join(",", module.vpc.database_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_group_name" {
  name  = "/${var.project_name}/${var.env}/database_subnet_group_name"
  type  = "String"
  # join function is to conver list to list of strings - string1, string2 etc
  value = module.vpc.database_subnet_group_name
}
