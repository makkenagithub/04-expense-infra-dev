# copied the code from open source module
# https://github.com/terraform-aws-modules/terraform-aws-ec2-instance

# by default it uses the git hub source for open source modules

module "bastion_ec2" {

    # by default it uses the git hub source for open source modules
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name

  ami = data.aws_ami.suresh.id

  instance_type          = "t3.micro"
  #key_name               = "user1"
  #monitoring             = true


  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.baston_tags
    {
        Name = local.resource_name
    }
  )
}