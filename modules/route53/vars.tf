#route53 variables

variable "domain_name" {
    description = "domain name"
    type = string
    default = "geo-terraform-test.com"

}

variable "record_name" {
    description = "record name"
    type = string
    default = "instance-test.geo-terraform-test.com"
}
