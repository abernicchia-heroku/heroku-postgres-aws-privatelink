# Connecting to a Private Heroku Postgres via AWS PrivateLink - Terraform files
This Repository contains a set of Terraform files to automatically create a complete sandbox environment, including both Heroku and AWS resources, to test how connecting to a Private or Shield Heroku Postgres Database via AWS PrivateLink, as described here: https://devcenter.heroku.com/articles/heroku-postgres-via-privatelink

# Prerequisites
- An Heroku Account
- An Heroku API Key (see [here](https://devcenter.heroku.com/articles/platform-api-quickstart#authentication) to create one)
- An Heroku Enterprise Team
- The [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) with the PrivateLink plugin installed
`$ heroku plugins:install data-privatelink`
- The [Terraform CLI](https://www.terraform.io/downloads.html)
- An AWS account ID (see [here](https://devcenter.heroku.com/articles/heroku-postgres-via-privatelink#step-2-obtain-your-aws-account-id) to retrieve it)
- An AWS IAM access and secret key pair (see [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html) for the Root user or [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console) to create a new IAM user for your AWS account)
- A ssh key file `$ ssh-keygen -f /Users/me/aws-ec2-integrationuser-key-pair` and its public key `$ ssh-keygen -y -f /Users/me/aws-ec2-integrationuser-key-pair`. The ssh key file must have readonly permissions to be correctly used by ssh `$ chmod 400 /Users/me/aws-ec2-integrationuser-key-pair`

# How to create the sandbox environment
1) Open a Terminal and log in via Heroku CLI. You must be logged in the Heroku CLI on the terminal used to execute the Terraform commands
2) Fill in the **vars.template.tf_** variables file and rename it to **vars.tf** `$ mv vars.template.tf_ vars.tf`
3) Execute `$ terraform apply` and type "yes" when prompted "Do you want to perform these actions?" to proceed with the infrastructure creation - the whole process will take about **20 minutes** to complete
4) When the Terraform execution correctly ends, it is possible to retrieve the EC2 hostname inspecting the Terraform state `$ terraform show | grep public_dns` (e.g. public_dns = "ec2-52-91-128-119.eu-central-1.compute.amazonaws.com")
5) Connect to the EC2 using `$ ssh -i <YOUR_PRIVATE_KEY_FILE_PATH_FOR_SSH_CONNECTION> ubuntu@<YOUR_EC2_HOSTNAME>` where <YOUR_PRIVATE_KEY_FILE_PATH_FOR_SSH_CONNECTION> is the same file path configured into the **vars.tf** file and <YOUR_EC2_HOSTNAME> is the value retrieved in the previous step. 

# How to destroy the sandbox environment
1) Execute `$ terraform destroy` and type "yes" when prompted "Do you want to perform these actions?" to proceed with the infrastructure desctruction - the whole process will take about **30 seconds** to complete

# Created resources
When the `$ Terraform apply` has been succesfully executed, the following resources are created:

| Resource                    | Notes         |
| --------------------------- | ------------- |
| Heroku App                  |               |
| Heroku Private Space        |               |
| Heroku Postgres             | Private-0 tier|
| Heroku Postgres Endpoint Service   | Created using Heroku CLI              |
| AWS VPC                     |               |
| AWS Subnet                  |               |
| AWS Internet Gateway        |               |
| AWS Route Table             |               |
| AWS Security Group          |               |
| AWS VPC Endpoint            | Interface type|
| AWS EC2                     | t2.micro      |
| AWS EC2 key pair            |               |

# Repository files

| File  | Notes |
| ------------- | ------------- |
| providers.tf  | Includes all the Terraform Providers in use |
| heroku-resources.tf  | Defines all the Heroku resources to be created |
| aws-resources.tf  | Defines all the AWS resources to be created |
| vars.template.tf_  | Template file for the Terraform variables to be defined. Once defined, it must be renamed as vars.tf file |
| graph.svg  | Terraform graph image, generated using `$ terraform graph \| dot -Tsvg > graph.svg` - it requires [graphviz](https://formulae.brew.sh/formula/graphviz#default) to be generated|
| README.md  | This README file  |

# Additional Notes
In case of issues executing Terraform, enabling the [log trace](https://www.terraform.io/docs/internals/debugging.html) (e.g. `$ export TF_LOG=TRACE`) can help understanding the problems.



