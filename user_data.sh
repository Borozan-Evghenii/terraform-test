#!/bin/bash
set -e

# Update system
yum update -y

# Install AWS CLI (if not present)
if ! command -v aws &> /dev/null; then
    yum install -y aws-cli
fi

# Install PostgreSQL client
yum install -y postgresql15

# Create app directory
mkdir -p /opt/app

# Example: Retrieve database credentials from Secrets Manager
# Your application can use this pattern to get credentials
cat > /opt/app/get_db_credentials.sh << 'SCRIPT'
#!/bin/bash
aws secretsmanager get-secret-value \
    --secret-id ${secret_arn} \
    --region ${aws_region} \
    --query SecretString \
    --output text
SCRIPT

chmod +x /opt/app/get_db_credentials.sh

# Log completion
echo "User data script completed at $(date)" >> /var/log/user-data.log
