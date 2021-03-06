#!/bin/bash
set -e
. /usr/local/bin/00_trap.sh

# Create Plan Artifact
# Copy Terraform working directory
mkdir -p artifact/${TF_WORKING_DIR}
if [ "$TF_WORKING_DIR" != "" ]; then
    cp -r ${TF_WORKING_DIR}/* artifact/${TF_WORKING_DIR}
    [[ -f ${TF_WORKING_DIR}/.terraform-version ]] && cp ${TF_WORKING_DIR}/.terraform-version artifact/${TF_WORKING_DIR}
fi
# Create metadata.json file
jq -n "{
    PR_ID: \"$PR_ID\",
    SKIP_CICD: \"$SKIP_CICD\",
    GIT_MASTER_COMMIT_ID: \"$GIT_MASTER_COMMIT_ID\",
    TF_WORKING_DIR: \"$TF_WORKING_DIR\",
    CI_PWD: \"$PWD\"
}" > artifact/metadata.json

# Zip artifact folder
cd artifact
zip -r ../${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip .
cd ..
