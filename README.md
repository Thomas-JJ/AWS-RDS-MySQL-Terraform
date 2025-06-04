# 🚀 AWS RDS MySQL with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://mysql.com)

> A production-ready Terraform configuration for deploying AWS RDS MySQL instance with AWS Secrets Manager integration, optimized for AWS Free Tier usage.

## ✨ Features

- 🎯 **Free Tier Optimized** - Configured for AWS Free Tier eligibility
- 🔐 **Secure Credentials** - Automatic password generation and AWS Secrets Manager integration
- 🌐 **Default VPC Ready** - Uses existing default VPC and subnets
- 📊 **Cost Optimized** - Minimal configuration to reduce costs
- 🏷️ **Well Tagged** - Consistent tagging strategy for resource management
- 🔧 **Configurable** - Easy customization through variables

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Application   │────│  Security Group  │────│   RDS MySQL     │
│   (Your App)    │    │   (Port 3306)    │    │  (db.t3.micro)  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │ AWS Secrets      │
                       │ Manager          │
                       │ (Credentials)    │
                       └──────────────────┘
```

## 📋 Prerequisites

- [Terraform](https://terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with Free Tier eligibility (recommended)

## 🚀 Quick Start

1. **Clone this repository**
   ```bash
   git clone https://github.com/Thomas-JJ/AWS-RDS-MySQL-Terraform.git
   cd AWS-RDS-MySQL-Terraform
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the plan**
   ```bash
   terraform plan
   ```

4. **Deploy the infrastructure**
   ```bash
   terraform apply
   ```

5. **Get your database connection details**
   ```bash
   terraform output
   ```

## ⚙️ Configuration

### Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `aws_region` | AWS region for deployment | `string` | `us-east-2` |
| `db_name` | Database name | `string` | `mydb` |
| `db_username` | Database master username | `string` | `admin` |

### Customization

Create a `terraform.tfvars` file to customize your deployment:

```hcl
aws_region  = "us-west-2"
db_name     = "production_db"
db_username = "dbadmin"
```

## 📤 Outputs

After successful deployment, you'll get:

- **RDS Endpoint** - Connection endpoint for your database
- **Database Port** - MySQL port (3306)
- **Database Name** - Name of the created database
- **Secrets Manager ARN** - ARN of the secret containing credentials

## 🔐 Security Features

- **Random Password Generation** - 16-character secure password
- **AWS Secrets Manager** - Centralized credential storage
- **Security Group** - Controlled network access
- **Encryption Ready** - Easy to enable for production use

## ⚠️ Security Considerations

> **Important**: This configuration is optimized for development and learning purposes.

For **production use**, consider:

- [ ] Restricting security group access to specific IP ranges
- [ ] Enabling encryption at rest
- [ ] Setting up automated backups
- [ ] Enabling Multi-AZ deployment
- [ ] Using private subnets
- [ ] Implementing least-privilege IAM policies

## 💰 Cost Optimization

This configuration is designed for AWS Free Tier:

- **Instance Type**: `db.t3.micro` (Free Tier eligible)
- **Storage**: 20GB GP2 (Free Tier includes 20GB)
- **Backups**: Disabled to avoid charges
- **Monitoring**: Basic monitoring only
- **Multi-AZ**: Disabled to reduce costs

## 🛠️ Connecting to Your Database

### Using MySQL Client

```bash
# Get the endpoint from Terraform output
RDS_ENDPOINT=$(terraform output -raw rds_endpoint)

# Get credentials from AWS Secrets Manager
aws secretsmanager get-secret-value \
  --secret-id rds-mysql-master-credentials \
  --query SecretString --output text

# Connect using MySQL client
mysql -h $RDS_ENDPOINT -P 3306 -u admin -p
```

### Using Application Connection String

```
mysql://admin:<password>@<rds-endpoint>:3306/mydb
```

## 🧹 Cleanup

To avoid ongoing charges, destroy the infrastructure when done:

```bash
terraform destroy
```

## 📁 Project Structure

```
.
├── main.tf              # Main Terraform configuration
├── terraform.tfvars    # Variable values (create this)
├── .gitignore          # Git ignore patterns
└── README.md           # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 💡 Common Issues

### "Repository not found" Error
Make sure your Git remote URL is correct:
```bash
git remote -v
git remote set-url origin https://github.com/yourusername/your-repo-name.git
```

### AWS Credentials
Ensure your AWS CLI is configured:
```bash
aws configure
```

### Free Tier Limits
Monitor your AWS usage to stay within Free Tier limits.

## 📚 Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [AWS Free Tier Details](https://aws.amazon.com/free/)
- [MySQL Documentation](https://dev.mysql.com/doc/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <strong>⭐ If this helped you, please give it a star! ⭐</strong>
</div>
