locals {
    resource_name = "${var.project_name}-${var.env}-vpn"
    # fetch the vpn sg id from aws param store
    vpn_sg_id = data.aws_ssm_parameter.vpn_sg_id.value

        # conver string list to list and use first subnet ID
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids)[0]
}