module "db"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for db mysql instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "db"
}

module "backend"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for backend instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "backend"
}

module "frontend"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for frontend instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "frontend"
}

module "bastion"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for bastion instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "bastion"
}

module "ansible"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for ansible instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "ansible"
}

#DB is accepting connection from backend

resource "aws_security_group_rule" "db_backend"{
    type = "ingress"
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    source_security_group_id = module.backend.sg_id 
    security_group_id = module.db.sg_id
}

#DB is accepting connection from bastion

resource "aws_security_group_rule" "db_bastion"{
    type = "ingress"
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    source_security_group_id = module.backend.sg_id 
    security_group_id = module.bastion.sg_id
}

#backend is accepting connection from frontend
resource "aws_security_group_rule" "backend_frontend"{
    type = "ingress"
    from_port = "8080"
    to_port = "8080"
    protocol = "tcp"
    source_security_group_id = module.frontend.sg_id
    security_group_id = module.backend.sg_id
}

#backend is accepting connection from bastion
resource "aws_security_group_rule" "backend_bastion"{
    type = "ingress"
    from_port = "8080"
    to_port = "8080"
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id
    security_group_id = module.backend.sg_id
}

#backend is accepting connection from ansible
resource "aws_security_group_rule" "backend_ansible"{
    type = "ingress"
    from_port = "8080"
    to_port = "8080"
    protocol = "tcp"
    source_security_group_id = module.ansible.sg_id
    security_group_id = module.backend.sg_id
}

#frontend is accepting connection from ansible
resource "aws_security_group_rule" "frontend_ansible"{
    type = "ingress"
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    source_security_group_id = module.ansible.sg_id
    security_group_id = module.frontend.sg_id
}

#frontend is accepting connection from public
resource "aws_security_group_rule" "frontend_public"{
    type = "ingress"
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend.sg_id
}

#bastion is accepting connection from public
resource "aws_security_group_rule" "bastion_public"{
    type = "ingress"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
}

#ansible is accepting connection from public
resource "aws_security_group_rule" "ansible_public"{
    type = "ingress"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.ansible.sg_id
}