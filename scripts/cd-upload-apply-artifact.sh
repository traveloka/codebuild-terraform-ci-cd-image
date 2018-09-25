#!/bin/bash
# Upload Apply Artifact to S3 Bucket

aws s3 cp ${GIT_COMMIT_ID}.zip s3://${ARTIFACT_BUCKET}/apply/${GIT_COMMIT_ID}.zip
