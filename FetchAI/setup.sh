#!/bin/bash

# Install a FetchAI node with cosmovisor so it will hopefully update itself.

PRIVATE_IP="10.0.1.3"

# Update and install prerequisites
sudo apt update && sudo apt upgrade -y
sudo apt-get install -y make gcc lz4

# Install golang version 1.23.4
wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
rm go1.23.4.linux-amd64.tar.gz

# Create user and login
useradd -U -m -d /home/fetch -s /bin/bash fetch
su fetch && cd ~

# Add go to the environment
echo "export PATH=\$PATH:/usr/local/go/bin:/home/fetch/go/bin" >> ~/.bashrc
source ~/.bashrc
go version

# Build the binary
git clone https://github.com/fetchai/fetchd.git && cd fetchd
git checkout  v0.14.0
make build
make install
fetchd version
cd ~

# Install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest

# Set env variables
export DAEMON_NAME=fetchd
export DAEMON_HOME=/home/fetch/.fetchd
export DAEMON_ALLOW_DOWNLOAD_BINARIES=true
export DAEMON_RESTART_AFTER_UPGRADE=true

# Create folders for upgrades and binaries
mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin && mkdir -p $DAEMON_HOME/cosmovisor/upgrades
cp ~/go/bin/fetchd  $DAEMON_HOME/cosmovisor/genesis/bin

# Download the snapshot and genesis
cd ~/.fetchd
wget https://snapshots.polkachu.com/snapshots/fetch/fetch_19884219.tar.lz4 -O - | lz4 -cd | tar xf -
curl https://raw.githubusercontent.com/fetchai/genesis-fetchhub/fetchhub-4/fetchhub-4/data/genesis_migrated_5300200.json --output ~/.fetchd/config/genesis.json


# Customize app.toml
sed -i "s|minimum-gas-prices = \"\"|minimum-gas-prices = \"0.002afet\"|g"  ~/.fetchd/config/app.toml
sed -i "s|pruning = \"default\"|pruning = \"everything\"|g"  ~/.fetchd/config/app.toml

# Customize config.toml
SNAP_RPC="https://rpc-fetchhub.fetch.ai:443,https://fetch-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.fetchd/config/config.toml

sed -i "s|prometheus = false|prometheus = true|g"  ~/.fetchd/config/config.toml
sed -i "s|prometheus_listen_addr = \":26660\"|prometheus_listen_addr = \"$PRIVATE_IP:26660\"|g"  ~/.fetchd/config/config.toml
