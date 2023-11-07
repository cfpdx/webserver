#!/bin/bash

### NOTE: Provisioning instance MUST have ssm access instance profile attached or this script WILL FAIL

## APP
cd ~

# Copy git SSH Keys config from SSM params 
aws ssm get-parameter --name webServerGit --with-decryption --output text --query Parameter.Value > .ssh/cfpdxserver
aws ssm get-parameter --name webServerGit --with-decryption --output text --query Parameter.Value > .ssh/cfpdxclient
chmod 600 .ssh/cfpdxserver
chmod 600 .ssh/cfpdxclient
sudo cp /tmp/sshconfig .ssh/config

# Configure Agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/cfpdxserver
ssh-add ~/.ssh/cfpdxclient

# Clone application repos
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" git clone git@github.com-webserver:cfpdx/webserver.git
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" git clone git@github.com-client:cfpdx/client.git

cd webserver

# Install essential application packages
sudo npm ci

sudo systemctl restart nginx