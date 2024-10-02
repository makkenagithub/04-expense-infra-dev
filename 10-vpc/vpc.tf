module "vpc" {
   # source = "../../03-terraform-aws-vps"

    # to give source from module prepared in GITHUB
    source = "git::https://github.com/makkenagithub/03-terraform-aws-vpc.git?ref=main"

    # pass the mandatory varable values. We can pass the values directly here or else keep in variables.
    # But its better to use variables.
    project_name = var.project_name
    environment = var.env
    common_tags = var.common_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_required = var.is_peering_required
    

}