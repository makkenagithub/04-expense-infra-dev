variable "project_name" {
    default = "expense"
}

variable "env" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Env = "dev"
    }

}

variable "rds_tags" {
    default = {
        Component = "mysql"
    }
}