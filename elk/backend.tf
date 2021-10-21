terraform {
  backend "s3" {
    bucket = "prod-3tier-app"
    key = "elk.tfstate"
    region = "eu-west-1"
  }
}