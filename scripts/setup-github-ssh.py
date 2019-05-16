#!/usr/bin/env python

import boto3

ssm_key = "/tvlk-secret/terraform-ci-cd/terraform-ci-cd/github-ssh-private-key"
print "Looking for ssh private key at " + ssm_key

client = boto3.client('ssm')
parameter_store = client.get_parameter(
    Name=ssm_key,
    WithDecryption=True
)

github_ssh_private_key = parameter_store["Parameter"]["Value"]

# ignore setting ssh private key if there is no ssh private key set in the SSM
if not github_ssh_private_key:
    print "There is no ssh private key set"
    sys.exit(0)


import os

id_rsa = os.path.expanduser('~/.ssh/id_rsa')

if not os.path.exists(os.path.dirname(id_rsa)):
	os.makedirs(os.path.dirname(id_rsa))

with open(id_rsa, "w") as f:
    f.write(github_ssh_private_key)

os.chmod(id_rsa, 0600)

known_hosts = os.path.expanduser('~/.ssh/known_hosts')
os.system("ssh-keyscan github.com >> " + known_hosts)