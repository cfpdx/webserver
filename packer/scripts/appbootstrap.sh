#!/bin/bash

### NOTE: Provisioning instance MUST have ssm access instance profile attached or this script WILL FAIL

## APP
cd ~

# Copy git SSH Key config from SSM params 
aws ssm get-parameter --name webGitSSH --with-decryption --output text --query Parameter.Value > .ssh/gitkey
chmod 600 .ssh/gitkey
sudo cp /tmp/sshconfig .ssh/config

# Configure Agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/gitkey

# Clone application repo
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" git clone git@github.com:sherretten/cfpdx-web.git
cd cfpdx-web

# Install essential application packages
sudo npm ci

sudo systemctl restart nginx