jq ". + {
    GIT_COMMIT_ID: \"$GIT_COMMIT_ID\"
    }" build/metadata.json > build/metadata-apply.json
mv build/metadata-apply.json build/metadata.json
