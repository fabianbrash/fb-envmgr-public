resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"  # Specify the desired AZ here

  map_public_ip_on_launch = true

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


#resource "aws_key_pair" "deployer" {
  #key_name   = "id_rsa"
  #public_key = file("${path.module}/id_rsa.pub")
#}



resource "aws_instance" "example_ec2" {
  ami           = "ami-08116b9957a259459" # Replace with the actual AMI ID for Ubuntu 22.04 in your region
  #m7a.2xlarge 8x32 12.5Gbps
  #m7g.2xlarge 8x32 15Gbps
  #m7g.4xlarge 16x64 15Gbps
  #m6a.2xlarge 8x32 12.5Gbps
  #m6a.4xlarge 16x64 12.5Gbps
  #m6g.12xlarge 48x192 20Gbps
  #instance_type = "t2.2xlarge"
  #instance_type = "g4ad.xlarge"  4x16 1 AMD GPU
  instance_type = (var.gpu == true ? "g4ad.xlarge" : "m6a.4xlarge") # 4x30.5 1  NVIDIA GPU
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  #associate_public_ip_address = true   Request a public IP address
  
  #key_name = aws_key_pair.deployer.key_name
   user_data = file("${path.module}/user-data")
  #user_data = <<-EOF
              ##!/bin/bash
              #sudo apt-get update && sudo apt-get upgrade -y && sudo curl -fsSL https://ollama.com/install.sh | sh
              #sudo systemctl start ollama
              #sudo systemctl enable ollama
              #ollama pull llama2
              #ollama pull openchat
              #EOF
  
   root_block_device {
    volume_size           = 200
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "fb-ollama"
  }
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}

resource "aws_route_table" "example_rt" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "example-rt"
  }
}

resource "aws_route_table_association" "example_rta" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_rt.id
}
