locals {
    resource_name = "${var.project_name}-${var.env}-bastion"
    # fetch the bastion sg id from aws param store
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value

        # conver string list to list and use first subnet ID
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids)[0]
}