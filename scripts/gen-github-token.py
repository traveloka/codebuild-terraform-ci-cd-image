#!/usr/bin/env python
from __future__ import print_function
import boto3
import sys


ssm_key = "/tvlk-secret/terraform-ci-cd/terraform-ci-cd/github-app-private-key"
print("Looking for app private key at " + ssm_key)

client = boto3.client('ssm')
parameter_store = client.get_parameter(
    Name="/tvlk-secret/terraform-ci-cd/terraform-ci-cd/github-app-private-key",
    WithDecryption=True
)

# ignore setting app private key if there is no app private key set in the SSM
github_app_private_key = parameter_store["Parameter"]["Value"]
if not github_app_private_key:
    print("There is no app private key set")
    sys.exit(0)


import json
import jwt
import os
import requests
import time

github_app_id = os.environ["GITHUB_APP_ID"]
github_app_installation_id = os.environ["GITHUB_APP_INSTALLATION_ID"]

payload = {
    # issued at time
    "iat": int(time.time()),
    # JWT expiration time (10 minute maximum)
    "exp": int(time.time()) + (10 * 60),
    # GitHub App's identifier
    "iss": github_app_id
}
github_jwt = jwt.encode(payload, github_app_private_key, algorithm="RS256")

headers = {
    "Authorization": "Bearer " + github_jwt,
    "Accept": "application/vnd.github.machine-man-preview+json"
}

r = requests.post(
    "https://api.github.com/app/installations/" + github_app_installation_id + "/access_tokens", headers=headers)

if r.status_code != 201:
    print("Unable to retrieve access token with github app private key, reason: ")
    print(r.text)
    sys.exit(1)

github_token = json.loads(r.text)["token"]

f = open("GITHUB_TOKEN", "w")
f.write(github_token)
