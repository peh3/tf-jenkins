output "jenkins_url" {
  description = "URL to access the Jenkins Web UI"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

output "target_server_private_ip" {
  description = "Target node internal IP (use this inside Jenkins to communicate over VPC)"
  value       = aws_instance.target_server.private_ip
}

output "target_server_public_ip" {
  description = "Target node public IP"
  value       = aws_instance.target_server.public_ip
}

output "deployed_app_url" {
  description = "URL to access the container running on the target node"
  value       = "http://${aws_instance.target_server.public_ip}:3000"
}

output "jenkins_ssh" {
  description = "SSH to Jenkins"
  value       = "ssh ec2-user@${aws_instance.jenkins_server.public_ip}"
}

output "target_ssh" {
  description = "SSH to Target Server"
  value       = "ssh ec2-user@${aws_instance.target_server.public_ip}"
}