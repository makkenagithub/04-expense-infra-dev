# we are cresting a ec2 in backend and connecting to it with private IP. 
# we are connecting to it using vpn here. 
# Initially we need to connect to open vpn and then run this terraform pan

module "backend_ec2" {

    # by default it uses the git hub source for open source modules
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name

  ami = data.aws_ami.suresh.id

  instance_type          = "t3.micro"
  #key_name               = "user1"
  #monitoring             = true


  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.backend_tags
    {
        Name = local.resource_name
    }
  )
}

# null resource does not create any resource, it is used to connect to ec2 through provisioners.
# terraform taint null_resource.backend
resource "null_resource" "backend" {
  # 
  # this null resource triggers as when the instance id of the ec2 is changes, that means
  # when a new backend ec2 is created then the null resource will be triggered.
  triggers = {
    instance_id = module.backend_ec2.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.backend_ec2.private_ip
    type = "ssh"
    user = "ec2_user"
    password = "DevOps321"
  }

  # The file provisioner copies files/scripts or directories from the machine running 
  # Terraform to the newly created resource.
  # Below block copies the backend.sh script file n local machine to the newly created ec2
  provisioner "file" {
    source      = "backend.sh"
    destination = "/tmp/backend.sh"
  }

    # backend.sh is executed in the newly created ec2.
  provisioner "remote-exec" {
    # backend.sh script is called 
    inline = [
        "chmod +x /tmp/backend.sh",
            # we can pass the arguments to scripts as well here as below
        "sudo sh /tmp/backend.sh backend ${var.env}"
    ]
  }


}

# below resource is depends on null_resource. It runs only after  null_resource runs.
resource "aws_ec2_instance_state" "backend_ec2" {
  instance_id = module.backend_ec2.id
  state       = "stopped"
  
  depends_on = [null_resource.backend]

}


# create AMI from existing ec2 insatnce
resource "aws_ami_from_instance" "backend" {
  name               = local.resource_name
  source_instance_id = module.backend_ec2.id

  depends_on = [aws_ec2_instance_state.backend_ec2]

}


resource "null_resource" "backend_ec2_delete" {

  triggers = {
    instance_id = module.backend_ec2.id
  }


  provisioner "local-exec" {
    # execute below aws cli command to terminate instance
    command = "aws ec2 terminate-instances --instance-ids ${modile.backend_ec2.id}"

  }

    depends_on = [aws_ami_from_instance.backend]

}