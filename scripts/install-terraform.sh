#!/bin/bash
. /usr/local/bin/00_trap.sh

### Deprecated, please state required terraform version in .terraform-version file
### (https://github.com/tfutils/tfenv#terraform-version)
# Install Terraform with specific version
tfenv install ${TERRAFORM_VERSION}
tfenv use ${TERRAFORM_VERSION}
