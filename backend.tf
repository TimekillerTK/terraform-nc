terraform {
  backend "s3" {
    bucket = "terraform-backend-tk"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
