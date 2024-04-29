#!/bin/bash

# Deploy VPC with Terraform
cd vpc
echo "Initializing Terraform"
terraform init
echo "Applying Terraform configuration"
terraform apply -auto-approve
cd ..

# Check if Terraform apply was successful
if [ $? -ne 0 ]; then
    echo "Error: Terraform apply failed. Exiting script."
    exit 1
fi

# Retrieve security group ID from Terraform output
security_group_id=$(terraform output -raw security_group_id)

# Check if security group ID is empty
if [ -z "$security_group_id" ]; then
    echo "Error: Security group ID is empty. Exiting script."
    exit 1
fi

echo "Security group ID retrieved: $security_group_id"

# Fetch VPC ID using AWS CLI
echo "Fetching VPC ID for jegbu_vpc"
vpc_id=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=jegbu_vpc" --query 'Vpcs[0].VpcId' --output text)

# Check if VPC ID is empty
if [ -z "$vpc_id" ]; then
    echo "Error: VPC ID not found for jegbu_vpc. Exiting script."
    exit 1
fi

echo "VPC ID retrieved: $vpc_id"

# Fetching subnet ID for "Public Subnet AZ1" in "jegbu_vpc"
echo "Fetching Subnet ID for Public Subnet AZ1 in jegbu_vpc"
subnet_id=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" "Name=tag:Name,Values=Public Subnet AZ1" --query "Subnets[0].SubnetId" --output text)

# Check if Subnet ID is empty
if [ -z "$subnet_id" ]; then
    echo "Error: Subnet ID not found for Public Subnet AZ1 in jegbu_vpc. Exiting script."
    exit 1
fi

echo "Subnet ID for Public Subnet AZ1 in jegbu_vpc retrieved: $subnet_id"

# Packer
echo "Running Packer build! Please be patient!"
cd packer || exit # Change directory to packer

# Build the AMI with Packer
build_output=$(packer build -machine-readable ami.json)

# Pass security group ID and subnet ID as variables to Packer
packer build -var "security_group_id=$security_group_id" -var "subnet_id=$subnet_id" -var 'clean_resource_name=amazon-linux-ami' ami.json

# Check if Packer build was successful
if [ $? -ne 0 ]; then
    echo "Error: Packer build has failed. Exiting script."
    exit 1
fi

# Retrieve AMI ID from Packer's output
# ami_id=$(echo "$build_output" | grep -oE 'ami-[a-zA-Z0-9]{17}')

# echo "AMI ID after retrieval: $ami_id"

# Check if AMI ID is empty
# if [ -z "$ami_id" ]; then
  #  echo "Error: AMI ID is empty. Exiting script."
   # exit 1
# fi

echo "AMI ID created: $ami_id"

# Deloy ec2 instance with Terraform
#cd ec2
echo "Initializing Terraform"
terraform init
echo "Applying Terraform configuration"
terraform apply -auto-approve
cd ..

# Use AMI ID for EC2 instance creation
# aws ec2 run-instances --image-id "$ami_id" --count 1 --instance-type t2.micro --key-name myec2key --security-group-ids "$security_group_id" --subnet-id "$subnet_id" --associate-public-ip-address

# Check if EC2 instance creation was successful
if [ $? -ne 0 ]; then
    echo "Error: EC2 instance creation failed! :("
    exit 1
fi

echo "EC2 instance created successfully! Good to go! :)"
