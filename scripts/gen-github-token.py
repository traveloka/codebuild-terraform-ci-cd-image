import boto3
import json
import jwt
import os
import requests
import sys
import time

client = boto3.client('ssm')

parameter_store = client.get_parameter(
    Name = "/tvlk-secret/terraform-ci-cd/terraform-ci-cd/github-app-private-key",
    WithDecryption = True
)

github_app_private_key = parameter_store["Parameter"]["Value"]

payload = {
  # issued at time
  "iat": int(time.time()),
  # JWT expiration time (10 minute maximum)
  "exp": int(time.time()) + (10 * 60),
  # GitHub App's identifier
  "iss": 17077
}
github_jwt = jwt.encode(payload, github_app_private_key, algorithm="RS256")

headers = {
    "Authorization": "Bearer " + github_jwt,
    "Accept": "application/vnd.github.machine-man-preview+json"
}

r = requests.post("https://api.github.com/app/installations/328056/access_tokens", headers=headers)

github_token = json.loads(r.text)["token"]

if r.status_code != 201:
    print r.text
    sys.exit(1)

f = open("GITHUB_TOKEN", "w")
f.write(github_token)
