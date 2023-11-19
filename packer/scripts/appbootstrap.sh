#!/bin/bash

### NOTE: Provisioning instance MUST have ssm access instance profile attached or this script WILL FAIL

## APP
cd ~

# Copy git SSH Keys config from SSM params 
aws ssm get-parameter --name webServerGit --with-decryption --output text --query Parameter.Value > .ssh/cfpdxserver
aws ssm get-parameter --name webClientGit --with-decryption --output text --query Parameter.Value > .ssh/cfpdxclient
chmod 600 .ssh/cfpdxserver
chmod 600 .ssh/cfpdxclient
sudo cp /tmp/sshconfig .ssh/config

# Configure Agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/cfpdxserver

# Clone server repo
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" git clone git@github.com-webserver:cfpdx/webserver.git

# Configure Agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/cfpdxclient

# Clone client repo
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" git clone git@github.com-client:cfpdx/client.git

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set node version
nvm use 18.12.0

# Build client and copy to server
cd client
npm i
npm run build

cd ~
mkdir webserver/client
cp -r client/dist/* webserver/client

# Install dependencies
cd webserver
npm i

sudo systemctl restart nginx
