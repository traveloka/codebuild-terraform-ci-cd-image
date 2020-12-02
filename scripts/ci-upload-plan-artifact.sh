#!/bin/bash
# Upload Plan Artifact to S3 Bucket

set -e
CURRENT_DIR="$(dirname "$0")"
. ${CURRENT_DIR}/00_trap.sh

aws s3 cp ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip s3://${ARTIFACT_BUCKET}/plan/${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip
