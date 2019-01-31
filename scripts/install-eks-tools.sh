#!/bin/bash

# Reference:
# - https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
# - https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html (Under "To install aws-iam-authenticator for Amazon EKS")

echo "Installing kubectl ..."
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
kubectl version --short --client

echo "Installing aws-iam-authenticator ..."
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
aws-iam-authenticator help
