#!/bin/bash
# Do Terraform Apply based on TF_WORKING_DIR and set TF_WORKING_DIR env var

set -e

CD_PWD=$PWD

cd artifact
echo "metadata.json"
cat metadata.json

# Set TF_WORKING_DIR env var from metadata.json
TF_WORKING_DIR="$(cat metadata.json | jq -r '.TF_WORKING_DIR')"
CI_PWD="$(cat metadata.json | jq -r '.CI_PWD')"

# https://github.com/hashicorp/terraform/blob/master/website/guides/running-terraform-in-automation.html.md#plan-and-apply-on-different-machines
# https://github.com/hashicorp/terraform/issues/8204
# Before running apply, obtain the archive created in the previous step and extract it at the same absolute path. 
mkdir -p $CI_PWD
cp -rf * $CI_PWD
cd $CI_PWD

if [ "$TF_WORKING_DIR" != "" ]; then
    cd $TF_WORKING_DIR

    # Do Terraform Apply from terraform.tfplan
    terraform init -no-color
    terraform apply ${OLDPWD}/terraform.tfplan -no-color | tee ${CD_PWD}/apply_output.txt

    rm -rf .terraform
    cd -
fi


cd $CD_PWD
