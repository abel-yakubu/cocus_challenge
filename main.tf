provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key  
  region = var.region
}

resource "aws_vpc" "awslab_vpc" {
  cidr_block = "172.16.0.0/23"
  tags = {
    Name = "awslab-vpc"
  }
}

resource "aws_subnet" "awslab_subnet_public" {
  vpc_id            = aws_vpc.awslab_vpc.id
  cidr_block        = "172.16.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
  tags = {
    Name = "awslab-subnet-public"
  }
}

resource "aws_subnet" "awslab_subnet_private" {
  vpc_id            = aws_vpc.awslab_vpc.id
  cidr_block        = "172.16.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-west-2b"
  tags = {
    Name = "awslab-subnet-private"
  }
}


resource "aws_internet_gateway" "awslab-igw" {
  vpc_id = aws_vpc.awslab_vpc.id

  tags = {
    Name = "awslab-igw"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.awslab_subnet_public.id
  route_table_id = aws_vpc.awslab_vpc.default_route_table_id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.awslab_subnet_private.id
  route_table_id = aws_vpc.awslab_vpc.default_route_table_id
}


resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.awslab_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.awslab-igw.id
}

resource "aws_security_group" "awslab_public_security_group" {
  name        = "awslab-public-security-group"
  description = "Allow HTTP access"
  vpc_id      = aws_vpc.awslab_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }

  # ingress {
  #   from_port = 0
  #   to_port   = 65535
  #   protocol  = "icmp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  
}

resource "aws_security_group" "awslab_private_security_group" {
  name        = "awslab-private-security-group"
  description = "Allow access from public subnet"
  vpc_id      = aws_vpc.awslab_vpc.id

   ingress {
    from_port   = 3110
    to_port     = 3110
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/24"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "icmp"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/24"]
  }
}

resource "aws_instance" "awslab_webserver" {
  ami           = "ami-06e85d4c3149db26a"
  instance_type = var.instance_type
  key_name      = "webserver"
  subnet_id     = aws_subnet.awslab_subnet_public.id
  vpc_security_group_ids = [aws_security_group.awslab_public_security_group.id]
  tags = {
    Name = "awslab-webserver"
  }
  root_block_device {
    volume_size = 8
  }
}


resource "aws_instance" "awslab_db_server" {
  ami           = "ami-06e85d4c3149db26a"
  instance_type = var.instance_type
  key_name      = "db_server"
  subnet_id     = aws_subnet.awslab_subnet_private.id
  vpc_security_group_ids = [aws_security_group.awslab_private_security_group.id]
  tags = {
    Name = "awslab-db-server"
  }
  root_block_device {
    volume_size = 8
  }
}