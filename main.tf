# --- Instances ---

# 1. Jenkins Controller Instance
resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = var.ssh_key_name != "" ? var.ssh_key_name : null

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # 2GB Swap setup
              fallocate -l 2G /swapfile
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile none swap sw 0 0' >> /etc/fstab

              # Prerequisites and Jenkins repo
              dnf update -y
              dnf install -y wget git java-21-amazon-corretto docker
              systemctl enable --now docker

              wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              dnf install -y jenkins

              usermod -aG docker jenkins
              usermod -aG docker ec2-user

              # 6. Setup custom temp directory to prevent disk-space monitor threshold warnings
              mkdir -p /var/lib/jenkins/tmp
              chown -R jenkins:jenkins /var/lib/jenkins/tmp

              # 7. Create systemd override for Java 21 path, heap limits, and tempdir
              mkdir -p /etc/systemd/system/jenkins.service.d
              cat <<'OVERRIDE' > /etc/systemd/system/jenkins.service.d/override.conf
              [Service]
              Environment="JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto"
              Environment="JAVA_OPTS=-Djava.awt.headless=true -Xms128m -Xmx512m -Djava.io.tmpdir=/var/lib/jenkins/tmp"
              OVERRIDE

              # 8. Reload systemd, enable and launch Jenkins
              systemctl daemon-reload
              systemctl enable --now jenkins
              systemctl restart docker
              EOF

  tags = {
    Name = "Jenkins-Controller"
  }
}

# 2. Target EC2 Deployment Node
resource "aws_instance" "target_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.target_sg.id]
  key_name               = var.ssh_key_name != "" ? var.ssh_key_name : null

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # 2GB Swap setup
              fallocate -l 2G /swapfile
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile none swap sw 0 0' >> /etc/fstab

              # Install Docker only
              dnf update -y
              dnf install -y docker
              systemctl enable --now docker

              # Grant ec2-user permissions to run docker without sudo
              usermod -aG docker ec2-user
              systemctl restart docker
              EOF

  tags = {
    Name = "Deployment-Target-Node"
  }
}