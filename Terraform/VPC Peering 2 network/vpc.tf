
# 1. VPC Peering Connection

  # 1.1 VPC A Resource need to create (172.16.0.0/16)
  # 1.2 VPC B Resource need to create (192.168.0.0/16)
  # 1.3 VPC-A to VPC - B Peering connection (172.16.0.0/16 to 192.168.0.0/16)

# 2. Internet Gateway 

  # 2.1 Internet Gateway for VPC A Public Instance (172.16.0.0/16)
  # 2.2 Internet Gateway for VPC B Public Instance (192.168.0.0/16)

# 3. Subnet

  # 3.1 Subnet for VPC A Public (172.16.1.0/24)
  # 3.2 Subnet for VPC A Private (172.16.2.0/24)
    
  # 3.1 Subnet for VPC B Public (192.168.1.0/24)
  # 3.2 Subnet for VPC B Private (192.168.2.0/24)

# 4. Route Table

  # 4.1 Route table for VPC A Public (172.16.1.0/24)
    # 4.1.0 Internet Gateway attach on VPC A Public Instance (172.16.1.0/24)
  # 4.2 Route table for VPC A Private (172.16.2.0/24)
        
  # 4.3 Route table for VPC B Public (192.168.1.0/24)
    # 4.3.0 Internet Gateway attach on VPC B Public Instance (192.168.1.0/24)
  # 4.4 Route table for VPC B Private (192.168.2.0/24)

# 5. Route Table Subnet Assocation

  # 5.1 Subnet Assocation add on VPC A Public subnet (172.16.1.0/24)
  # 5.2 Subnet Assocation Peering Connection on VPC A to B (172.16.0.0/16 to 192.168.0.0/16) 16 it meen provide accesss for hole VPC CIDR Range
      
  # 5.3 Subnet Assocation add on VPC A Private subnet (172.16.2.0/24)
  # 5.4 Subnet Assocation Peering Connection on VPC A to B (172.16.0.0/16 to 192.168.0.0/16) 16 it meen provide accesss for hole VPC CIDR Range
      
  # 5.5 Subnet Assocation add on VPC B Public subnet (192.168.1.0/24)
  # 5.6 Subnet Assocation Peering Connection on VPC B to A (192.168.0.0/16 to 172.16.0.0/16) 16 it meen provide accesss for hole VPC CIDR Range
    
  # 5.7 Subnet Assocation add on VPC B Private subnet (192.168.2.0/24)
  # 5.8 Subnet Assocation Peering Connection on VPC B to A (192.168.0.0/16 to 172.16.0.0/16) 16 it meen provide accesss for hole VPC CIDR Range

# 6. Security Group

  # 6.1 VPC A Public Instance ICMP V4 (0.0.0.0/0) SSH (your IP or 0.0.0.0/0) HTTP (0.0.0.0/0) Outbound all traffic (0.0.0.0/0)
  # 6.2 VPC A Private Instance ICMP V4 and SSH (172.16.1.0/24, 192.168.2.0/24) if required VPC B Public instance (192.168.1.0/24) 
  # 6.3 VPC B Public Instance ICMP V4 (0.0.0.0/0) SSH (your IP or 0.0.0.0/0) HTTP (0.0.0.0/0) Outbound all traffic (0.0.0.0/0)
  # 6.4 VPC B Private Instance ICMP V4 and SSH (192.168.1.0/24, 172.16.2.0/24) if required VPC A Public instance (172.16.1.0/24)

# 7. Ec2 Instance

  # 7.1 instance launching on Public1
  # 7.2 instance launching on DB1

  # 7.3 Instance launching on public2
  # 7.4 instance launching on DB2

# 8. Output

  # 8.1 getting public1 pub ip
  # 8.2 getting public1 pri ip
  # 8.3 getting DB1 pri ip

  # 8.4 getting public2 pub ip
  # 8.5 getting public2 pri ip
  # 8.6 getting DB2 pri ip

#========================================================================================================================================#

# 1.1 VPC A Resource need to create (172.16.0.0/16)

resource "aws_vpc" "VPC_A" {
  cidr_block = "172.16.0.0/16"

tags = {
    Name = "VPC_${var.client_name}"
    Manged_by = "${var.managed_by}"
  }
}

#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#

# 1.2 VPC B Resource need to create (192.168.0.0/16)

resource "aws_vpc" "VPC_B" {
  cidr_block = "192.168.0.0/16"

tags = {
    Name = "VPC_${var.vendor_name}"
    Manged_by = "${var.managed_by}"
  }
}

