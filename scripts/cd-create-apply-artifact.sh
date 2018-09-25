#!/bin/bash
# Create Apply Artifact

# Create new metadata.json
jq ". + {
    GIT_COMMIT_ID: \"$GIT_COMMIT_ID\"
}" artifact/metadata.json > artifact/metadata-apply.json
mv artifact/metadata-apply.json artifact/metadata.json

# Create artifact
cd artifact
zip -r ../${GIT_COMMIT_ID}.zip .
cd ..
