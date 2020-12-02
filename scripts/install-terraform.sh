#!/bin/bash
CURRENT_DIR="$(dirname "$0")"
. ${CURRENT_DIR}/00_trap.sh

# Install Terraform with specific version
tfenv install ${TERRAFORM_VERSION}
tfenv use ${TERRAFORM_VERSION}
