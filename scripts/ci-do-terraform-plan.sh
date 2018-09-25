#!/bin/bash
# Do Terraform Plan on TF_WORKING_DIR and store it on artifact folder

mkdir -p artifact
terraform init $TF_WORKING_DIR -no-color
terraform plan -out=artifact/terraform.tfplan $TF_WORKING_DIR -no-color
