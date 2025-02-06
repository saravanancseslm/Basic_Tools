output "public_ip" {
	description = "The public IP address asigned to the instance"
	value		= try(aws_instance.Terraform_Auto.public_ip, "")
}  
output "public_dns" {
	description = "The public IP address asigned to the instance"
	value		= try(aws_instance.Terraform_Auto.public_dns, "")
}
output "private_ip" {
	description = "The public IP address asigned to the instance"
	value		= try(aws_instance.Terraform_Auto.private_ip, "")
}