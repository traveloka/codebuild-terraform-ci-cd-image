#!/usr/bin/env python
# Notify Plan Artifact to Github Pull Request

import os
import sys

from jinja2 import Environment, FileSystemLoader

import notify_github as gh
from contextlib import contextmanager


@contextmanager
def cwd(path):
    oldpwd = os.getcwd()
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(oldpwd)


if not os.path.isfile(os.getenv('TF_WORKING_DIR')+"/terraform.tfplan"):
    print("terraform.tfplan not found. Skipping this step")
    sys.exit(0)

# we need to change working directory so tfenv can get terraform version
# from terraform configuration or .terraform-version file
with cwd(os.getenv('TF_WORKING_DIR')):
    command = os.popen('terraform show terraform.tfplan -no-color')
    tf_plan = command.read()
    command.close()

f = open("artifact/metadata.json", "r")
metadata = f.read()

template = Environment(
    loader=FileSystemLoader(os.path.dirname(os.path.realpath(__file__)) + "/templates")
).get_template("terraform_output.j2")
message = template.render(
    metadata_json=metadata,
    file_name="terraform.tfplan",
    terraform_output=tf_plan
)

gh.send_pr_comment(payload=message)
