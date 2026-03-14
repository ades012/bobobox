variable "aws_region" {
  default = "ap-southeast-1"
}
variable "project_name" {
  default = "bobobox"
}
variable "environment" {
  default = "dev"
  
}
variable "instance_type" {
    description = "EC2 Instance Type"
    default = "t3.micro"
    type = string
}