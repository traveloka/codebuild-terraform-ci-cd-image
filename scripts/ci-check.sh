#!/bin/bash
# Check CI prerequisites to do Terraform commands and set env var TF_WORKING_DIR

exitCode=0
fmtExitCode=0

# Check if current commit is based on latest master commit on repo
git merge-base --is-ancestor origin/master HEAD
if [ $? -ne 0 ]; then
    notify_github.py "- Error: Feature branch is behind the latest master branch commit. Please rebase/add merge commit from master to your feature branch"
    exit 1
fi

# Set env var TF_WORKING_DIR
export TF_WORKING_DIR="$(git diff origin/master --name-only | grep '\.tf$\|\.tpl$' | sed 's/\/[^/]\+\.tf$\|\/[^/]\+\.tpl$//g' | uniq)"
tf_working_dir_num="$(wc -l <<<"${TF_WORKING_DIR}")"
echo "Folders contain tf file changes: $TF_WORKING_DIR"

# Check if there is folder contains tf files changes
if [ -z "$TF_WORKING_DIR" ]; then
    notify_github.py "- PR does not contain terraform code changes. Will do nothing"
    export SKIP_CICD=1
    exit 0
fi

# Check if latest master commit on repo and commit on current infra state on S3 bucket are equal/same
if [ $GIT_MASTER_COMMIT_ID != $LATEST_COMMIT_APPLY ]; then
    echo "Error: Git commit on origin/master($GIT_MASTER_COMMIT_ID) and latest-commit-apply($LATEST_COMMIT_APPLY) on S3 aren't equal"  | tee -a /tmp/errMsg.log
    exitCode=1
fi

# Check if only one folder contains tf files changes
if [ $tf_working_dir_num -gt 1 ]; then
    echo "Error: Multiple folder contain tf file changes" | tee -a /tmp/errMsg.log
    exitCode=1
fi

# Only execute this if exitCode == 0
if [ $exitCode -eq 0 ] && [ ! -d "$TF_WORKING_DIR" ]; then
    echo "${TF_WORKING_DIR//\\n/;} folder is deleted. Will do nothing" | tee -a /tmp/errMsg.log
    export TF_WORKING_DIR=""
    export SKIP_CICD=1
fi

# Only execute this if exitCode == 0
if [ $exitCode -eq 0 ] && [ -n "$TF_WORKING_DIR" ]; then
  fmtOutput=$(terraform fmt -check=true -write=false -diff $TF_WORKING_DIR 2>&1)
  fmtExitCode=$?
  if [ $fmtExitCode -ne 0 ]; then
    echo "Error: Terraform files are incorrectly formatted. Please run: terraform fmt" | tee -a /tmp/errMsg.log
    exitCode=1
  fi
fi

if [ $exitCode -ne 0 ]; then
  report_error.py "ci-check.sh" "Failed"
  if [ $fmtExitCode -ne 0 ]; then
    report_fmt.py "${fmtOutput}"
  fi
  exit $exitCode
fi