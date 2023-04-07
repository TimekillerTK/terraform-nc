# Finds most recent amazon_linux minimal image
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-minimal-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name  = "architecture"
    values = ["x86_64"]
  }

  owners = ["137112412989"] # AWS
}

# EIP association
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2_instance.id
  allocation_id = aws_eip.eip.id
}

# EC2 Network Inferface
resource "aws_network_interface" "nw_interface" {
  subnet_id   = aws_subnet.public_1.id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-nw-interface"
  })
}

# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  network_interface {
    network_interface_id = aws_network_interface.nw_interface.id
    device_index         = 0
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.namespace}-ec2-instance"
  })
}

# TODO: Fix connection by adding security groups lol
 