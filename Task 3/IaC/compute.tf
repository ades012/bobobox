resource "aws_key_pair" "deployer" {
  key_name   = "bobobox-key"
  public_key = file("~/.ssh/delz.pem.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "bobobox-web-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
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
    Name = "bobobox-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.deployer.key_name

 user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx prometheus-node-exporter
              
              echo "<h1>Hello, OpenTofu!</h1>" > /var/www/html/index.html
              
              sed -i 's/worker_connections 768;/worker_connections 1024; use epoll; multi_accept on;/' /etc/nginx/nginx.conf
              sed -i 's/keepalive_timeout 65;/keepalive_timeout 15;/' /etc/nginx/nginx.conf
              
              systemctl restart nginx
              systemctl enable nginx
              systemctl enable prometheus-node-exporter
              EOF

  tags = {
    Name = "bobobox-app-server"
  }
}