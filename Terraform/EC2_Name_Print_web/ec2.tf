
# 1, VPC Creating

resource "aws_vpc" "Terraform_VPC" {
  cidr_block = "172.16.0.0/16"

tags = {
    Name = "Terraform_VPC"
    Manged_by = "Terraform"
  }
}

# 2, Subnet 

resource "aws_subnet" "Terraform_Subnet" {
  vpc_id = aws_vpc.Terraform_VPC.id
  cidr_block = "172.16.1.0/24"

  tags = {
    Name = "Terraform_VPC"
    Manged_by = "Terraform"
  }
}


# 3, Internet gateway

resource "aws_internet_gateway" "Terraform_igw" {
  vpc_id = aws_vpc.Terraform_VPC.id
  tags = {
    Name = "Terraform_VPC"
    Manged_by = "Terraform"
  }
}

# 4, Routetable 

resource "aws_route_table" "Terraform_RT" {
vpc_id = aws_vpc.Terraform_VPC.id

route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Terraform_igw.id
}

tags = {
    Name = "Terraform_VPC"
    Manged_by = "Terraform"
  }
}

# 5, Routetable Assocation

resource "aws_route_table_association" "Map_Terraform_VPC" {
subnet_id = aws_subnet.Terraform_Subnet.id
route_table_id = aws_route_table.Terraform_RT.id

}

# 6, Security 

resource "aws_security_group" "Open_Ports" {
 vpc_id = aws_vpc.Terraform_VPC.id
 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
   Name = "Open_Ports"
    Manged_by = "Terraform"
  }
}

# 7 Launching Instance

resource "aws_instance" "my_app" {
    ami                      = "ami-05b10e08d247fb927"
    instance_type            = "t2.micro"
    key_name                 = "Amazon_Linux_Key"
    subnet_id                = aws_subnet.Terraform_Subnet.id
    associate_public_ip_address = "true" 
    vpc_security_group_ids   = [aws_security_group.Open_Ports.id]
    user_data                = file("script.sh") 
    

    tags = {
      Name = "Terraform_Auto"
    }
}