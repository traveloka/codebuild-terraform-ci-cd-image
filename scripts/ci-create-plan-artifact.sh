#!/bin/bash

set -ex
CURRENT_DIR="$(dirname "$0")"
. ${CURRENT_DIR}/00_trap.sh

# Create Plan Artifact
# Copy Terraform working directory
mkdir -p artifact/${TF_WORKING_DIR}
if [ "$TF_WORKING_DIR" != "" ]; then
    cp -r ${TF_WORKING_DIR}/* artifact/${TF_WORKING_DIR}
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
