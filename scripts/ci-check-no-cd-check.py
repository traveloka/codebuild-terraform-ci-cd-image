#!/bin/bash
# Check CI prerequisites to do Terraform commands and set env var TF_WORKING_DIR

# Check if current commit is based on latest master commit on repo
git merge-base --is-ancestor origin/master HEAD
if [ $? -ne 0 ]; then
    echo "Error: Feature branch is behind the latest master branch commit. Please rebase/add merge commit from master to your feature branch"
    exit 1
fi

# Warn if last applied terraform is not master latest commit
if [ $GIT_MASTER_COMMIT_ID != $LATEST_COMMIT_APPLY ]; then
    echo "Warning: Git commit on origin/master($GIT_MASTER_COMMIT_ID) and latest-commit-apply($LATEST_COMMIT_APPLY) on S3 aren't equal"
fi

# Set env var TF_WORKING_DIR
export TF_WORKING_DIR="$(git diff origin/master --name-only | grep '\.tf$\|\.tpl$' | sed 's/\/[^/]\+\.tf$\|\/[^/]\+\.tpl$//g' | uniq)"
echo "Folders contain tf file changes:
$TF_WORKING_DIR
"

# Check if only one folder contains tf files changes
if [ $(echo "$TF_WORKING_DIR" | wc -l) -gt 1 ]; then
    echo "Error: Multiple folder contain tf file changes"
    exit 1
fi
if [ ! -d "$TF_WORKING_DIR" ]; then
    echo "$TF_WORKING_DIR folder is deleted. Will do nothing"
    export TF_WORKING_DIR=""
fi
