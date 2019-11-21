#!/usr/bin/env python
# Notify Plan Artifact to Github Pull Request

import sys
import requests
import os

command = os.popen('terraform show artifact/terraform.tfplan -no-color')
tf_plan = command.read()
command.close()

git_token = os.environ["GITHUB_TOKEN"]
owner_repo = os.environ["OWNER_REPO"]
pr_id = os.environ["PR_ID"]

f = open("artifact/metadata.json", "r")
metadata = f.read()
headers = {"Authorization": "token " + git_token}
json = {
    "body": "<details><summary>metadata.json</summary>\n\n```json\n" + metadata + "\n```\n</details><details><summary>terraform.tfplan</summary>\n\n```hcl\n" + tf_plan + "\n```\n"
}

r = requests.post('https://api.github.com/repos/' + owner_repo +
                  '/issues/' + pr_id + '/comments', headers=headers, json=json)
print r.json
