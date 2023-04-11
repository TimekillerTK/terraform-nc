# Finds most recent amazon_linux minimal image
data "aws_ami" "amazon_linux" {
    most_recent = true

    filter {
        # NOTE: minimal AL2023 AMI does not have amazon-ssm-agent installed by default
        # -> yum info amazon-ssm-agent
        name   = "name"
        values = ["al2023-ami-2023*"]
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
    security_groups = [aws_security_group.allow_ssh.id]

    tags = merge(local.common_tags, { 
        Name = "${var.environment}-${var.namespace}-nw-interface"
    })
}

# SSH keypair
resource "aws_key_pair" "ssh_access_key" {
    public_key = var.ssh_public_key

    tags = merge(local.common_tags, {
        Name = "${var.environment}-${var.namespace}-keypair"
    })
}

# EC2 Instance
resource "aws_instance" "ec2_instance" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    key_name = aws_key_pair.ssh_access_key.key_name

    network_interface {
        network_interface_id = aws_network_interface.nw_interface.id
        device_index         = 0
    }

    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name


    tags = merge(local.common_tags, {
        Name = "${var.environment}-${var.namespace}-ec2-instance"
    })
}


 