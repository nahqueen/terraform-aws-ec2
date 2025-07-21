provider "aws" {
  region = "us-west-1"  # Change to your preferred AWS region
}

# Define a variable for the SSH public key
variable "ssh_public_key" {
  description = "Public key for SSH access"
  type        = string
}

# Create a key pair to SSH into the instance
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = var.ssh_public_key
}

# Security group allowing SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # For public access; use your IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "example" {
  count                  = 3
  ami                    = "ami-0a0409af1cb831414"  # Amazon Linux 2 in us-west-1 (updated AMI)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "MyEC2Instance-${count.index + 1}"
  }
}

# Output the public IPs of the instances
output "instance_public_ips" {
  value = aws_instance.example[*].public_ip
}