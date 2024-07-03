#!/usr/bin/env bash

set -xe

# Copy config files to VM
set USER_HOME=/home/vagrant
cp /vagrant/.tmux.conf $USER_HOME/.tmux.conf
cp /vagrant/.bashrc $USER_HOME/.bashrc
cp -r /vagrant/nvim $USER_HOME/.config/

# Source configs
source $USER_HOME/.bashrc

# Install necessary packages
sudo apt-get update

# Dev Tools
sudo apt-get install -y build-essential cmake autoconf libtool pkg-config git curl

# Docker
# Add Docker's official GPG key:
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create docker group
sudo groupadd docker || true
sudo usermod -aG docker $USER
newgrp docker

# Go
sudo apt-get install -y golang-go

# Neovim
sudo apt-get install -y gettext
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=Release
make install
sudo apt-get install -y ripgrep

# Tmux
sudo apt-get install -y tmux
