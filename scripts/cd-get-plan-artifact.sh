#!/bin/bash
# Get Plan Artifact based on GIT_MASTER_COMMIT_ID and PR_ID

# Download Plan Artifact from S3 Bucket
aws s3 cp s3://${ARTIFACT_BUCKET}/plan/${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip || export SKIP_CICD=1

# Setup Working directory
# In some cases, CI won't create a plan artifact, We add "true" to prevent "test" command return 1 (and stop codebuild) when plan artifact is not found. 
# We can't stop CD codebuild even though there was an error since we have to make sure cd-upload-apply-artifact.sh executed in CD codebuild
# TO DO: refactor to utilize https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html#build-spec.phases.post_build.finally
test -s ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip && unzip ${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip -d artifact || true
