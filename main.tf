terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}


provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}


resource "aws_instance" "web-server" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test.id]
  user_data              = "${file("ssh_key.sh")}"
  tags = {
    Name = "WebServer"
  }
}

resource "aws_instance" "zabbix-server" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test.id]
  user_data              = "${file("ssh_key.sh")}"
  tags = {
    Name = "ZabbixServer"
  }
}

resource "aws_instance" "prometheus" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test.id]
  user_data              = "${file("ssh_key.sh")}"
  tags = {
    Name = "Prometheus"
  }
}



resource "aws_security_group" "test" {
  name        = "test"
  description = "test security group"
  vpc_id      = "vpc-2f274b45"
}

resource "aws_security_group_rule" "allow_all_in" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"] 
  security_group_id = aws_security_group.test.id
}

resource "aws_security_group_rule" "allow_all_out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.test.id
}


