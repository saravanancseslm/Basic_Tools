resource "local_file" "instance_output" {
  filename = "instance_details.txt"
  content  = <<EOT
------------------------------------------------------
| Name                | Public IP       | Private IP   |
------------------------------------------------------
%{for i in aws_instance.my_app}
| ${i.tags.Name}  | ${i.public_ip} | ${i.private_ip} |
%{endfor}
------------------------------------------------------
EOT
}
