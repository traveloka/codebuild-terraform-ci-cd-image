#!/usr/bin/env python
from __future__ import print_function
from jinja2 import Environment, FileSystemLoader
import notify_github as gh
import sys
import os


try:
    f = open("/tmp/errMsg.log", "r")
    error = f.read()
except IOError:
    sys.exit(0)

template = Environment(
    loader=FileSystemLoader(os.path.dirname(os.path.realpath(__file__))+"/templates")
).get_template("error.j2")

message = template.render(
    error_title=sys.argv[1],
    error_description=sys.argv[2],
    error=error
)

gh.send_pr_comment(payload=message)
