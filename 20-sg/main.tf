module "mysql_sg" {
    # source = "../../03-terraform-sg-module"
    # to give source from module prepared in GITHUB
    source = "git::https://github.com/makkenagithub/03-terraform-sg-module.git?ref=main"

    project_name = var.project_name
    env = var.env
    sg_name = "mysql"
    vpc_id  = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.mysql_sg_tags
}

module "backend_sg" {
    #source = "../../03-terraform-sg-module"
    # to give source from module prepared in GITHUB
    source = "git::https://github.com/makkenagithub/03-terraform-sg-module.git?ref=main"

    project_name = var.project_name
    env = var.env
    sg_name = "backend"
    vpc_id  = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.backend_sg_tags
}

module "frontend_sg" {
    #source = "../../03-terraform-sg-module"
    # to give source from module prepared in GITHUB
    source = "git::https://github.com/makkenagithub/03-terraform-sg-module.git?ref=main"

    project_name = var.project_name
    env = var.env
    sg_name = "frontend"
    vpc_id  = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.frontend_sg_tags
}

module "bastion_sg" {
    #source = "../../03-terraform-sg-module"
    # to give source from module prepared in GITHUB
    source = "git::https://github.com/makkenagithub/03-terraform-sg-module.git?ref=main"

    project_name = var.project_name
    env = var.env
    sg_name = "bastion"
    vpc_id  = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.bastion_sg_tags
}

module "ansible_sg" {
    #source = "../../03-terraform-sg-module"
    # to give source from module prepared in GITHUB
    source = "git::https://github.com/makkenagithub/03-terraform-sg-module.git?ref=main"

    project_name = var.project_name
    env = var.env
    sg_name = "ansible"
    vpc_id  = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.ansible_sg_tags
}

module "app_alb_sg" {
    #source = "../../03-terraform-sg-module"
    # to give source from module prepared in GITHUB
    source = "git::https://github.com/makkenagithub/03-terraform-sg-module.git?ref=main"

    project_name = var.project_name
    env = var.env
    sg_name = "app-alb"  # expense-dev-app-alb
    vpc_id  = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.app_alb_sg_tags
}

module "vpn_sg" {
    #source = "../../03-terraform-sg-module"
    # to give source from module prepared in GITHUB
    source = "git::https://github.com/makkenagithub/03-terraform-sg-module.git?ref=main"

    project_name = var.project_name
    env = var.env
    sg_name = "vpn"  # expense-dev-app-alb
    vpc_id  = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.vpn_sg_tags
}

# mysql allowing connection on 3306 from instances attched to backed sg
resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.backend_sg.id
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.mysql_sg.id
}


# # backend allowing connection on 8080 from instances attched to frontend sg
# resource "aws_security_group_rule" "backend_frontend" {
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   # accept connections from this source
#   source_security_group_id = module.frontend_sg.id
#   #cidr_blocks       = [aws_vpc.example.cidr_block]
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
#   # security group to apply this rule to
#   security_group_id = module.backend_sg.id
# }

# # frontend allowing connection on 80 from public
# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   # accept connections from this source
#   #source_security_group_id = module.frontend_sg.id

#   cidr_blocks       = ["0.0.0.0/0"]
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
#   # security group to apply this rule to
#   security_group_id = module.frontend_sg.id
# }

# mysql (RDS) allowing connection on 3306 from bastion
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306  #22
  to_port           = 3306  #22
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.bastion_sg.id

  #cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.mysql_sg.id
}

# backend allowing connection on 22 from bastion
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.bastion_sg.id

  #cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.backend_sg.id
}

# frontend allowing connection on 22 from bastion
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.bastion_sg.id

  #cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.frontend_sg.id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # accept connections from this source
  #source_security_group_id = module.ansible_sg.id

  cidr_blocks       = ["0.0.0.0/0"]   # usually we give our company IP here
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.bastion_sg.id
}


# # mysql allowing connection on 22 from ansible
# resource "aws_security_group_rule" "mysql_ansible" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   # accept connections from this source
#   source_security_group_id = module.ansible_sg.id

#   #cidr_blocks       = ["0.0.0.0/0"]
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
#   # security group to apply this rule to
#   security_group_id = module.mysql_sg.id
# }

# backend allowing connection on 22 from ansible
resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.ansible_sg.id

  #cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.backend_sg.id
}

# frontend allowing connection on 22 from ansible
resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.ansible_sg.id

  #cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.frontend_sg.id
}


resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # accept connections from this source
  #source_security_group_id = module.ansible_sg.id

  cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.ansible_sg.id
}

# backend is accepting connections from app alb
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.app_alb_sg.id

  #cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.backend_sg.id
}

# app-alb is accepting connections from bastion host
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.bastion_sg.id

  #cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  
  # security group to apply this rule to
  security_group_id = module.app_alb_sg.id
}

# vpn is accepting connection from port 22 from public
resource "aws_security_group_rule" "vpn_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # accept connections from this source
  #source_security_group_id = module.ansible_sg.id

  cidr_blocks       = ["0.0.0.0/0"]   # usually we give our company IP here
  
  # security group to apply this rule to
  security_group_id = module.vpn_sg.id
}

# vpn is accepting connection from port 443 from public
resource "aws_security_group_rule" "vpn_public_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  # accept connections from this source
  #source_security_group_id = module.ansible_sg.id

  cidr_blocks       = ["0.0.0.0/0"]   # usually we give our company IP here
  
  # security group to apply this rule to
  security_group_id = module.vpn_sg.id
}

# vpn is accepting connection from port 943 from public
resource "aws_security_group_rule" "vpn_public_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  # accept connections from this source
  #source_security_group_id = module.ansible_sg.id

  cidr_blocks       = ["0.0.0.0/0"]   # usually we give our company IP here
  
  # security group to apply this rule to
  security_group_id = module.vpn_sg.id
}

# vpn is accepting connection from port 22 from public
resource "aws_security_group_rule" "vpn_public_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  # accept connections from this source
  #source_security_group_id = module.ansible_sg.id

  cidr_blocks       = ["0.0.0.0/0"]   # usually we give our company IP here
  
  # security group to apply this rule to
  security_group_id = module.vpn_sg.id
}


# app-alb is accepting connections from vpn on port 80
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.vpn_sg.id
  
  # security group to apply this rule to
  security_group_id = module.app_alb_sg.id
}

# backend is accepting connections from vpn on port 22
resource "aws_security_group_rule" "backend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.vpn_sg.id
  
  # security group to apply this rule to
  security_group_id = module.backend_sg.id
}

# backend is accepting connections from vpn on port 8080
resource "aws_security_group_rule" "backend_vpn" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # accept connections from this source
  source_security_group_id = module.vpn_sg.id
  
  # security group to apply this rule to
  security_group_id = module.backend_sg.id
}