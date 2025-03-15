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

variable "zone_name" {

    default = "daws81s.online"
}