variable "environment" {
    description = "Envrionment, like dev/tst/acc/prd"
    default     = "dev"

}

variable "namespace" {
    description = "Name of the namespace"
    default     = "terraform"
}

variable "project_url" {
    description = "URL of source project"
    default     = "https://example.com"
}

variable "aws_region" {
    description = "AWS Region"
    default     = "eu-west-1"
}


variable "vpc_cidr_two_octets" {
    description = "First two octets of the VPC CIDR"
    default     = "10.177"
}

variable "instance_type" {
    description = "Type of EC2 instance"
    default     = "t3a.micro"
}