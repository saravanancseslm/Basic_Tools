variable "client_name" {
  default = "my-default"
}

variable "vendor_name" {
  default = "my-default"
}

variable "managed_by" {
  default = "my-default"
}

variable "ins_ami" {
  type = string
  default = "ami-05b10e08d247fb927"
}

variable "ins_type" {
  type = string
  default = "t2.micro"
}

variable "sec_group_Public" {
  type = string
  default = "my-default"
}

variable "sec_group_Private" {
  type = string
  default = "my-default"
}

variable "sec_gro_pri_lmcpl" { 
}

variable "sec_gro_pub_lmcpl" { 
}

