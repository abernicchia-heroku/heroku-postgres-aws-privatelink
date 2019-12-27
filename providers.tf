// Providers setup

provider "heroku" {
  version = "~> 2.0"
  email   = var.heroku_email
  api_key = var.heroku_api_key
}
  
provider "aws" {
  version    = "~> 2.43"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

provider "null" {
  version    = "~> 2.1"
}

