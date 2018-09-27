#!/bin/bash
# Set CD Environment Variables:
# 1. OWNER_REPO             ${owner name}/${repo name}
# 2. GIT_COMMIT_ID          Current Commit ID
# 3. GIT_MASTER_COMMIT_ID   Previous Commit ID
# 4. GITHUB_TOKEN           Github token for Github authentication
# 5. GIT_ASKPASS            Command which called by git command to authenticate using Github token
# 6. PR_ID                  Github Pull Request ID from Github API

export OWNER_REPO="$(git config --get remote.origin.url | sed 's/^https:\/\/github.com\///; s/.git$//')"
echo "OWNER_REPO=${OWNER_REPO}"
export GIT_COMMIT_ID="$(git rev-parse HEAD)"
echo "GIT_COMMIT_ID=${GIT_COMMIT_ID}"
export GIT_MASTER_COMMIT_ID="$(git rev-parse HEAD^)"
echo "GIT_MASTER_COMMIT_ID=${GIT_MASTER_COMMIT_ID}"

# Get Temporary Github Token By using Github app private key from AWS Parameter Store
gen-github-token.py
export GITHUB_TOKEN=$(cat GITHUB_TOKEN)
echo "GITHUB_TOKEN is set"
export GIT_ASKPASS="parse-git-auth.sh"
echo "GIT_ASKPASS=${GIT_ASKPASS}"

# Get PR_ID from Github API
curl -H "Authorization: token $GITHUB_TOKEN" -X GET https://api.github.com/search/issues?q=${GIT_COMMIT_ID}+is:merged
export PR_ID="$(curl -H \"Authorization: token $GITHUB_TOKEN\" -X GET https://api.github.com/search/issues?q=${GIT_COMMIT_ID}+is:merged\&sort=updated\&order=desc | jq -r '.items[0].number')"
echo "PR_ID=${PR_ID}"
