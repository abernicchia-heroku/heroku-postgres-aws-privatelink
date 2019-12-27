variable "heroku_email" {    
    default = "<YOUR_EMAIL>"
}

variable "heroku_api_key" {    
    default = "<YOUR_HEROKU_API_KEY>"
}

variable "heroku_enterprise_team" {
  default = "<YOUR_HEROKU_TEAM>"
}

variable "heroku_private_space" {
  default = "<YOUR_HEROKU_PRIVATE_SPACE_NAME>"
}

variable "aws_region" {
  description = "Amazon Web Services region"
  default = "<YOUR_AWS_REGION>" // One of the AWS regions below e.g. eu-central-1
}

variable "aws_to_heroku_private_region" {
  default = {
    "eu-west-1"      = "dublin"
    "eu-central-1"   = "frankfurt"
    "us-west-2"      = "oregon"
    "ap-southeast-2" = "sydney"
    "ap-northeast-1" = "tokyo"
    "us-east-1"      = "virginia"
  }
}

variable "app_name" {
  default = "<YOUR_HEROKU_APP_NAME>"
}

variable "aws_account_id" {    
    default = "<YOUR_AWS_ACCOUNT_ID>"
}

variable "aws_access_key" {    
    default = "<YOUR_AWS_IAM_ACCESS_KEY>"
}

variable "aws_secret_key" {    
    default = "<YOUR_AWS_IAM_SECRET_KEY>"
}

variable "ssh_public_key" {
  default = "<YOUR_PUBLIC_KEY_FOR_SSH_CONNECTION>" //  e.g. ssh-rsa AZZZAANzaC1yc2EPPTTTAQABAAA....
}

variable "ssh_private_key_filepath" {
  default = "<YOUR_PRIVATE_KEY_FILE_PATH_FOR_SSH_CONNECTION>" // e.g. /Users/Keys/ssh-key-pair
}

variable "name" {
  default = "<YOUR_PREFIX_NAME>" // to be used as a prefix for AWS resources identifiers and names
}

variable "aws-ami" {
  default = "ami-0cc0a36f626a4fdf5" // ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20191002
}

variable "ec2_user" {    
    default = "ubuntu" // EC2's user account for SSH connection
}
