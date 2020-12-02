#!/bin/bash
CURRENT_DIR="$(dirname "$0")"
. ${CURRENT_DIR}/00_trap.sh

# Get Plan Artifact based on GIT_MASTER_COMMIT_ID and PR_ID

# Download Plan Artifact from S3 Bucket
aws s3 cp s3://${ARTIFACT_BUCKET}/plan/${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip

# Setup Working directory
unzip ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip -d artifact
