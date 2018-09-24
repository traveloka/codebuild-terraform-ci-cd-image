#!/bin/bash
# Check CI prerequisites to do Terraform commands and set env var TF_WORKING_DIR

# Check if current commit is based on latest master commit on repo
git merge-base --is-ancestor origin/master HEAD
if [ $? -ne 0 ]; then
    echo "Error: Commit isn't based on origin/master"
    exit 1
fi
# Check if latest master commit on repo and commit on current infra state on S3 bucket are equal/same
if [ $GIT_MASTER_COMMIT_ID != $LATEST_COMMIT_APPLY ]; then
    echo "Error: Git commit on origin/master($GIT_MASTER_COMMIT_ID) and latest-commit-apply($LATEST_COMMIT_APPLY) on S3 aren't equal"
    exit 1
fi
# Set env var TF_WORKING_DIR
export TF_WORKING_DIR="$(git diff origin/master --name-only | grep '\.tf$' | sed 's/\/[^/]\+\.tf$//g' | uniq)"
echo "Folders contain tf file changes:
$TF_WORKING_DIR
"
# Check if only one folder contains tf files changes
if [ $(echo "$TF_WORKING_DIR" | wc -l) -gt 1 ]; then
    echo "Error: Multiple folder contain tf file changes"
    exit 1
fi
