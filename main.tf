terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "test-instance" {
  ami= data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  tags = {
      Name = "test-instance"
      Environment = "Dev"
  }
  key_name = "terraform_conn"
  security_groups = [aws_security_group.new_ssh_connection.name]
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.private_key)
      host = self.public_ip
    }

    inline = [
      "echo 'wait until ssh is ready'",
      "sudo apt update && sudo apt upgrade -y",
      "sudo apt install python3  -y"
    ]
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${aws_instance.test-instance.public_ip}, --private-key ${var.private_key} playbook.yml -e 'ansible_python_interpreter=/usr/bin/python3'" 
  }

  //provisioner "local-exec" {
  //  command =  "ssh -i ${var.private_key} ubuntu@${aws_instance.test-instance.public_ip} docker run fabz/mascotas_api:${var.build_number}"
  //}
}

resource "aws_security_group" "new_ssh_connection" {
   name = var.security_group
   dynamic "ingress" {
     for_each = var.ingress_rules
     content {
       from_port = ingress.value.from_port
       to_port = ingress.value.to_port
       protocol = ingress.value.protocol
       cidr_blocks = ingress.value.cidr_blocks
     }
   }

   dynamic "egress" {
     for_each = var.egress_rules
     content {
       from_port = egress.value.from_port
       to_port = egress.value.to_port
       protocol = egress.value.protocol
       cidr_blocks = egress.value.cidr_blocks
     }
   }
}

output "aws_machine_ip" {
  value = aws_instance.test-instance.public_ip
}