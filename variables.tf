variable "cidr_block" {
  description = "the cidr block of the vpc"
  type        = string
}

variable "dns_support" {
  description = "enable dns support"
  type        = bool
}

variable "dns_hostnames" {
  description = "enables dns hostname"
  type        = bool
}

variable "vpc_name" {
  description = "name of the vpc"
  type        = string
}

variable "subnets" {
  description = "the subnets and their corresponding availability zones"
  type        = map(any)
}

variable "project_igw" {
  description = "name of the internet gateway"
  type        = string
}

variable "rt_name" {
  description = "name of public route table"
  type        = string
}

variable "instance_sg_name" {
  description = "name of the instance security group"
  type        = string
}

variable "load_balancer_sg_name" {
  description = "name of the load balancer security group"
  type        = string
}

variable "instance_type" {
  description = "the type of instance"
  type        = string
}

variable "enable_public_ip" {
  description = "Associates instances with public IP"
  type        = bool
}

variable "lb_name" {
  description = "name of load balancer"
  type        = string
}

variable "lb_type" {
  description = "type of load balancer"
  type        = string
}

variable "target_group_name" {
  description = "name of target group"
  type        = string
}

variable "domain_name" {
  description = "the domain name"
  type        = string
}

