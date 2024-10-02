variable "project_name" {
    default = "expense"
}

variable "env" {
    default = "dev"
}

variable "sg_name" {
    default = ""
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Env = "dev"
    }

}

variable "mysql_sg_tags" {
    default = {
        Component = "mysql"
    }

}

variable "backend_sg_tags" {
    default = {
        Component = "backend"
    }

}

variable "frontend_sg_tags" {
    default = {
        Component = "frontend"
    }

}

variable "frontend_sg_tags" {
    default = {
        Component = "bastion"
    }

}


variable "ansible_sg_tags" {
    default = {
        Component = "ansible"
    }

}
