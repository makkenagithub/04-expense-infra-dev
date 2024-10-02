locals {
    # fetch the vpc id from aws param store
    vpc_id = data.aws_ssm_parameter.vpc_id.value

}