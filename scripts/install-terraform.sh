#!/bin/bash
. /usr/local/bin/00_trap.sh

# Install Terraform with specific version
tfenv install ${TERRAFORM_VERSION}
tfenv use ${TERRAFORM_VERSION}
