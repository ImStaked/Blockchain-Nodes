### Compile Tracing Binary

- Rust and tools
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
apt install clang protobuf-compiler libprotobuf-dev pkg-config libssl-dev -y 
```

- Compile Binary
```
git clone https://github.com/darwinia-network/darwinia && cd darwinia
git checkout v7.0.0
cargo build --release --locked -p darwinia --features darwinia-runtime,crab-runtime,evm-tracing
cp target/release/darwinia /usr/local/bin/darwinia
```

- The binary can also be downloaded 
```
wget https://github.com/darwinia-network/darwinia/releases/download/v6.7.1/darwinia-tracing-x86_64-linux-gnu.tar.zst
tar -I zstd -xf darwinia-tracing-x86_64-linux-gnu.tar.zst
``` 

- Chainspec
```
darwinia build-chainspec
```

- Get overridden-runtimes
```
mkdir run-evm-tracing-node && cd run-evm-tracing-node
mkdir /home/darwinia/.data/overridden-runtimes 
git clone https://github.com/darwinia-network/darwinia-release.git
cd darwinia-release
git checkout origin/darwinia
# Copy the wasm runtime files to the temporary workaround override runtime location 
cp wasm/evm-tracing/* /home/darwinia/.data/overridden-runtimes
```
