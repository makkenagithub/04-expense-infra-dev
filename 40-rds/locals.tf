locals {
    resource_name = "${var.project_name}-${var.env}"
    # fetch the bastion sg id from aws param store
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
    database_subnet_group_name = data.aws_ssm_parameter.database_subnet_group_name.value

}