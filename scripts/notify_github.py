#!/usr/bin/env python
# Notify Plan Artifact to Github Pull Request
from __future__ import print_function
import os
import requests
import sys


def send_pr_comment(payload):
    git_token = os.environ["GITHUB_TOKEN"]
    owner_repo = os.environ["OWNER_REPO"]
    pr_id = os.environ["PR_ID"]

    headers = {"Authorization": "token " + git_token}
    json = {
        "body": payload
    }

    github_url = "https://api.github.com/repos/{}/issues/{}/comments".format(owner_repo, pr_id)
    r = requests.post(github_url, headers=headers, json=json)
    # print(r.json)


# Send direct notification
if __name__ == '__main__':
    try:
        send_pr_comment(sys.argv[1])
    except IndexError:
        sys.exit(0)
