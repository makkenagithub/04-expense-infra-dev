locals {
    resource_name = "${var.project_name}-${var.env}"
        # fetch the vpc id from aws param store
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_ids = data.aws_ssm_parameter.private_subnet_ids.value
    app_alb_sg_id = data.aws_ssm_parameter.app_alb_sg_id.value
}