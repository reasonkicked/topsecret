
resource "aws_vpc" "vpc_01" {
   cidr_block = var.cidr_vpc
   
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Environment = var.environment_tag
    Owner = var.owner_tag
   }
}
resource "aws_internet_gateway" "igw_01" {
  depends_on = [aws_vpc.vpc_01 ]
  vpc_id = aws_vpc.vpc_01.id
  tags = {
    Name = "${var.prefix}-${terraform.workspace}-igw_01"
    Environment = var.environment_tag
  }
}
resource "aws_subnet" "subnet_01" {
  depends_on = [aws_vpc.vpc_01  ]
  vpc_id = aws_vpc.vpc_01.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-subnet_01"
  }
}
resource "aws_subnet" "subnet_02" {
  depends_on = [aws_vpc.vpc_01 ]
  vpc_id = aws_vpc.vpc_01.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-subnet_02"
  }
}

resource "aws_subnet" "subnet_03" {
  depends_on = [aws_vpc.vpc_01 ]
  vpc_id = aws_vpc.vpc_01.id
  cidr_block = "10.1.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-subnet_03"
  }
}
resource "aws_subnet" "subnet_04" {
  depends_on = [aws_vpc.vpc_01 ]
  vpc_id = aws_vpc.vpc_01.id
  cidr_block = "10.1.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-subnet_04"
  }
}
resource "aws_subnet" "subnet_05" {
  depends_on = [aws_vpc.vpc_01 ]
  vpc_id = aws_vpc.vpc_01.id
  cidr_block = "10.1.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-subnet_05"
  }
}
resource "aws_subnet" "subnet_06" {
  depends_on = [aws_vpc.vpc_01 ]
  vpc_id = aws_vpc.vpc_01.id
  cidr_block = "10.1.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-subnet_06"
  }
}

resource "aws_eip" "eip_01" {
 vpc = true  
 tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-eip_01"
    Description = "eip for NAT GW"
  }
}
resource "aws_eip" "eip_02" {
 vpc = true  
 tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-eip_02"
    Description = "eip for NAT GW"
  }
}
resource "aws_eip" "eip_03" {
 vpc = true  
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-eip_03"
  }
}

resource "aws_nat_gateway" "nat_gw_01" {
 // depends_on = [aws_eip.eip_01  ]
  allocation_id = aws_eip.eip_01.id 
  subnet_id     = aws_subnet.subnet_01.id
   tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-nat_gw_01"
    Description = "NAT GW in subnet01"
  }

}
resource "aws_nat_gateway" "nat_gw_02" {
 // depends_on = [aws_eip.eip_02  ]
  allocation_id = aws_eip.eip_02.id 
  subnet_id     = aws_subnet.subnet_02.id
    tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-nat_gw_02"
    Description = "NAT GW in subnet02"
  }

 
}

resource "aws_route_table" "rtb_01" {
  
  vpc_id = aws_vpc.vpc_01.id
route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gw_01.id
  }
 tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-rtb_01"
  }
}
resource "aws_route_table" "rtb_02" {
 
  vpc_id = aws_vpc.vpc_01.id
route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gw_02.id
  }
 tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-rtb_02"
  }
}

resource "aws_route_table" "rtb_public_1" {
  vpc_id = aws_vpc.vpc_01.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw_01.id
  }
tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-rtb_public_1"
   
  }
}
resource "aws_route_table" "rtb_public_2" {
  vpc_id = aws_vpc.vpc_01.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw_01.id
  }
tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-rtb_public_2"
   
  }
}

resource "aws_route_table_association" "subnet_01_rta" {
  subnet_id      = aws_subnet.subnet_01.id
  route_table_id = aws_route_table.rtb_public_1.id
}
resource "aws_route_table_association" "subnet_02_rta" {
  subnet_id      = aws_subnet.subnet_02.id
  route_table_id = aws_route_table.rtb_public_2.id
}
resource "aws_route_table_association" "subnet_03_rta" {
  subnet_id      = aws_subnet.subnet_03.id
  route_table_id = aws_route_table.rtb_public_1.id
}
resource "aws_route_table_association" "subnet_04_rta" {
  subnet_id      = aws_subnet.subnet_04.id
  route_table_id = aws_route_table.rtb_public_2.id
}
resource "aws_route_table_association" "subnet_05_rta" {
  subnet_id      = aws_subnet.subnet_05.id
  route_table_id = aws_route_table.rtb_public_1.id
}
resource "aws_route_table_association" "subnet_06_rta" {
  subnet_id      = aws_subnet.subnet_06.id
  route_table_id = aws_route_table.rtb_public_2.id
}
resource "aws_security_group" "security_group_01" {
  name = "security_group_01"
  vpc_id = aws_vpc.vpc_01.id
  # Allow inbound HTTP requests
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
    //security_groups = [var.security_groups_ids]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
   tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-security_group_01"
    Description = "22"
    
  }
}
resource "aws_security_group" "security_group_02" {
  name = "security_group_02"
  vpc_id = aws_vpc.vpc_01.id
  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
    //security_groups = [var.security_groups_ids]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
   tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-security_group_02"
    Description = "80"
  }
}
resource "aws_security_group" "security_group_03" {
  name = "security_group_03"
  vpc_id = aws_vpc.vpc_01.id
  # Allow inbound HTTP requests
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
    //security_groups = [var.security_groups_ids]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
   tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-security_group_03"
    Description = "443"
  }
}
resource "aws_security_group" "security_group_04" {
  name = "security_group_04"
  vpc_id = aws_vpc.vpc_01.id
  # Allow inbound HTTP requests
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.security_group_02.id]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
   tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-security_group_04"
    Description = "3306"
  }
}