#!/bin/bash
# Update the installed packages and package cache on your instance.
sudo yum update -y
# Install the most recent Docker Community Edition package.
sudo yum install -y docker
# Start the Docker service.
sudo service docker start
# Enable Docker to start on boot
sudo service docker enable
# Add the ec2-user to the docker group so that you can run Docker commands without using sudo.
sudo usermod -a -G docker ec2-user
newgrp docker
# Installing Docker Compose
sudo dnf install -y docker-compose-plugin
