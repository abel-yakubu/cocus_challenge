variable "region" {
  description = "AWS region.."
}

variable "aws_access_key" {
  type = string
  description = "AWS access key"
}
variable "aws_secret_key" {
  type = string
  description = "AWS secret key"
}

variable "instance_type" {
  type = string
  description = "AWS instance type to be crested"
}