# Change this backend to whatever your remote S3 bucket for storing
# your terraform state file.

# ... or comment out this whole file to have a local terraform state file
# terraform {
#     backend "s3" {
#         bucket = "terraform-backend-tk"
#         key    = "terraform.tfstate"
#         region = "eu-west-1"
#     }
# }
