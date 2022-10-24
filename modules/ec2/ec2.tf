resource "aws_instance" "server1" {
  ami =  "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id     = "aws_subnet.private_subnet[0].id"
  

 
  
    tags = {
    Name = "test_server"
  }
}
