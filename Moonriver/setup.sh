#!/bin/bash

# Sets up an Archival Node with Tracing

# Download Binary and Install
wget https://github.com/moonbeam-foundation/moonbeam/releases/download/v0.42.1/moonbeam -O /usr/local/bin/moonbeam
sudo chmod +x /usr/local/bin/moonbeam

# Create data dir
mkdir /var/lib/moonriver-data

# Setup Service
adduser moonriver_service --system --no-create-home
sudo chown -R moonriver_service /var/lib/moonriver-data
wget https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Moonriver/moonriver.service -O /etc/systemd/system/moonriver.service

# Setup wasm overrides
git clone https://github.com/moonbeam-foundation/moonbeam-runtime-overrides.git
mv moonbeam-runtime-overrides/wasm /var/lib/moonriver-data
rm /var/lib/moonriver-data/wasm/moonbeam-runtime-* &&  rm /var/lib/moonriver-data/wasm/moonbase-runtime-*
chmod +x /var/lib/moonriver-data/wasm/*
chown moonriver_service /var/lib/moonriver-data/wasm/*

# Enable and Start
systemctl enable moonriver.service
systemctl start moonriver




















