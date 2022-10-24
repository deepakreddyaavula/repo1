output "vpc_id" {
    value ="{aws_vpc.geo_vpc.id}"
  
}

output "subnet_id" {
    value ="${aws_subnet.private_subnet[0].id}"
}
