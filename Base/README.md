# Base Archive Node

  ## System Setup
    ```
    useradd -M -s /bin/false base
    mkdir -p /data/base/.data
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    apt-get install libclang-dev pkg-config build-essential -y
    ```

  ## RETH setup
    ```
    cd /data/base
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
    curl -s https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Base/.env-mainnet --output /data/base/.data/.env.mainnet
    curl -s https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Base/op-node.service --output /etc/systemd/system/op-node.service
    systemctl daemon-reload && systemctl enable op-node
    cd /data/base
    ```

  ## DATA restore
  - Merkle.io provides an reth snapshot that it is updated 2x per week
  ```
  wget -O - https://downloads.merkle.io/reth-2025-04-07.tar.lz4 | tar -I lz4 -xvf -C /data/base/.data &
  ```
    
  ## Start services
    ```
    chown -R base:base /data/base
    systemctl start op-node && systemctl start reth
    ```
