#!/usr/bin/env bash

set -e

# Set CI Environment Variables:
# 1. OWNER_REPO             ${owner name}/${repo name}
# 2. PR_ID                  Github Pull Request ID
# 3. GIT_MASTER_COMMIT_ID   Latest master commit which fetched by current build
# 4. GITHUB_TOKEN           Github token for Github authentication
# 5. GIT_ASKPASS            Command which called by git command to authenticate using Github token
# 6. ~/.ssh/id_rsa          Sets ssh private key for ssh git clones
# 7. LATEST_COMMIT_APPLY    Commit that currently applied on infra.

export OWNER_REPO="$(git config --get remote.origin.url | sed 's/^https:\/\/github.com\///; s/.git$//')"
echo "OWNER_REPO=${OWNER_REPO}"
export PR_ID="$(echo $CODEBUILD_SOURCE_VERSION | sed 's/pr\///g')"
echo "PR_ID=${PR_ID}"
export GIT_MASTER_COMMIT_ID="$(git rev-parse origin/master)"
echo "GIT_MASTER_COMMIT_ID=${GIT_MASTER_COMMIT_ID}"

# Get Temporary Github Token By using Github app private key from AWS Parameter Store
gen-github-token.py
if [ -f "GITHUB_TOKEN" ]; then
    export GITHUB_TOKEN=$(cat GITHUB_TOKEN)
    echo "GITHUB_TOKEN is set"
    export GIT_ASKPASS="parse-git-auth.sh"
    echo "GIT_ASKPASS=${GIT_ASKPASS}"
fi

# Set ssh private key, if it exists
setup-github-ssh.py
if [ -f "~/.ssh/id_rsa" ]; then
    echo "Github ssh private is set"
fi

# either ssh private key or app private key must be present for git clone to work
# if both exists, then it depends on how the source is written to use either
if [ ! -f "GITHUB_TOKEN" -a  ! -f "~/.ssh/id_rsa" ]; then
    echo "Either Github app private key or ssh private key must be set!"
    exit 1
fi

# Get latest-commit-apply from artifact S3 Bucket
# Ignore error if latest-commit-apply does not exist
aws s3 cp s3://${ARTIFACT_BUCKET}/latest-commit-apply latest-commit-apply || true
export LATEST_COMMIT_APPLY="$(cat latest-commit-apply)"
echo "LATEST_COMMIT_APPLY=${LATEST_COMMIT_APPLY}"
