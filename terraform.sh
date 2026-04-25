#!/bin/bash

set -e

echo "Installing dependencies..."
sudo apt update -y
sudo apt install -y curl unzip

echo "Fetching latest Terraform version..."
LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | grep -oP '"current_version":\s*"\K[^"]+')

echo "Latest version is: $LATEST"

echo "Downloading Terraform..."
curl -LO https://releases.hashicorp.com/terraform/${LATEST}/terraform_${LATEST}_linux_amd64.zip

echo "Unzipping..."
unzip terraform_${LATEST}_linux_amd64.zip

echo "Installing Terraform..."
sudo mv terraform /usr/local/bin/

echo "Cleaning up..."
rm terraform_${LATEST}_linux_amd64.zip

echo "Verifying installation..."
terraform -version

echo "Terraform installed successfully!"
