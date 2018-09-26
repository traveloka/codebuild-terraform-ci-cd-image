#!/bin/bash
# Do Terraform Plan on TF_WORKING_DIR and store it on artifact folder

mkdir -p artifact
if [ "$TF_WORKING_DIR" != "" ]; then
    cd $TF_WORKING_DIR
    terraform init -no-color
    terraform plan -out=${OLDPWD}/artifact/terraform.tfplan -no-color
    cd -
fi
