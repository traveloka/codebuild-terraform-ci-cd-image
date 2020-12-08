#!/usr/bin/env python
# Notify Plan Artifact to Github Pull Request

import os
import sys

from jinja2 import Environment, FileSystemLoader

import notify_github as gh

metadata = dict()
tf_out = "this operation does nothing!"

if os.path.isfile('/tmp/tfApplyOutput'):
    tf_out = open("/tmp/tfApplyOutput", "r")
    tf_out = tf_out.read()

if os.path.isfile('artifact/metadata.json'):
    f = open("artifact/metadata.json", "r")
    metadata = f.read()

template = Environment(
    loader=FileSystemLoader(os.path.dirname(os.path.realpath(__file__)) + "/templates")
).get_template("terraform_output.j2")
message = template.render(
    file_name="terraform.output",
    metadata_json=metadata,
    terraform_output=tf_out
)

gh.send_pr_comment(payload=message)
