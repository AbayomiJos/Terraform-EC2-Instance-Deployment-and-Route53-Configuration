cidr_block    = "10.0.0.0/16"
dns_support   = true
dns_hostnames = true
vpc_name      = "project_vpc"
subnets = {
  subnet-1 = {
    az         = "us-east-1a"
    cidr_block = "10.0.0.0/18"
  }
  subnet-2 = {
    az         = "us-east-1b"
    cidr_block = "10.0.64.0/18"
  }
  subnet-3 = {
    az         = "us-east-1c"
    cidr_block = "10.0.128.0/19"
  }
}
project_igw           = "project_igw"
rt_name               = "public_rt"
instance_sg_name      = "instance-sg"
load_balancer_sg_name = "load-balancer-sg"
instance_type         = "t2.micro"
enable_public_ip      = true
lb_name               = "project-load-balancer"
lb_type               = "application"
target_group_name     = "project-target-group"
domain_name           = "mathidaduku.me"