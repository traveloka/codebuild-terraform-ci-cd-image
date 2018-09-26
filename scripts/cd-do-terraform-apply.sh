#!/bin/bash
# Do Terraform Apply based on TF_WORKING_DIR and set TF_WORKING_DIR env var

cd artifact
echo "metadata.json"
cat metadata.json

# Set TF_WORKING_DIR env var from metadata.json
export TF_WORKING_DIR="$(cat metadata.json | jq -r '.TF_WORKING_DIR')"

if [ "$TF_WORKING_DIR" != "" ]; then
    cd $TF_WORKING_DIR
    # Do Terraform Apply from terraform.tfplan
    terraform init -no-color
    terraform apply ${OLDPWD}/terraform.tfplan -no-color

    rm -rf .terraform
    cd -
fi
cd ..
