terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
  #i  configured my  aws credentials using aws configure command in my OS terminal then i  passed my profile name 
  #profile = "myprofilename"
}

# Configure the Random Provider
provider "random" {
  # Configuration options
}

module "my_vpc" {
  source = "./modules/network"
  vpc_cidr = "192.168.0.0/16"
  vpc_id = "${module.my_vpc.vpc_id}"
  private_subnet_cidr="${module.my_vpc.private_subnet_cidr[0]}"
  
}

module "ec2"{  
   source= "./modules/ec2" 
   subnet_id = "${module.my_vpc.private_subnet_cidr}"

   }

  module "s3"{
   source = "./modules/s3"
  }

  module "route53" {
   source = "./modules/Route53"
   vpc_id = "{module.my_vpc.vpc_id}"
   }


 
 


