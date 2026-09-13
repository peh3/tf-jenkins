

# --- Security Groups ---

# 1. Security Group for Jenkins Server
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-controller-sg"
  description = "Allows SSH, UI access, and webhook triggers"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Jenkins UI & GitHub Webhooks"
    from_port   = 8080
    to_port     = 8080
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
    Name = "jenkins-controller-sg"
  }
}

# 2. Security Group for Target Deployment Node
resource "aws_security_group" "target_sg" {
  name        = "deployment-target-sg"
  description = "Allows SSH from Jenkins and public traffic to the container app"
  vpc_id      = aws_vpc.demo_vpc.id

  # SSH from your IP
  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # SSH strictly from Jenkins controller
  ingress {
    description     = "SSH from Jenkins server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_sg.id]
  }

  # App Traffic
  ingress {
    description = "Application Port"
    from_port   = 3000
    to_port     = 3000
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
    Name = "deployment-target-sg"
  }
}