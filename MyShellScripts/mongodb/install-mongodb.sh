#!/bin/bash

################################################################################
# Script Name: install-mongodb.sh
# Author: Abhiram Das
# Version: 1.0
# Description: This script installs and tests MongoDB Community Edition on Ubuntu 20.04 or later.
# License: MIT
################################################################################


OS_NAME=$(grep ^NAME= /etc/os-release | cut -d'"' -f2)
OS_VERSION=$(grep ^VERSION_ID= /etc/os-release | cut -d'"' -f2 | cut -d'.' -f1)

if [[ "$OS_NAME" != "Ubuntu" || "$OS_VERSION" -lt 20 ]]; then
  echo "This script supports Ubuntu 20.04 or later only."
  exit 1
fi


# Remove existing MongoDB GPG key
sudo rm -f /usr/share/keyrings/mongodb-server-6.0.gpg

# Update package index
sudo apt update

# Add MongoDB GPG key
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg

# Verify the key was added
ls -l /usr/share/keyrings/mongodb-server-6.0.gpg

# Add MongoDB repository
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu $UBUNTU_VERSION/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Update package index again
sudo apt update

# Install MongoDB with insecure repositories allowed
sudo apt update --allow-insecure-repositories
sudo apt install -y mongodb-org --allow-unauthenticated

# Test MongoDB installation
mongosh
