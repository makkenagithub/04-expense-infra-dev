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
##
# null resource does not create any resource, it is used to connect to ec2 through provisioners.
# terraform taint null_resource.backend
# if we want the terraform to run the below resource forcebly, then we need to give above command and then try the 
# terraform plan command
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


# delete the ec2 insatnce. When we try to google, it shows only terraform destroy command to terminate/delete ec2
# we can use below option to delete ec2 by executing aws command in local-exec
resource "null_resource" "backend_ec2_delete" {

  triggers = {
    instance_id = module.backend_ec2.id
  }


  provisioner "local-exec" {
    # execute below aws cli command to terminate instance
    command = "aws ec2 terminate-instances --instance-ids ${module.backend_ec2.id}"

  }

    depends_on = [aws_ami_from_instance.backend]

}


# create lb target group for backend
resource "aws_lb_target_group" "backend_tg" {
  name     = local.resource_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  # backend app teams usually provide a url, if that is working fine then backend app health is good. 
  # we are giving that url here in health_check block
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"  #backend app team gives this.
    port = 8080
    protocol = "HTTP"
    timeout = 6
    
  }

}


# create launch templete - here we give ami id, security group id
resource "aws_launch_template" "backend_template" {
  
  name = local.resource_name

  # give the ami ID generated in the resource "aws_ami_from_instance" "backend" {
  image_id = aws_ami_from_instance.backend.id

  # when auto scaling showndowns the instance, we can choose the below option as terminate instance or stop the instance
  instance_initiated_shutdown_behavior = "terminate"  
  instance_type = "t2.micro"
  # subnet_id = local.private_subnet_id   #subnet_id filed does not exist in launch template
  vpc_security_group_ids = local.backend_sg_id

  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.resource_name
    }
  }

}


# Auto scaling group (ASG)) - here we give lb target group arn, launch template id, subnet ids
resource "aws_autoscaling_group" "backend_autoscale" {
  
  name = local.resource_name
  desired_capacity   = 2
  max_size           = 10
  min_size           = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"

  target_group_arns = [aws_lb_target_group.backend_tg.arn]

  #vpc zone identifier is the filed where we give the subnet IDs
  vpc_zone_identifier       = [local.private_subnet_id]

  launch_template {
    id      = aws_launch_template.backend_template.id
    version = "$Latest"
  }

  # Rolling update. Min health percentage is given as 50 means, out of all the instances atleast 50% of instances should be healthy
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    # This rolling update triggers when launch_template is changed
    triggers = ["launch_template"]
  }

  # timeout: If the instance is not healthy with in 15 minutes, then ASG will delete that instance
  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = local.resource_name
    propagate_at_launch = true
  }


}

# we need to create auto scaling policy
resource "aws_autoscaling_policy" "backend" {

  name = local.resource_name

  # policy_type - (Optional) Policy type, either "SimpleScaling", "StepScaling", 
  #"TargetTrackingScaling", or "PredictiveScaling". If this value isn't provided, AWS will default to "SimpleScaling."
  
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }

  autoscaling_group_name = aws_autoscaling_group.backend_autoscale.name

}

# alb listener rule - here we give lb listener arn, lb target group arn
# we can write multiple rules for a listener. A rule with low priority value is evaluated first
resource "aws_lb_listener_rule" "backend" {
  listener_arn = local.app_alb_listener_arn
  priority     = 100    #low priority value rule will be evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  # host based routing
  condition {
    host_header {
      values = ["backend.app-<domain name>"]  # eg: backend.app.daws81s.online
    }
  }

}
