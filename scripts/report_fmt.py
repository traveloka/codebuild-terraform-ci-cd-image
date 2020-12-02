#!/usr/bin/env python
from __future__ import print_function
from jinja2 import Environment, FileSystemLoader
import notify_github as gh
import sys
import os

template = Environment(
    loader=FileSystemLoader(os.path.dirname(os.path.realpath(__file__))+"/templates")
).get_template("terraform_fmt.j2")

message = template.render(
    fmt_status="error",
    diff=sys.argv[1],
)

gh.send_pr_comment(payload=message)
