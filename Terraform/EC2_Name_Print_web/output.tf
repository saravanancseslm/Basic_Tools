output "Terraform" {
  value = aws_instance.Terraform_Auto.public_ip
  description = "your Public ip"
}