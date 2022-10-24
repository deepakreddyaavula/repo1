# private route53 zone
resource "aws_route53_zone" "private" {
  name = var.domain_name

vpc { 
  vpc_id = "192.168.3.0/24"
  }
 

  tags = {
    Environment = "Test"
  }
}

# creating a record in private hosted zone
resource "aws_route53_record" "private_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.record_name
  type    = "A"
  ttl     = 300
  #records = [aws_instance.server1.private_ip]
  records = ["instance-test.geo-terraform-test.com"]
}

