variable "project_name"{
    type =string
    default = "expense"
}

variable "environment"{
    type = string
    default = "dev"
}

variable "common_tags"{
    default ={
        project = "expense"
        environment = "dev"
        Terraform = "true"
    }
}

