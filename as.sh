#! /bin/bash

#Terraform
echo "Initalizing Terraform"
terraform init
echo "Applying Terraform configuration"
terraform apply -auto-approve

# Check if Terraform apply was successful
if [ $? -eq 0 ]; then
    echo "Terraform apply was successful. Proceeding with Packer build."
else
    echo "Error: Terraform apply failed. Exiting script."
    exit 1
fi

#Retrieve security group ID from Terraform output
security_group_id=$(terraform output -raw security_group_id)

 Check if security group ID is empty
if [ -z "$security_group_id" ]; then
    echo "Error: Security group ID is empty. Exiting script."
    exit 1
fi

echo "Security group ID retrieved: $security_group_id"

# Packer
echo "Running Packer build! Please be patient!"
cd packer # Change directory to packer
packer build -var 'clean_resource_name=amazon-linux-ami' ami.json

# Pass security group ID as a variable to Packer
packer build -var "security_group_id=$security_group_id" -var 'clean_resource_name=amazon-linux-ami' ami.json

# Check if Packer build was successful
if [ $? -eq 0 ]; then
    echo "Packer build completed successfully! Now destroying Terraform resources."
    cd ..
    terraform destroy -auto-approve