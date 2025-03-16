locals {
    resource_name = "${var.project_name}-${var.env}-frontend"
    # fetch the frontend sg id from aws param store
    frontend_sg_id = data.aws_ssm_parameter.frontend_sg_id.value

        # conver string list to list and use first subnet ID
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids)[0]

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    web_alb_listener_arn = data.web_alb_listener_arn.value

}