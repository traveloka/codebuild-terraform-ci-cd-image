#!/bin/bash
set -e
. /usr/local/bin/00_trap.sh

# CODEBUILD_BUILD_SUCCEEDING: Whether the current build is succeeding. Set to 0 if the build is failing, or 1 if the build is succeeding.
# invert CODEBUILD_BUILD_SUCCEEDING as exitcode
exitCode=$((1 - $CODEBUILD_BUILD_SUCCEEDING))

if [ $SKIP_CICD -eq 1 ]; then
  echo "Skipping this step"
  exit $exitCode
fi

# Do Terraform Plan on TF_WORKING_DIR and store it on artifact folder
echo "Working dir : $TF_WORKING_DIR"
mkdir -p artifact
if [ "$TF_WORKING_DIR" != "" ]; then
    cd $TF_WORKING_DIR
    terraform init -no-color 2> /tmp/errMsg.log
    terraform plan -out=terraform.tfplan -no-color 2> /tmp/errMsg.log
    cd -
fi