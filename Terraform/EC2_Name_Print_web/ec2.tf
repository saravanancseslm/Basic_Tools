resource "aws_instance" "Terraform_Auto" {
  ami = var.ins_ami
  instance_type = var.ins_type
  key_name = "Amazon_Linux_Key"
  vpc_security_group_ids = [var.sec_group]
  user_data = file("script.sh")


tags = {
    Name = "Terraform_Webapp"
}

}
