output "Terraform_VPC" {
  value = "http://${aws_instance.my_app.public_ip}"
  description = "Access your website using this URL"
}

# output "my_app2" {
#   value = "http://${aws_instance.my_app2.public_ip}"
#   description = "Access your website using this URL"
# }