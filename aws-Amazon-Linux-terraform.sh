#!/bin/bash
# Install dnf config-manager to manage your repositories.
sudo dnf install -y dnf-plugins-core

# Use dnf config-manager to add the official HashiCorp Amazon Linux repository.
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform from the new repository.
sudo dnf -y install terraform

touch ~/.bashrc
terraform -install-autocomplete
#After installing autocomplete support, you will need to restart your shell to enable it.
