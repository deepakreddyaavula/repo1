variable "vpc_cidr" {
    description = "provide VPC CIDR range here"
    type        = string
    default     = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
    description = "provide public subnet CIDR range here "
    type = list(string)
    default = [ "192.168.1.0/24", "192.168.2.0/24" ]

  
}

variable "private_subnet_cidr" {
    description = "provide private subnet CIDR range here "
    type = list(string)
    default = [ "192.168.3.0/24", "192.168.4.0/24" ]

  
}

variable "map_public_ip_on_launch" {
  description = "Assign a public IP address to instances launched into these subnets"
  type        = bool
  default     = true
}
