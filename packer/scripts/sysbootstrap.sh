#!/bin/bash

## SYSTEM
# Update the package list and upgrade installed packages
sudo apt-get update
sudo apt-get upgrade -y -q

# Install essential build tools and libraries
sudo apt-get install -y -q build-essential nginx nodejs npm nmap jq unzip
sudo apt install net-tools

## PROXY
# Kick start server config to run on boot
sudo systemctl start nginx
sudo systemctl enable nginx
# Overwrite the default nginx settings
sudo cp /tmp/cfpdxweb.config /etc/nginx/sites-available/cfpdxweb.config
sudo ln -s /etc/nginx/sites-available/cfpdxweb.config /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-available/default # not sure if we need to do this but leaving for now
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full'
cd ~

## CONFIG
# Install CLI to pull git ssh config from SSM
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
