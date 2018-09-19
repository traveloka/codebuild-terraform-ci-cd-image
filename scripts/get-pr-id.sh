curl -H "Authorization: token $GITHUB_TOKEN" -X GET https://api.github.com/search/issues?q=${GIT_COMMIT_ID}+is:merged
export PR_ID="$(curl -H \"Authorization: token $GITHUB_TOKEN\" -X GET https://api.github.com/search/issues?q=${GIT_COMMIT_ID}+is:merged\&sort=updated\&order=desc | jq -r '.items[0].number')"
echo "PR_ID=$PR_ID"
