#!/bin/bash
# Update latest-commit-apply on S3 Bucket

echo "$GIT_COMMIT_ID" > latest-commit-apply
aws s3 cp latest-commit-apply s3://${ARTIFACT_BUCKET}/latest-commit-apply
