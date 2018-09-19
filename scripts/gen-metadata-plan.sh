jq -n "{
    PR_ID: \"$PR_ID\",
    GIT_MASTER_COMMIT_ID: \"$GIT_MASTER_COMMIT_ID\",
    TF_WORKING_DIR: \"$TF_WORKING_DIR\"
}" > build/metadata.json
