#!/usr/bin/env bash

set -xe

# Copy config files to VM
export USER_HOME=/home/vagrant
export END_USER=vagrant
cp /vagrant/.tmux.conf $USER_HOME/.tmux.conf
chown $END_USER:$END_USER $USER_HOME/.tmux.conf
cp /vagrant/.bashrc $USER_HOME/.bashrc
chown $END_USER:$END_USER $USER_HOME/.bashrc
mkdir -p $USER_HOME/.config
cp -r /vagrant/nvim $USER_HOME/.config/nvim
chown -R $END_USER:$END_USER $USER_HOME/.config/nvim

# Install necessary packages
echo "Updating base packages"
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null

# Dev Tools
echo "Installing dev tools"
sudo apt-get install -y build-essential cmake autoconf libtool pkg-config git curl unzip wget gcc-multilib > /dev/null

# Docker
echo "Installing Docker"
# Add Docker's official GPG key:
sudo apt-get install -y ca-certificates curl > /dev/null
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update > /dev/null
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null

# Create docker group
sudo groupadd docker || true
sudo usermod -aG docker $END_USER
newgrp docker

# Go
echo "Installing Golang"
export GO_TAR=go1.22.5.linux-386.tar.gz
curl --fail --remote-name --location --continue-at - https://go.dev/dl/$GO_TAR
rm -rf /usr/local/go && tar -C /usr/local -xzf $GO_TAR

# Neovim
echo "Installing Neovim"
sudo apt-get install -y gettext ripgrep fd-find > /dev/null
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# Lua
echo "Installing Lua"
curl -L -R -O https://www.lua.org/ftp/lua-5.4.7.tar.gz
tar zxf lua-5.4.7.tar.gz
pushd lua-5.4.7
make all test
sudo make install
popd

echo "Installing LuaRocks"
curl -L -R -O http://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz
tar xzf luarocks-3.11.1.tar.gz
pushd luarocks-3.11.1
./configure --with-lua-include=/usr/local/include
make
sudo make install

# Tmux
echo "Installing tmux"
sudo apt-get install -y tmux > /dev/null
# tpm
git clone https://github.com/tmux-plugins/tpm $USER_HOME/.tmux/plugins/tpm
chown -R $END_USER:$END_USER $USER_HOME/.tmux
