data "aws_ssm_parameter" "frontend_sg_id" {
    name = "/${var.project_name}/${var.env}/frontend_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.env}/public_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
    name  = "/${var.project_name}/${var.env}/vpc_id"
}

data "aws_ssm_parameter" "web_alb_listener_arn" {
    name  = "/${var.project_name}/${var.env}/web_alb_listener_arn"
}


data "aws_ami" "suresh" {
    most_recet = true
    owners = ["973714476881"]

    filter {
        name = "name"
        values = ["RHEL-9-DevOps*"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}