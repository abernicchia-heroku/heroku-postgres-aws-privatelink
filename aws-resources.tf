//
// AWS resources setup
//
resource "aws_vpc" "default" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true #provides internal host name

  tags = {
    Name = format("%s-%s", var.name, "vpc")
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.2.0.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet - use false to make it private

  tags = {
    Name = format("%s-%s", var.name, "public")
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = format("%s-%s", var.name, "igtw")
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = format("%s-%s", var.name, "public-routes")
  }
}

//route table uses this internet gateway to reach internet
resource "aws_route" "internet_gateway" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.public.id
}


resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_main_route_table_association" "public" {
  vpc_id         = aws_vpc.default.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "pg-allowed" {
    vpc_id = aws_vpc.default.id
    name = format("%s-%s", var.name, "pg-sg")

    // postgres
    ingress {
      from_port = 5432
      to_port = 5433
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = format("%s-%s", var.name, "pg-sg")
    }
}

resource "aws_security_group" "ssh-allowed" {
    vpc_id = aws_vpc.default.id
    name = format("%s-%s", var.name, "ssh-sg")

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    // ssh
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Don't do it in production
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
    	Name = format("%s-%s", var.name, "ssh-sg")
    }
}

resource "aws_vpc_endpoint" "heroku-pg-privatelink" {
    vpc_id       = aws_vpc.default.id
    service_name = file("${heroku_addon.private_postgres_example.name}.txt")
    vpc_endpoint_type = "Interface" 
    subnet_ids = [ "${aws_subnet.public.id}" ]
    security_group_ids = [ "${aws_security_group.pg-allowed.id}" ]  

    depends_on = [ null_resource.private_postgres_endpoint_service ] // the aws_vpc_endpoint cannot be created until the heroku endpoint service is not available
}

resource "aws_instance" "ubuntu-ec2" {
    ami = var.aws-ami
    instance_type = "t2.micro"

    # VPC
    subnet_id = aws_subnet.public.id

    # Security Group
    vpc_security_group_ids = [ "${aws_security_group.ssh-allowed.id}" ]

    # Add a public ip address
    associate_public_ip_address = true

    # the Public SSH key
    key_name = aws_key_pair.ec2-key-pair.id


    # postgresql installation
    provisioner "remote-exec" {
        inline = [
             "sudo apt-get -qq update && sudo apt-get install -y curl ca-certificates",
             "curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -",
             "sudo sh -c 'echo \"deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main\" > /etc/apt/sources.list.d/pgdg.list'",
             "sudo apt-get -qq update",
             "sudo apt-get install -y postgresql-client-10"
        ]

        connection {
            user = var.ec2_user
            private_key = file(var.ssh_private_key_filepath)
            host = self.public_ip
        }
    }
}

// public key for ec2 instance
resource "aws_key_pair" "ec2-key-pair" {
    key_name = format("%s-%s", var.name, "ec2-key-pair")
    public_key = var.ssh_public_key
}





















