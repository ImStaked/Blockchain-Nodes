# Base

## Archive Node
-  Make directory for base node data  
  ```mkdir -p /data/base/reth```

- Download the data  
  ```curl -s https://mainnet-reth-archive-snapshots.base.org/base-mainnet-reth-1743919902.tar.zst | tar -I zstd -xv -C /data/base/reth/```

- Compile Base Node  
  ```
  git clone https://github.com/base/node 
  cd node
  git checkout v0.12.0
  ```
  
- Edit .env
  ```
  CLIENT=${CLIENT:-reth}
  HOST_DATA_DIR=./${CLIENT}-data
  ```
