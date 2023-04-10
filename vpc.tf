# VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_two_octets}.0.0/16"

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-vpc"
  })
}


# Subnets
resource "aws_subnet" "public_1" {
  cidr_block = "${var.vpc_cidr_two_octets}.101.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az1

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-sn-public1"
  })
}

resource "aws_subnet" "public_2" {
  cidr_block  = "${var.vpc_cidr_two_octets}.102.0/24"
  vpc_id      = aws_vpc.main.id
  availability_zone = local.az2

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-sn-public2"
  })
}

resource "aws_subnet" "private_1" {
  cidr_block  = "${var.vpc_cidr_two_octets}.1.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az1

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-sn-private1"
  })
}

resource "aws_subnet" "private_2" {
  cidr_block  = "${var.vpc_cidr_two_octets}.2.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az2

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-sn-private2"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-igw"
  })
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-rt-public"
  })
}

# NOTE: Uses the default route table created with EVERY VPC
resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-rt-private"
  })
}

# Route Table associations
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_default_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_default_route_table.private.id
}

# Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.ec2_instance.id
}

# Security Groups
resource "aws_security_group" "allow_ssh" {
  name = "${var.environment}-${var.namespace}-sg-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH access to EC2"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.local_public_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-sg-ssh"
  })
}

