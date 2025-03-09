variable "ins_ami" {
  type = string
  default = "ami-05b10e08d247fb927"
}

variable "ins_type" {
  type = string
  default = "t2.micro"
}

variable "sec_group" {
  type = string
  default = "Open_Ports"
}