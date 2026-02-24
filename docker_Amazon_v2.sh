# Update the System
sudo dnf update -y
# Install Docker
sudo dnf install -y docker
# Start and Enable Docker
sudo systemctl start docker
sudo systemctl enable docker
# Add Your User to the Docker Group
sudo usermod -aG docker $USER
newgrp docker

############## Install Docker Compose
# Create the CLI plugins directory
mkdir -p ~/.docker/cli-plugins
# Download the Docker Compose plugin
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
# Make it executable
chmod +x ~/.docker/cli-plugins/docker-compose
# Verify installation
docker compose version
