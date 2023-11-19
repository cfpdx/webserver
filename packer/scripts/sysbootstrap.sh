#!/bin/bash

## SYSTEM
# Update the package list and upgrade installed packages
sudo apt update
sudo apt upgrade -y -q

# Install essential build tools and libraries
sudo apt install -y -q build-essential nginx nmap jq unzip
sudo apt install net-tools

## CONFIG
# Install CLI to pull git ssh config from SSM
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install

# PROXY
# Kick start server config to run on boot
sudo systemctl start nginx
sudo systemctl enable nginx
# Overwrite the default nginx settings
sudo cp /tmp/cfpdxweb.config /etc/nginx/sites-available/cfpdxweb.config
sudo ln -s /etc/nginx/sites-available/cfpdxweb.config /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-available/default
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full'
cd ~

# Install Node.js and npm using nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 18.12.0
nvm use 18.12.0
