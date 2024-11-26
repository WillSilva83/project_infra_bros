
locals {
  cw = terraform.workspace
}


module "vpc" {
  source = "../network"
}


# SECURITY GROUP 

resource "aws_security_group" "ec2_sg" {
    name = "ec2_security_group"
    vpc_id = module.vpc.vpc_id

    ## Acesso SSH 

    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Permitir saida 

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 

    tags = {
      Name = "ec2_security_group_${local.cw}"
    }

}

data "aws_ami" "linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "ec2_main" {
    ami = data.aws_ami.linux.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    subnet_id = module.vpc.out_subnet_id

    key_name = "project_vpcs"

    tags = {
      Name = "db_${local.cw}"
    }
  
}

