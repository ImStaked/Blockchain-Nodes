# Base Archive Node

  ## System Setup
    ```
    useradd -U -m --home-dir /home/base -s /bin/bash base
    mkdir -p /data/base/.data
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    apt-get install libclang-dev pkg-config build-essential -y
    ```
  ## RETH setup
    ```
    cd /data/base
    git clone https://github.com/paradigmxyz/reth && cd reth && git checkout v1.4,3
    RUSTFLAGS="-C target-cpu=znver3" cargo install --locked --path bin/reth --bin reth --profile maxperf --features jemalloc,asm-keccak -j 10
    cp ~/.cargo/bin/reth /usr/local/bin/reth
    curl -s https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Base/reth.service --output /etc/systemd/system/reth.service
    systemctl daemon-reload && systemctl enable reth
    ```

  ## OP-NODE setup
    ```
    cd /data/base
    git clone https://github.com/ethereum-optimism/optimism && cd optimism && git checkout v1.13.2
    VERSION=v1.13.2
    just
    cp bin/op-node /usr/local/bin/
    curl -s https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Base/.env-mainnet --output /data/base/.data/.env.mainnet
    curl -s https://raw.githubusercontent.com/ImStaked/Blockchain-Nodes/refs/heads/main/Base/op-node.service --output /etc/systemd/system/op-node.service
    systemctl daemon-reload && systemctl enable op-node
    cd /data/base
    ```
    
  ## Start services
    ```
    chown -R base:base /data/base
    systemctl start op-node && systemctl start reth
    ```
