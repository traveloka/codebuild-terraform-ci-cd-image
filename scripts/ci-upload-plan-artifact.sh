#!/bin/bash
# Upload Plan Artifact to S3 Bucket

aws s3 cp ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip s3://${ARTIFACT_BUCKET}/plan/${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip
