#! /bin/bash

#Terraform
echo "Initalizing Terraform"
terraform init
echo "Applying Terraform configuration"
terraform apply -auto-approve