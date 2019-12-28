//
// Heroku resources setup
//
resource "heroku_space" "example" {
  name         = var.heroku_private_space
  organization = var.heroku_enterprise_team
  region       = lookup(var.aws_to_heroku_private_region, var.aws_region)
}

resource "heroku_app" "example" {
  name   = var.app_name

  organization {
    name = var.heroku_enterprise_team
  }

  space  = heroku_space.example.name
  region = lookup(var.aws_to_heroku_private_region, var.aws_region)
}

resource "heroku_addon" "private_postgres_example" {
  app  = heroku_app.example.name
  plan = "heroku-postgresql:private-0"
}

resource "null_resource" "private_postgres_endpoint_service" { 

  // the following provisioners are executed sequentially
  provisioner "local-exec" {
    command = "heroku data:privatelink:create ${heroku_addon.private_postgres_example.name} --aws-account-id ${var.aws_account_id} --app ${var.app_name}"
  }

  provisioner "local-exec" {
    command = "heroku data:privatelink:wait ${heroku_addon.private_postgres_example.name} --app ${var.app_name}"
  }

  provisioner "local-exec" {
    command = "heroku data:privatelink ${heroku_addon.private_postgres_example.name} --app ${var.app_name} | grep \"Service Name:\" | cut -d : -f 2 - | tr -d \"[:space:]\" > ${heroku_addon.private_postgres_example.name}.txt"
  }

  // it takes a bit of time to have the Postgres Endpoint Service visible to the AWS API, then waiting for a bunch of seconds 
  provisioner "local-exec" {
    command = "sleep 30"
  }

  // to ensure provisioners are executed once the postgres addon has been created.
  // Inside the heroku_addon.private_postgres_example they were executed while the resource was in progress to be created
  depends_on = [ heroku_addon.private_postgres_example ] 
}
