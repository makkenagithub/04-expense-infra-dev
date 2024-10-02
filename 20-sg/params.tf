# store the required IDs/values in ssm param store
resource "aws_ssm_parameter" "mysql_sg_id" {

    #/expense/dev/mysql_sg_id
  name  = "/${var.project_name}/${var.env}/mysql_sg_id"
  type  = "String"
  value = module.mysql_sg.id
}

resource "aws_ssm_parameter" "backend_sg_id" {
    #/expense/dev/backend_sg_id
  name  = "/${var.project_name}/${var.env}/backend_sg_id"
  type  = "String"
  value = module.backend_sg.id
}

resource "aws_ssm_parameter" "frontend_sg_id" {
    #/expense/dev/frontend_sg_id
  name  = "/${var.project_name}/${var.env}/frontend_sg_id"
  type  = "String"
  value = module.frontend_sg.id
}

resource "aws_ssm_parameter" "bastion_sg_id" {
    #/expense/dev/bastion_sg_id
  name  = "/${var.project_name}/${var.env}/bastion_sg_id"
  type  = "String"
  value = module.bastion_sg.id
}

resource "aws_ssm_parameter" "ansible_sg_id" {
    #/expense/dev/ansible_sg_id
  name  = "/${var.project_name}/${var.env}/ansible_sg_id"
  type  = "String"
  value = module.ansible_sg.id
}

resource "aws_ssm_parameter" "app_alb_sg_id" {
    #/expense/dev/app_alb_sg_id
  name  = "/${var.project_name}/${var.env}/app_alb_sg_id"
  type  = "String"
  value = module.app_alb_sg.id
}