# 1.3 VPC-A to VPC - B Peering connection (172.16.0.0/16 to 192.168.0.0/16)

resource "aws_vpc_peering_connection" "peer_vpc" {
  vpc_id      = aws_vpc.VPC_A.id
  peer_vpc_id = aws_vpc.VPC_B.id
  auto_accept = true

  tags = {
    Name       = "VPC_${var.client_name}-to-VPC_${var.vendor_name}"
    Managed_by = "${var.managed_by}"
  }
}

# #111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111#

# 2.1 Internet Gateway for VPC A Public Instance (172.16.0.0/16)

resource "aws_internet_gateway" "igw_VPC_A" {
  vpc_id = aws_vpc.VPC_A.id 

  tags = {
    Name = "igw_VPC_${var.client_name}"
    Manged_by = "${var.managed_by}"
  }
}

#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#

# 2.2 Internet Gateway for VPC B Public Instance (192.168.0.0/16)

resource "aws_internet_gateway" "igw_VPC_B" {
  vpc_id = aws_vpc.VPC_B.id 

  tags = {
     Name = "igw_VPC_${var.vendor_name}"
    Manged_by = "${var.managed_by}"
  }
}

#2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222#

# 3.1 Subnet for VPC A Public (172.16.1.0/24)

resource "aws_subnet" "Pub_Subnet1" {
  vpc_id     = aws_vpc.VPC_A.id
  cidr_block = "172.16.1.0/24"

  tags = {
    Name = "${var.client_name}_Pub_Subnet1"
    Manged_by = "${var.managed_by}"
  }
}


# 3.2 Subnet for VPC A Private (172.16.2.0/24)

resource "aws_subnet" "Priv_Subnet1" {
  vpc_id     = aws_vpc.VPC_A.id
  cidr_block = "172.16.2.0/24"

  tags = {
    Name = "${var.client_name}_Priv_Subnet1"
    Manged_by = "${var.managed_by}"
  }
}

#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#

# 3.1 Subnet for VPC B Public (192.168.1.0/24)

resource "aws_subnet" "Pub_Subnet2" {
  vpc_id     = aws_vpc.VPC_B.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "${var.vendor_name}_Pub_Subnet2"
    Manged_by = "${var.managed_by}"
  }
}

# 3.2 Subnet for VPC B Private (192.168.2.0/24)

resource "aws_subnet" "Priv_Subnet2" {
  vpc_id     = aws_vpc.VPC_B.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "${var.vendor_name}_Priv_Subnet2"
    Manged_by = "${var.managed_by}"
  }
}

#3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333#

# 4.1 Route table for VPC A Public (172.16.1.0/24)

resource "aws_route_table" "RT_public1" {
  vpc_id = aws_vpc.VPC_A.id

  # 4.1.0 Internet Gateway attach on VPC A Public Instance (172.16.1.0/24)  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_VPC_A.id
  }

    tags = {
    Name = "${var.client_name}_RT_Public1"
    Manged_by = "${var.managed_by}"
  }
}

# 4.2 Route table for VPC A Private (172.16.2.0/24)

resource "aws_route_table" "RT_private1" {
  vpc_id = aws_vpc.VPC_A.id


  tags = {
    Name = "${var.client_name}_RT_Private1"
    Manged_by = "${var.managed_by}"
  }
}

#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#

# 4.3 Route table for VPC B Public (192.168.1.0/24)

resource "aws_route_table" "RT_public2" {
  vpc_id = aws_vpc.VPC_B.id

  # 4.3.0 Internet Gateway attach on VPC B Public Instance (192.168.1.0/24)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_VPC_B.id
  }

  tags = {
    Name = "${var.vendor_name}_RT_Public2"
    Manged_by = "${var.managed_by}"
  }
}

# 4.4 Route table for VPC B Private (192.168.2.0/24)

resource "aws_route_table" "RT_private2" {
  vpc_id = aws_vpc.VPC_B.id


  tags = {
    Name = "${var.vendor_name}_RT_Private2"
    Manged_by = "${var.managed_by}"
  }
}

#4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444#

# 5.1 Subnet Assocation add on VPC A Public subnet (172.16.1.0/24)

resource "aws_route_table_association" "Pub_SubnetRT1" {
  subnet_id      = aws_subnet.Pub_Subnet1.id
  route_table_id = aws_route_table.RT_public1.id
}

