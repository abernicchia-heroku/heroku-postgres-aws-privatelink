// Providers setup

terraform {
  required_providers {

    heroku = { 
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
      
    aws = {
      version    = "~> 2.43"
    }

    null = {
      version    = "~> 2.1"
    }

  }
}


provider "heroku" { 
  email   = var.heroku_email
  api_key = var.heroku_api_key
}

provider "aws" { 
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}



