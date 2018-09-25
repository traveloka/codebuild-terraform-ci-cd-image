#!/bin/bash
# Get Plan Artifact

# Download Plan Artifact from S3 Bucket
aws s3 cp s3://${ARTIFACT_BUCKET}/plan/${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip
# Setup Working directory
unzip ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip -d artifact
