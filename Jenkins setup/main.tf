# Creating VPC

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.AZS.names
  public_subnets          = var.vpc_subnet
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = {
    Name        = "Jenkins-VPC"
    Terraform   = "true"
    Environment = "dev"
  }
}

#Creating Security Group

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "user-service"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "Jenkins-SG"
  }
}

# Creating EC2

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Jenkins"

  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("install-jenkins.sh")
  availability_zone           = data.aws_availability_zones.AZS.names[0]

  tags = {
    Name        = "Jenkins"
    Terraform   = "true"
    Environment = "dev"
  }
}