# Base Archive Node

  ## System Setup
  ```
  useradd -M -s /bin/false base
  mkdir -p /data/base
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source $HOME/.cargo/env
  apt-get install libclang-dev pkg-config build-essential -y
  cd /data/base
  ```

  ## RETH setup
  ```
  git clone https://github.com/paradigmxyz/reth && cd reth && git checkout v1.3.7
  RUSTFLAGS="-C target-cpu=native" cargo build --profile maxperf --features jemalloc,asm-keccak
  cp target/maxperf/reth /usr/local/bin/
  curl -s https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Base/reth.service --output /etc/systemd/system/reth.service
  systemctl daemon-reload && systemctl enable reth
  ```

  ## OP-NODE setup
  ```
  cd /data/base
  git clone https://github.com/ethereum-optimism/optimism && cd optimism && git checkout v1.13.0
  VERSION=v1.13.0
  make VERSION=$VERSION op-node
  cp bin/op-node /usr/local/bin/
  curl -s https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Base/.env-mainnet --output /data/base/.env.mainnet
  curl -s https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Base/op-node.service --output /etc/systemd/system/op-node.service
  systemctl daemon-reload && systemctl enable op-node
  ```

  ## GET DATA 
  - 1st download option
    ```
    curl -s https://mainnet-reth-archive-snapshots.base.org/base-mainnet-reth-1743919902.tar.zst | tar -I zstd -xv -C /data/base/reth/
    ```
  - 2nd download option 
    ```
    wget -O - https://downloads.merkle.io/reth-2025-04-07.tar.lz4 | tar -I lz4 -xvf -C /data/base/reth/
    ```
    
  ## Start services
  ```
  chown -R base:base /data/base
  systemctl start op-node && systemctl start reth
  ```
