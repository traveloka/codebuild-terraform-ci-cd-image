#!/bin/bash
CURRENT_DIR="$(dirname "$0")"
. ${CURRENT_DIR}/00_trap.sh

# Create Apply Artifact
if [ $SKIP_CICD -eq 1 ]; then
  echo "Skipping this step"
  exit 0
fi

# Create new metadata.json
jq ". + {
    GIT_COMMIT_ID: \"$GIT_COMMIT_ID\"
}" artifact/metadata.json > artifact/metadata-apply.json
mv artifact/metadata-apply.json artifact/metadata.json

# Create artifact
cd artifact
zip -r ../${GIT_COMMIT_ID}.zip .
cd ..
