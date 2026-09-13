---

### 2. Infrastructure Repository: `terraform-jenkins-demo`

Place this in the repository where your Terraform configuration files (`main.tf`, `variables.tf`, `outputs.tf`) reside.

```markdown
# AWS CI/CD Infrastructure with Terraform

This Terraform project provisions a secure, segregated AWS infrastructure for Jenkins CI/CD on Amazon Linux 2023 (`t3.micro` instances).

---

## 🏗️ Infrastructure Architecture

- **VPC & Subnet:** Dedicated VPC (`10.0.0.0/16`) with an Internet Gateway and public subnet (`10.0.1.0/24`).
- **Jenkins Controller (`t3.micro`):**
  - Amazon Linux 2023 with 2GB swap configured for JVM stability.
  - Java 21 Amazon Corretto, Git, Docker, and Jenkins CI controller installed via `user_data`.
  - Exposes port `8080` (Jenkins UI & GitHub Webhook).
- **Deployment Target Node (`t3.micro`):**
  - Amazon Linux 2023 with 2GB swap.
  - Docker daemon enabled with `ec2-user` permissions.
  - Exposes port `3000` (Node.js application) and port `22` (strictly from Jenkins SG and Admin IP).

---

## 📂 File Structure

```text
.
├── main.tf        # VPC, subnets, security groups, and EC2 definitions
├── variables.tf   # Configurable inputs (region, instance type, key name, IP)
├── outputs.tf     # Public/private IPs, web URLs, and SSH commands
└── README.md      # Infrastructure guide
