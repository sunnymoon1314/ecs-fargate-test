# Comment out the below if you are working on local

terraform {
  backend "s3" {
    bucket = "sctp-ce5-tfstate-bucket-1"
    # key    = "ecs-fargate-luqman.tfstate" # Change the value of this to yourname-tf-workspace-act.tfstate for  example
    key = "soon.tfstate"
    region = "us-east-1"
  }
}