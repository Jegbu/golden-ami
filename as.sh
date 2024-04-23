#! /bin/bash

#Terraform
echo "Initalizing Terraform"
terraform init
echo "Applying Terraform configuration"
terraform apply -auto-approve

# Packer
echo "Running Packer build! Please be patient!"
cd packer # Change directory to packer
packer build -var 'clean_resource_name=ami-0ce315e06ff440e6c' ami.json