# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

# Generate a random password for the database
resource "random_password" "master_password" {
  length  = 16
  special = true
}

# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "rds-mysql-master-credentials"
  description             = "Master credentials for MySQL RDS instance"
  recovery_window_in_days = 0 # Immediate deletion for dev environment

  tags = {
    Name        = "RDS MySQL Credentials"
    Environment = "development"
    Terraform   = "true"
  }
}

# Store the credentials in the secret
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.master_password.result
  })
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create DB subnet group using default subnets
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "MySQL DB subnet group"
  }
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-mysql-sg"
  vpc_id      = data.aws_vpc.default.id

  # MySQL port access (restrict this to your IP in production)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: This allows access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS MySQL Security Group"
  }
}

# RDS MySQL instance optimized for free tier
resource "aws_db_instance" "mysql" {
  # Basic configuration
  identifier = "mysql-free-tier"
  
  # Engine configuration
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"  # Free tier eligible
  
  # Storage configuration (free tier limits)
  allocated_storage     = 20    # Free tier includes 20GB
  max_allocated_storage = 20    # Disable autoscaling by setting same as allocated
  storage_type          = "gp2" # General Purpose SSD
  storage_encrypted     = false # Encryption not available in free tier
  
  # Database configuration
  db_name  = var.db_name
  username = var.db_username
  password = random_password.master_password.result
  port     = 3306
  
  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = true # Set to false for production
  
  # Backup configuration (minimal for cost savings)
  backup_retention_period = 0    # Disable automated backups to save cost
  backup_window          = null
  maintenance_window     = "sun:03:00-sun:04:00"
  
  # Performance and monitoring (disabled for cost savings)
  performance_insights_enabled = false
  monitoring_interval         = 0
  
  # High availability (disabled for cost savings)
  multi_az = false
  
  # Deletion protection and final snapshot
  deletion_protection       = false
  skip_final_snapshot      = true
  delete_automated_backups = true
  
  # Parameter group (use default)
  parameter_group_name = "default.mysql8.0"
  
  # Tags
  tags = {
    Name        = "MySQL Free Tier"
    Environment = "development"
    Terraform   = "true"
  }

}

# Remove the locals block since we're using PowerShell directly


# Outputs
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.mysql.port
}

output "database_name" {
  description = "Database name"
  value       = aws_db_instance.mysql.db_name
}

output "database_username" {
  description = "Database master username"
  value       = aws_db_instance.mysql.username
  sensitive   = true
}

output "secrets_manager_secret_name" {
  description = "Name of the Secrets Manager secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.name
}

output "secrets_manager_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}



