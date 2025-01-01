### Compile Tracing Binary

- Rust and tools
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
apt install clang protobuf-compiler libprotobuf-dev pkg-config libssl-dev -y 
```


- Get code
```
git clone https://github.com/darwinia-network/darwinia && cd darwinia
```

- Compile
```
cargo build --release --locked -p darwinia --features darwinia-runtime,crab-runtime,evm-tracing
cp target/release/darwinia /usr/local/bin/darwinia
```


- Chainspec
```
darwinia build-chainspec
```
