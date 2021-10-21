terraform {
  backend "s3" {
    bucket = "prod-3tier-app"
    key = "prod-3tier-app.tfstate"
    region = "eu-west-1"
  }
}