# 5.2 Subnet Assocation Peering Connection on VPC A to B (172.16.0.0/16 to 192.168.0.0/16)

resource "aws_route" "VPC_A_to_VPC_B_pub1" {
  route_table_id         = aws_route_table.RT_public1.id
  # destination_cidr_block = "192.168.0.0/16"  # VPC B CIDR
  destination_cidr_block = aws_vpc.VPC_B.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_vpc.id
}

# 5.3 Subnet Assocation add on VPC A Private subnet (172.16.2.0/24)

resource "aws_route_table_association" "Priv_SubnetRT1" {
  subnet_id      = aws_subnet.Priv_Subnet1.id
  route_table_id = aws_route_table.RT_private1.id
}

# 5.4 Subnet Assocation Peering Connection on VPC A to B (172.16.0.0/16 to 192.168.0.0/16)

resource "aws_route" "VPC_A_to_VPC_B_pri1" {
  route_table_id         = aws_route_table.RT_private1.id
  # destination_cidr_block = "192.168.0.0/16"  # VPC B CIDR
  destination_cidr_block = aws_vpc.VPC_B.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_vpc.id
}


# #BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#

# 5.5 Subnet Assocation add on VPC B Public subnet (192.168.1.0/24)

resource "aws_route_table_association" "Pub_SubnetRT2" {
  subnet_id      = aws_subnet.Pub_Subnet2.id
  route_table_id = aws_route_table.RT_public2.id
}

# # 5.6 Subnet Assocation Peering Connection on VPC B to A (192.168.0.0/16 to 172.16.0.0/16)

resource "aws_route" "VPC_B_to_VPC_A_pub2" {
  route_table_id         = aws_route_table.RT_public2.id
  # destination_cidr_block = "172.16.0.0/16"  # VPC A CIDR
  destination_cidr_block = aws_vpc.VPC_A.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_vpc.id
}

# resource "aws_route" "VPC_B_RT_pub_to_VPC_A_Pri_Subnet" {
#   route_table_id         = aws_route_table.RT_private2.id
#   destination_cidr_block = aws_subnet.Priv_Subnet1.cidr_block # want to map only subnet CIDR block
#   # destination_cidr_block = aws_vpc.VPC_B.cidr_block # ant to map only VPC CIDR block
#   vpc_peering_connection_id = aws_vpc_peering_connection.peer_vpc.id
# }

# 5.7 Subnet Assocation add on VPC B Private subnet (192.168.2.0/24)

resource "aws_route_table_association" "Priv_SubnetRT2" {
  subnet_id      = aws_subnet.Priv_Subnet2.id
  route_table_id = aws_route_table.RT_private2.id
}

# 5.8 Subnet Assocation Peering Connection on VPC B to A (192.168.0.0/16 to 172.16.0.0/16)

resource "aws_route" "VPC_B_to_VPC_A_pri2" {
  route_table_id         = aws_route_table.RT_private2.id
  # destination_cidr_block = "172.16.0.0/16"  # VPC B CIDR
  destination_cidr_block = aws_vpc.VPC_A.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_vpc.id
}

# resource "aws_route" "VPC_B_RT_pub_to_VPC_A_Pri_Subnet" {
#   route_table_id         = aws_route_table.RT_private2.id
#   destination_cidr_block = aws_subnet.Priv_Subnet1.cidr_block # want to map only subnet CIDR block
#   # destination_cidr_block = aws_vpc.VPC_B.cidr_block # ant to map only VPC CIDR block
#   vpc_peering_connection_id = aws_vpc_peering_connection.peer_vpc.id
# }

# #555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555#

# # 6.1 VPC A Public Instance ICMP V4 (0.0.0.0/0) SSH (your IP or 0.0.0.0/0) HTTP (0.0.0.0/0) Outbound all traffic (0.0.0.0/0)

resource "aws_security_group" "sg_public_A" {
  name        = "${var.client_name}_sg_public"
  vpc_id      = aws_vpc.VPC_A.id

  # ingress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0", aws_vpc.VPC_Auto.cidr_block]
  # }
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
   Name = "SG_${var.client_name}_public"
    Manged_by = "${var.managed_by}"
  }
}

# 6.2 VPC A Private Instance ICMP V4 and SSH (172.16.1.0/24, 192.168.2.0/24) if required VPC B Public instance (192.168.1.0/24)

