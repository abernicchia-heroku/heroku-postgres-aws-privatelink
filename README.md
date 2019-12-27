# Connecting to a Private Heroku Postgres via AWS PrivateLink - Terraform files
This Repository contains a set of Terraform files to create a complete sandbox environment, including both Heroku and AWS resources, to test how connecting to a Private or Shield Heroku Postgres Database via AWS PrivateLink, as described here: https://devcenter.heroku.com/articles/heroku-postgres-via-privatelink

# Pre-requisites
- An Heroku Account
- An Heroku API Key (see [here](https://devcenter.heroku.com/articles/platform-api-quickstart#authentication) to create one)
- An Heroku Enterprise Team
- The [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) with the PrivateLink plugin installed
`$ heroku plugins:install data-privatelink`
- The [Terraform CLI](https://www.terraform.io/downloads.html)
- An AWS account ID (see [here](https://devcenter.heroku.com/articles/heroku-postgres-via-privatelink#step-2-obtain-your-aws-account-id) to retrieve it)
- An AWS IAM access and secret key pair (see [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html) for the Root user or [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console) to create a new IAM user for your AWS account)
- A ssh key file `$ ssh-keygen -f /Users/aws-ec2-integrationuser-key-pair` and its public key `$ ssh-keygen -y -f /Users/aws-ec2-integrationuser-key-pair`

# How to create the sandbox environment
1) Open a Terminal and log in via Heroku CLI. You must be logged in the Heroku CLI on the terminal used to execute Terraform commands
2) Fill in the **vars.template.tf_** variables file and rename it to **vars.tf** `$ mv vars.template.tf_ vars.tf`
3) Execute `$ terraform apply` and type "yes" when asked to proceed with the infrastructure creation - the whole process will take about **20 minutes** to complete


# How to destroy the sandbox environment
3) Execute `$ terraform destroy` and type "yes" when asked to proceed with the infrastructure desctruction - the whole process will take about **30 seconds** to complete