variable "aws_ami" {
  type = string
  default = "ami-02d7f904d20fb845c" 
  description = "AMI"
}

variable "instance_type" {
  type = string
  default = "t2.medium" 
  description = "AWS instance type"
}

variable "region" {
  type = string
  default = "us-east-2" 
  description = "AWS Region"
}
