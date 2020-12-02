#!/usr/bin/env bash

set -e
CURRENT_DIR="$(dirname "$0")"
. ${CURRENT_DIR}/00_trap.sh

# Set CD Environment Variables:
# 1. OWNER_REPO             ${owner name}/${repo name}
# 2. GIT_COMMIT_ID          Current Commit ID
# 3. GIT_MASTER_COMMIT_ID   Previous Commit ID
# 4. GITHUB_TOKEN           Github token for Github authentication
# 5. GIT_ASKPASS            Command which called by git command to authenticate using Github token
# 6. ~/.ssh/id_rsa          Sets ssh private key for ssh git clones
# 7. PR_ID                  Github Pull Request ID from Github API

export OWNER_REPO="$(git config --get remote.origin.url | sed 's/^https:\/\/github.com\///; s/.git$//')"
echo "OWNER_REPO=${OWNER_REPO}"
export GIT_COMMIT_ID="$(git rev-parse HEAD)"
echo "GIT_COMMIT_ID=${GIT_COMMIT_ID}"
export GIT_MASTER_COMMIT_ID="$(git rev-parse HEAD^)"
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
mkdir -p ~/.ssh
SSH_PRIVATE_KEY="/tvlk-secret/terraform-ci-cd/terraform-ci-cd/github-ssh-private-key"
aws ssm get-parameters --name ${SSH_PRIVATE_KEY} --with-decryption --query "Parameters[*].{Value:Value}" --region ap-southeast-1 --output text > ~/.ssh/id_rsa || true
if [ -s ~/.ssh/id_rsa ]; then
    chmod 400 ~/.ssh/id_rsa
    eval $(ssh-agent -s)
    ssh-add /root/.ssh/id_rsa
    ssh-keyscan github.com >> ~/.ssh/known_hosts
    echo "Github ssh private key is set"
fi
# either ssh private key or app private key must be present for git clone to work
# if both exists, then it depends on how the source is written to use either
if [ ! -f "GITHUB_TOKEN" ] && [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "Either Github app private key or ssh private key must be set!"
    exit 1
fi

# Get PR_ID from Github API
export PR_ID="$(curl -s -H "Authorization: token $GITHUB_TOKEN" -X GET https://api.github.com/search/issues?q=${GIT_COMMIT_ID}+is:merged\&sort=updated\&order=desc | jq -r '.items[0].number')"
echo "PR_ID=${PR_ID}"
