#!/usr/bin/env bash

set -xe

# Copy config files to VM
export USER_HOME=/home/vagrant
export END_USER=vagrant
cp /vagrant/.tmux.conf $USER_HOME/.tmux.conf
cp /vagrant/.bashrc $USER_HOME/.bashrc
mkdir -p $USER_HOME/.config
cp -r /vagrant/nvim $USER_HOME/.config/nvim

# Install necessary packages
sudo apt-get update

# Dev Tools
sudo apt-get install -y build-essential cmake autoconf libtool pkg-config git curl unzip wget

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
sudo usermod -aG docker $END_USER
newgrp docker

# Go
export GO_TAR=go1.22.5.linux-386.tar.gz
curl --fail --remote-name --location --continue-at - https://go.dev/dl/$GO_TAR
rm -rf /usr/local/go && tar -C /usr/local -xzf $GO_TAR
cat << EOF >> $USER_HOME/.bashrc
export PATH=$PATH:/usr/local/go/bin
EOF

# Neovim
sudo apt-get install -y gettext ripgrep
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
cat << EOF >> $USER_HOME/.bashrc
export PATH="$PATH:/opt/nvim-linux64/bin"
EOF

# Tmux
sudo apt-get install -y tmux