resource "aws_security_group" "sg_private_A" {
  name        = "${var.client_name}_sg_private"
  vpc_id      = aws_vpc.VPC_A.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.16.1.0/24","192.168.2.0/24","192.168.1.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.1.0/24","192.168.2.0/24","192.168.1.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
   Name = "SG_${var.client_name}_private"
    Manged_by = "${var.managed_by}"
  }
}

#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#

# 6.3 VPC A Public Instance ICMP V4 (0.0.0.0/0) SSH (your IP or 0.0.0.0/0) HTTP (0.0.0.0/0) Outbound all traffic (0.0.0.0/0)

resource "aws_security_group" "sg_public_B" {
  name        = "${var.vendor_name}_sg_public"
  vpc_id      = aws_vpc.VPC_B.id

  # ingress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0", aws_vpc.VPC_Auto.cidr_block]
  # }
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
   Name = "SG_${var.vendor_name}_public"
    Manged_by = "${var.managed_by}"
  }
}

# 6.4 VPC B Private Instance ICMP V4 and SSH (192.168.1.0/24, 172.16.2.0/24) if required VPC A Public instance (172.16.1.0/24)

resource "aws_security_group" "sg_private_B" {
  name        = "${var.vendor_name}_sg_private"
  vpc_id      = aws_vpc.VPC_B.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.16.1.0/24","172.16.2.0/24","192.168.1.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.1.0/24","172.16.2.0/24","192.168.1.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
   Name = "SG_${var.vendor_name}_private"
    Manged_by = "${var.managed_by}"
  }
}

#6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666#

# 7.1 instance launching on Public1

resource "aws_instance" "A_pub" {
  ami                            = var.ins_ami
  instance_type                  = var.ins_type
  key_name                       = "Amazon_Linux_Key"
  subnet_id                      = aws_subnet.Pub_Subnet1.id
  associate_public_ip_address    = "true"
  vpc_security_group_ids         = [aws_security_group.sg_public_A.id]
  tags = {
    Name       = "${var.client_name}-pub"
    Managed_by = "${var.managed_by}"
  }
  
}

# 7.2 instance launching on DB1

resource "aws_instance" "DB1" {
  ami                           = var.ins_ami
  instance_type                 = var.ins_type
  key_name                      = "Amazon_Linux_Key"
  subnet_id                     = aws_subnet.Priv_Subnet1.id
  associate_public_ip_address   = "false"
  vpc_security_group_ids        = [aws_security_group.sg_private_A.id]

  tags = {
    Name       = "${var.client_name}-DB1"
    Managed_by = "${var.managed_by}"
  }
  
}

#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#

# 7.3 Instance launching on public2

resource "aws_instance" "B_pub" {
  ami                            = var.ins_ami
  instance_type                  = var.ins_type
  key_name                       = "Amazon_Linux_Key"
  subnet_id                      = aws_subnet.Pub_Subnet2.id
  associate_public_ip_address    = "true"
  vpc_security_group_ids         = [aws_security_group.sg_public_B.id]
  tags = {
    Name       = "${var.client_name}-pub"
    Managed_by = "${var.managed_by}"
  }
  
}

# 7.4 instance launching on DB2

resource "aws_instance" "DB2" {
  ami                           = var.ins_ami
  instance_type                 = var.ins_type
  key_name                      = "Amazon_Linux_Key"
  subnet_id                     = aws_subnet.Priv_Subnet2.id
  associate_public_ip_address   = "false"
  vpc_security_group_ids        = [aws_security_group.sg_private_B.id]

  tags = {
    Name       = "${var.client_name}-DB2"
    Managed_by = "${var.managed_by}"
  }
  
}

#777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777#

# 8.1 getting public1 pub ip

output "A_pub" {
  value = aws_instance.A_pub.public_ip
  description = "your Public ip"
}

# 8.2 getting public1 pri ip

output "A_pri" {
  value = aws_instance.A_pub.private_ip
  description = "your Public ip"
}

# 8.3 getting DB1 pri ip

output "DB1_Pri" {
  value = aws_instance.DB1.private_ip
  description = "your Public ip"
}

# 8.4 getting public2 pub ip

output "B_pub" {
  value = aws_instance.B_pub.public_ip
  description = "your Public ip"
}

# 8.5 getting public2 pri ip

output "B_pri" {
  value = aws_instance.B_pub.private_ip
  description = "your Public ip"
}

# 8.6 getting DB2 pri ip

output "DB2_Pri" {
  value = aws_instance.DB2.private_ip
  description = "your Public ip"
}

#-----------------------------------------------------------------END-------------------------------------------------------------------#