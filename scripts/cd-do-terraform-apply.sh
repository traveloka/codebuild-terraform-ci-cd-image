#!/bin/bash
# Do Terraform Apply based on TF_WORKING_DIR and set TF_WORKING_DIR env var

set -e

CD_PWD=$PWD

cd artifact
echo "metadata.json"
cat metadata.json

# Set TF_WORKING_DIR env var from metadata.json
export TF_WORKING_DIR="$(cat metadata.json | jq -r '.TF_WORKING_DIR')"
CI_PWD="$(cat metadata.json | jq -r '.CI_PWD')"

if [ "$TF_WORKING_DIR" != "" ]; then
	ls -la

	echo "sed -i s:$CI_PWD:$CD_PWD:g terraform.tfplan"

	# https://github.com/hashicorp/terraform/issues/8204
    # https://github.com/hashicorp/terraform/issues/7613
    # We need to correct the absolute paths in the tfplan first
    sed -i -e "s:$CI_PWD:$CD_PWD:g" terraform.tfplan

	ls -la

    cd $TF_WORKING_DIR

    # Do Terraform Apply from terraform.tfplan
    terraform init -no-color
    terraform apply ${OLDPWD}/terraform.tfplan -no-color

    rm -rf .terraform
    cd -
fi
cd ..
