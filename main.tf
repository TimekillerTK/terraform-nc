provider "aws" {
  region = var.aws_region
}

# Get Availability zones for AWS region
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az1 = data.aws_availability_zones.available.names[0]
  az2 = data.aws_availability_zones.available.names[1]
  common_tags = {
    Environment = var.environment
    ProjectUrl  = var.project_url 
    Terraform   = "true"
  }
}



