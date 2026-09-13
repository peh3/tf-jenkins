variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Existing AWS SSH Key Pair name"
  type        = string
}

variable "my_ip" {
  description = "Your IP address for SSH and Jenkins access (e.g., 203.0.113.25/32)"
  type        = string
  default     = "0.0.0.0/0"
}