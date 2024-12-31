#!/bin/bash
# Instructions
# https://github.com/comdex-official/networks/blob/main/mainnet/02-validator-post-gentx.md


git clone https://github.com/comdex-official/comdex.git && cd comdex
git fetch --tags
git checkout v13.4.0
go mod vendor
make build
make install


comdex init ImStaked --chain-id comdex-1

rm ~/.comdex/config/genesis.json
curl https://raw.githubusercontent.com/comdex-official/networks/main/mainnet/comdex-1/genesis.json > ~/.comdex/config/genesis.json


sed -i "s|seeds = \"\"|seeds = \"bca2cf752ee34472c42ab96503fd10ef25d921c1@46.166.172.232:2014\"|g"  ~/.fetchd/config/config.toml
sed -i "s|persistent_peers = \"\"|persistent_peers = \"f7fb364f9a73c1e294deb7c99d0e630fd849e1ae@3.110.67.238:26656,c71be7ba7eddac04723bc5bfbd0c6d9ae1ddc115@34.244.204.76:26656,e091e09473674dfdf46e67333bb664aa2b2b7e14@3.236.44.146:26656,0b88c5f8f653df0dcef75f47de8587fa4c46e3a4@188.214.134.115:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656\"|g"  ~/.comdex/config/config.toml
sed -i "s|minimum-gas-prices = \"\"|minimum-gas-prices = \"2ucmdx\"|g"  ~/.comdex/config/config.toml


mkdir -p ~/.comdex/cosmovisor
mkdir -p ~/.comdex/cosmovisor/genesis
mkdir -p ~/.comdex/cosmovisor/genesis/bin
mkdir -p ~/.comdex/cosmovisor/upgrades

go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest

echo "export DAEMON_NAME=comdex" >> ~/.profile
echo "export DAEMON_HOME=$HOME/.comdex" >> ~/.profile
echo "export DAEMON_ALLOW_DOWNLOAD_BINARIES=false" >> ~/.profile
echo "export DAEMON_LOG_BUFFER_SIZE=512" >> ~/.profile
echo "export DAEMON_RESTART_AFTER_UPGRADE=true" >> ~/.profile
echo "export UNSAFE_SKIP_BACKUP=true" >> ~/.profile
source ~/.profile
