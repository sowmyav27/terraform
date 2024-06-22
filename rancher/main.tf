provider "aws" {
  region = var.region
}

resource "aws_instance" "rancher_server" {
  ami           = var.aws_ami
  instance_type = var.instance_type

  tags = {
    Name = "SowmyaRancherServerNew"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo service docker start
              sudo usermod -aG docker ec2-user
              sudo docker run -d --privileged --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:latest
              EOF
}

output "instance_ip" {
  value = aws_instance.rancher_server.public_ip
}
