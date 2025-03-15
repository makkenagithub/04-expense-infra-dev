locals {
    resource_name = "${var.project_name}-${var.env}-backend"
    # fetch the backend sg id from aws param store
    backend_sg_id = data.aws_ssm_parameter.backend_sg_id.value

        # conver string list to list and use first subnet ID
    private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids)[0]

    vpc_id = data.aws_ssm_parameter.vpc_id.value
}