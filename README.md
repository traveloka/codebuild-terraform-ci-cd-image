# codebuild-terraform-ci-cd-image
Docker image for Terrafocm CI/CD CodeBuild builds

## Prerequisites to using this image

* Github app private key
  - Either this or both of this and a Github ssh private key must be set
  - Github app private key must be set in your AWS ssm with the key 
    `/tvlk-secret/terraform-ci-cd/terraform-ci-cd/github-app-private-key`

* Github app ssh key
  - Either this or both of this and a Github app private key must be set
  - This ssh private key must be set in your AWS ssm with the key 
    `/tvlk-secret/terraform-ci-cd/terraform-ci-cd/github-ssh-private-key`
  - The public key portion must be added to a user with access to all of the 
    git repositories mentioned in the projects you are trying to build
  - The recommendation is to create a github 
    [machine user](https://developer.github.com/v3/guides/managing-deploy-keys/#machine-users),
    add the user to the github Traveloka organization and add this ssh public 
    key to it