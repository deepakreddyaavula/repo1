resource "aws_instance" "server1" {
  ami =  "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id     = "192.168.3.0/24"
  

 
  
    tags = {
    Name = "dev_server"
  }
}
