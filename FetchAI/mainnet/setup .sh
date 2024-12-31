#!/bin/bash

# Setup fetch node

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


# edit app.toml
sed -i "s|minimum-gas-prices = \"\"|minimum-gas-prices = \"0.002afet\"|g"  ~/.fetchd/config/app.toml
sed -i "s|pruning = \"default\"|pruning = \"everything\"|g"  ~/.fetchd/config/app.toml

# State Sync
SNAP_RPC="https://rpc-fetchhub.fetch.ai:443,https://fetch-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.fetchd/config/config.toml

# edit config.toml
sed -i "s|seeds = \"\"|seeds = \"17693da418c15c95d629994a320e2c4f51a8069b@connect-fetchhub.fetch.ai:36456,a575c681c2861fe945f77cb3aba0357da294f1f2@connect-fetchhub.fetch.ai:36457,d7cda986c9f59ab9e05058a803c3d0300d15d8da@connect-fetchhub.fetch.ai:36458\"|g"  ~/.fetchd/config/config.toml
sed -i "s|prometheus = false|prometheus = true|g"  ~/.fetchd/config/config.toml
sed -i "s|prometheus_listen_addr = \":26660\"|prometheus_listen_addr = \"$PRIVATE_IP:26660\"|g"  ~/.fetchd/config/config.toml
