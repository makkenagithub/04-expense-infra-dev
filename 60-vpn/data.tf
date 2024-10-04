data "aws_ssm_parameter" "bastion_sg_id" {
    name = "/${var.project_name}/${var.env}/bastion_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.env}/public_subnet_ids"
}

data "aws_ami" "suresh" {
    most_recet = true
    owners = ["973714476881"]

    filter {
        name = "name"
        values = ["OpenVPN Access Server Community Image-fe8020db*"]
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