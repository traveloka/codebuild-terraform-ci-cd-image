#!/bin/bash
. /usr/local/bin/00_trap.sh

if [ $SKIP_CICD -eq 1 ]; then
  echo "Skipping this step"
  exit 0
fi

# Upload Apply Artifact to S3 Bucket
aws s3 cp ${GIT_COMMIT_ID}.zip s3://${ARTIFACT_BUCKET}/apply/${GIT_COMMIT_ID}.zip
