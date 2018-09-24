#!/bin/bash
# Install Terraform with specific version
# Input:
# ${1} Teraform version

wget -q https://releases.hashicorp.com/terraform/${1}/terraform_${1}_linux_amd64.zip
unzip terraform_${1}_linux_amd64.zip -d /usr/local/bin
rm terraform_${1}_linux_amd64.zip
