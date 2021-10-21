variable "region" {
    default = "eu-west-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0f9cf087c1f27d9b1"
    us-west-2 = "ami-0653e888ec96eab9b"
    eu-west-1 = "ami-0a8e758f5e873d1c1"
  }
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "keyname" {
    default = "ELKServer"
}
