#!/bin/bash
# Do Terraform Apply based on TF_WORKING_DIR and set TF_WORKING_DIR env var

set -e
. /usr/local/bin/00_trap.sh

CD_PWD=$PWD

# Exit when artifact directory is not exist
test -d artifact || exit 0

cd artifact
echo "metadata.json"
cat metadata.json

export SKIP_CICD="$(cat metadata.json | jq -r '.SKIP_CICD')"
if [ $SKIP_CICD -eq 1 ]; then
  echo "Skipping this step"
  exit 0
fi

# Set TF_WORKING_DIR env var from metadata.json
export TF_WORKING_DIR="$(cat metadata.json | jq -r '.TF_WORKING_DIR')"
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
    # Save terraform apply stdout and stderr to temporary files
    # we need "bash" since codebuild will use "sh" as runtime
    # Update : https://aws.amazon.com/about-aws/whats-new/2020/06/aws-codebuild-now-supports-additional-shell-environments/
    terraform init -no-color
    terraform apply ${OLDPWD}/terraform.tfplan -no-color > >(tee -a /tmp/tfApplyOutput) 2> >(tee -a /tmp/errMsg.log >&2)
    rm -rf .terraform
    cd -
fi

cd $CD_PWD