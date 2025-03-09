resource "aws_instance" "Terraform_Auto" {
  ami 			 ="ami-05b10e08d247fb927"
  instance_type  ="t2.micro"
  key_name   ="Amazon_Linux_Key"
  security_groups = ["Open_Ports"]
  user_data =file("Docker_Auto.sh")
  
  tags ={
  Name           = "Terraform_Auto"
  }
 }